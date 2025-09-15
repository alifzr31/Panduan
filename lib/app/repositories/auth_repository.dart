import 'package:panduan/app/services/auth_service.dart';

abstract class AuthRepository {}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  AuthRepositoryImpl(this._service);
}
