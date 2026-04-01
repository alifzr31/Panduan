// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:panduan/app/configs/dio/exceptions.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart' as di;
import 'package:panduan/app/configs/secure_storage/secure_storage.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/app_strings.dart';

class DioInterceptors extends InterceptorsWrapper {
  final Dio dio;
  final Dio refreshDio = Dio(
    BaseOptions(
      baseUrl: AppEnv.baseOwnerUrl,
      connectTimeout: const Duration(minutes: 5),
      receiveTimeout: const Duration(minutes: 5),
      headers: AppHelpers.addOnHeaders(),
    ),
  );
  bool isRefreshing = false;
  List<Function(String token)> requestQueue = [];

  DioInterceptors(this.dio);

  Future<void> _onRefreshToken(
    RequestOptions request,
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final refreshToken = await SecureStorage.readStorage(
        key: AppStrings.refreshToken,
      );

      if (refreshToken == null) {
        requestQueue.clear();
        di.sl<AuthCubit>().logoutSession();

        return handler.next(err);
      }

      final response = await refreshDio.post(
        '/refresh-token',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.data['status']) {
        final newAccessToken = response.data['data']['access_token'];
        final newRefreshToken = response.data['data']['refresh_token'];

        await Future.wait([
          SecureStorage.writeStorage(
            key: AppStrings.accessToken,
            value: newAccessToken,
          ),
          SecureStorage.writeStorage(
            key: AppStrings.refreshToken,
            value: newRefreshToken,
          ),
        ]);

        request.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await dio.fetch(request);

        await Future.wait(
          requestQueue.map((callback) => callback(newAccessToken)),
        );

        requestQueue.clear();

        return handler.resolve(retryResponse);
      } else {
        return handler.next(err);
      }
    } catch (e) {
      requestQueue.clear();
      di.sl<AuthCubit>().logoutSession();

      return handler.next(err);
    } finally {
      isRefreshing = false;
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // print('ERROR STATUS CODE: ${err.response?.statusCode}');
    // print('ERROR STATUS DATA: ${err.response?.data}');

    if (err.response?.statusCode == 401) {
      final request = err.requestOptions;

      if (isRefreshing) {
        final completer = Completer<Response>();

        requestQueue.add((token) async {
          try {
            request.headers['Authorization'] = 'Bearer $token';
            final response = await dio.fetch(request);
            completer.complete(response);
          } catch (e) {
            completer.completeError(e);
          }
        });

        return handler.resolve(await completer.future);
      }

      isRefreshing = true;

      await _onRefreshToken(request, err, handler);
    }

    if (err.error is SocketException) {
      return handler.reject(
        DeadlineExceededException(err.requestOptions, err.response),
      );
    } else {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.connectionError:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return handler.reject(
            DeadlineExceededException(err.requestOptions, err.response),
          );
        case DioExceptionType.badResponse:
          switch (err.response?.statusCode) {
            case 400:
              return handler.reject(
                BadRequestException(err.requestOptions, err.response),
              );
            case 401:
              return handler.reject(
                UnauthorizedException(err.requestOptions, err.response),
              );
            case 404:
              return handler.reject(
                NotFoundException(err.requestOptions, err.response),
              );
            case 409:
              return handler.reject(
                ConflictException(err.requestOptions, err.response),
              );
            case 500:
              return handler.reject(
                InternalServerErrorException(err.requestOptions, err.response),
              );
          }
          break;
        case DioExceptionType.cancel:
          return handler.next(err);
        case DioExceptionType.unknown:
          return handler.reject(
            NoInternetConnectionException(err.requestOptions, err.response),
          );
        case DioExceptionType.badCertificate:
          break;
      }
    }

    handler.next(err);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // print("--> ${options.method} ${options.uri}");
    // print("Headers: ${options.headers}");
    // print("Body: ${options.data}");
    String? accessToken = await SecureStorage.readStorage(
      key: AppStrings.accessToken,
    );

    if (accessToken != null) {
      if (options.path != '/refresh-token') {
        final authHeader = {'Authorization': 'Bearer $accessToken'};
        options.headers.addEntries(authHeader.entries);
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print("<-- ${response.statusCode} ${response.requestOptions.uri}");
    // print("Headers: {${response.headers}}");
    // print("Response: ${response.data}");

    handler.next(response);
  }
}
