import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/configs/secure_storage/secure_storage.dart';
import 'package:panduan/app/utils/app_strings.dart';

class AuthService extends DioClient {
  Future<Response> login({String? email, String? password}) async {
    try {
      final response = await post(
        '/login',
        data: {'email': email, 'password': password},
      );

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logout() async {
    try {
      final response = await post(
        '/logout',
        headers: {
          'authorization-refresh': await SecureStorage.readStorage(
            key: AppStrings.refreshToken,
          ),
        },
      );

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }
}
