import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/interceptors.dart';
import 'package:panduan/app/configs/firebase/remoteconfig_service.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class DioClient {
  late Dio dio;
  String get baseUrl;

  DioClient() {
    dio = Dio();
    configureDio();
  }

  void configureDio() {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(minutes: 5);
    dio.options.receiveTimeout = const Duration(minutes: 5);
    dio.options.headers.addAll(AppHelpers.addOnHeaders());
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();

        // if (kDebugMode) {
        //   client.findProxy = (uri) => "PROXY 192.168.1.X:8888";
        //   client.badCertificateCallback = (cert, host, port) => true;
        // }

        return client;
      },
      validateCertificate: (X509Certificate? cert, String host, int port) {
        final pinnedFingerprints = [AppEnv.panduanSignature];
        final sslPinningActived =
            RemoteConfigService.instance.sslPinningActived;

        if (!sslPinningActived) {
          debugPrint("⚠️ SSL Pinning Bypass: Dimatikan via Remote Config");

          return true;
        }

        if (cert == null) return false;

        final certBytes = cert.der;
        final digest = sha256.convert(certBytes);
        final serverFingerprint = digest.bytes
            .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
            .join(':');

        return pinnedFingerprints.contains(serverFingerprint);
      },
    );
    dio.interceptors.addAll([
      DioInterceptors(dio),
      if (kDebugMode) ...{
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      },
    ]);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers),
        cancelToken: cancelToken,
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

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.patch(
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

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.delete(
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

  Future<Response> download(
    String urlPath,
    String savedPath, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    void Function(int count, int total)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.download(
        urlPath,
        savedPath,
        queryParameters: queryParams,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (_) {
      rethrow;
    }
  }
}
