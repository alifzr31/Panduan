import 'package:dio/dio.dart';
import 'package:panduan/app/services/auth_service.dart';

abstract class AuthRepository {
  Future<Response> login({String? email, String? password});
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
  Future<Response> logout() async {
    return await _service.logout();
  }
}
