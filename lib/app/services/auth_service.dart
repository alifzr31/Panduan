import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/configs/firebase/firebase_notif.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/models/profile.dart';
import 'package:panduan/app/utils/app_env.dart';

class AuthService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<Response> login({String? email, String? password}) async {
    try {
      final response = await post(
        '/login',
        data: {
          'email': email,
          'password': password,
          'fcm_token_mobile': await FirebaseNotif().getDeviceToken(),
        },
      );

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Profile?> fetchProfile() async {
    try {
      final response = await get('/me');

      return await compute(
        (message) => profileFromJson(message),
        response.data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Future<Response> refreshToken() async {
  //   String? accessToken = sl<AuthCubit>().accessToken;
  //   String? refreshToken = await SecureStorage.readStorage(
  //     key: AppStrings.refreshToken,
  //   );

  //   try {
  //     final response = await post(
  //       '/refresh-token',
  //       headers: {'Authorization': 'Bearer $accessToken'},
  //       data: {'refresh_token': 'Bearer $refreshToken'},
  //     );

  //     return await compute((message) => message, response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<Response> changePassword({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    try {
      final response = await patch(
        '/update-password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
      );

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logout() async {
    final refreshToken = sl<AuthCubit>().refreshToken;

    try {
      final response = await post(
        '/logout',
        headers: {'Authorization-Refresh': refreshToken},
      );

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }
}
