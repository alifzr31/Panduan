import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:panduan/app/configs/dio/interceptors.dart';

abstract class DioClient {
  late Dio dio;

  DioClient() {
    dio = Dio();
    configureDio();
  }

  void configureDio() async {
    dio.options.baseUrl = AppStrings.baseUrl;
    dio.options.headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    dio.options.connectTimeout = const Duration(minutes: 5);
    dio.options.receiveTimeout = const Duration(minutes: 5);
    dio.interceptors.add(DioInterceptors());
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      return response;
    } catch (_) {
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      return response;
    } catch (_) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      return response;
    } catch (_) {
      rethrow;
    }
  }

  Future<Response> downloadFile(
    String urlPath,
    String savedPath, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Function? progressCallback,
  }) async {
    try {
      final response = await dio.download(
        urlPath,
        savedPath,
        queryParameters: queryParams,
        options: Options(headers: headers),
        onReceiveProgress: (count, total) {
          progressCallback!(count, total);
        },
      );

      return response;
    } catch (_) {
      rethrow;
    }
  }
}
