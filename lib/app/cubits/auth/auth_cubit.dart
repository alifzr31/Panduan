import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  void resetState() {
    emit(
      state.copyWith(
        loginStatus: LoginStatus.initial,
        loginResponse: null,
        loginError: null,
        logoutStatus: LogoutStatus.initial,
        logoutError: null,
      ),
    );
  }

  void login({String? email, String? password}) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    await Future.delayed(const Duration(milliseconds: 1500), () {
      emit(state.copyWith(loginStatus: LoginStatus.success));
    });
  }

  void logout() async {
    emit(state.copyWith(logoutStatus: LogoutStatus.loading));

    await Future.delayed(const Duration(milliseconds: 1500), () async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setBool('biometrics_enabled', false);
      await sharedPreferences.reload();
      emit(state.copyWith(logoutStatus: LogoutStatus.success));
    });
  }
}
