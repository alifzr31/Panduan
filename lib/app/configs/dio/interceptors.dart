// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:panduan/app/configs/dio/exceptions.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart';
import 'package:panduan/app/configs/storage/storage_service.dart';
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

  void _onUnauthorized(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions.copyWith();

    if (request.extra['isRetry'] == true) {
      sl<AuthCubit>().logoutSession();
      return handler.reject(err);
    }

    if (isRefreshing) {
      final completer = Completer<Response>();

      requestQueue.add((token) async {
        try {
          final newRequest = request.copyWith(
            headers: {...request.headers, 'Authorization': 'Bearer $token'},
            extra: {...request.extra, 'isRetry': true},
          );

          final response = await dio.fetch(newRequest);
          completer.complete(response);
        } catch (e) {
          completer.completeError(e);
        }
      });

      return handler.resolve(await completer.future);
    }

    isRefreshing = true;

    await _onRefreshToken(request, err, handler);
    return;
  }

  Future<void> _onRefreshToken(
    RequestOptions request,
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final accessToken = sl<AuthCubit>().accessToken;
      final refreshToken = sl<AuthCubit>().refreshToken;

      if (accessToken == null || refreshToken == null) {
        requestQueue.clear();
        sl<AuthCubit>().logoutSession();

        return handler.reject(
          UnauthorizedException(err.requestOptions, err.response),
        );
      }

      final response = await refreshDio.post(
        '/refresh-token',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {'refresh_token': refreshToken},
      );

      if (response.data['status']) {
        final newAccessToken = response.data['data']['access_token'];
        final newRefreshToken = response.data['data']['refresh_token'];

        final rawToken = {
          AppStrings.accessToken: newAccessToken,
          AppStrings.refreshToken: newRefreshToken,
        };
        final token = jsonEncode(rawToken);

        final isSaved = await StorageService.writeAppToken(newAppToken: token);

        if (isSaved) {
          sl<AuthCubit>().setTokens(
            newAccessToken: newAccessToken,
            newRefreshToken: newRefreshToken,
          );
        }

        final newRequest = request.copyWith(
          headers: {
            ...request.headers,
            'Authorization': 'Bearer $newAccessToken',
          },
          extra: {...request.extra, 'isRetry': true},
        );

        final retryResponse = await dio.fetch(newRequest);

        for (final callback in requestQueue) {
          try {
            await callback(newAccessToken);
          } catch (_) {}
        }

        requestQueue.clear();

        return handler.resolve(retryResponse);
      } else {
        requestQueue.clear();
        sl<AuthCubit>().logoutSession();

        return handler.reject(
          UnauthorizedException(err.requestOptions, err.response),
        );
      }
    } catch (e) {
      requestQueue.clear();
      sl<AuthCubit>().logoutSession();

      return handler.reject(
        UnauthorizedException(err.requestOptions, err.response),
      );
    } finally {
      isRefreshing = false;
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // print('ERROR STATUS CODE: ${err.response?.statusCode}');
    // print('ERROR STATUS DATA: ${err.response?.data}');

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
              return _onUnauthorized(err, handler);
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
        case DioExceptionType.badCertificate:
          sl<AuthCubit>().logoutSession();

          return handler.next(err);
        case DioExceptionType.unknown:
          return handler.next(err);
        case DioExceptionType.cancel:
          return handler.next(err);
      }
    }

    return handler.next(err);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // print("--> ${options.method} ${options.uri}");
    // print("Headers: ${options.headers}");
    // print("Body: ${options.data}");
    final accessToken = sl<AuthCubit>().accessToken;

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
