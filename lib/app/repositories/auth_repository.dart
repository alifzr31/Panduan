import 'package:dio/dio.dart';
import 'package:panduan/app/models/profile.dart';
import 'package:panduan/app/services/auth_service.dart';

abstract class AuthRepository {
  Future<Response> login({String? email, String? password});
  Future<Profile?> fetchProfile();
  Future<Response> refreshToken();
  Future<Response> changePassword({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  });
  Future<Response> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  AuthRepositoryImpl(this._service);

  @override
  Future<Response> login({String? email, String? password}) async {
    return await _service.login(email: email, password: password);
  }

  @override
  Future<Profile?> fetchProfile() async {
    return await _service.fetchProfile();
  }

  @override
  Future<Response> refreshToken() async {
    return await _service.refreshToken();
  }

  @override
  Future<Response> changePassword({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    return await _service.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  @override
  Future<Response> logout() async {
    return await _service.logout();
  }
}
