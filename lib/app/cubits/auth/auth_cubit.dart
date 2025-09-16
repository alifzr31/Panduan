import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/configs/secure_storage/secure_storage.dart';
import 'package:panduan/app/repositories/auth_repository.dart';
import 'package:panduan/app/utils/app_strings.dart';
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
        logoutResponse: null,
        logoutError: null,
      ),
    );
  }

  void login({String? email, String? password}) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    try {
      final response = await _repository.login(
        email: email,
        password: password,
      );

      if (response.data['status']) {
        await Future.wait([
          SecureStorage.writeStorage(
            key: AppStrings.accessToken,
            value: response.data['data']['access_token'],
          ),
          SecureStorage.writeStorage(
            key: AppStrings.refreshToken,
            value: response.data['data']['refresh_token'],
          ),
        ]);

        emit(
          state.copyWith(
            loginStatus: LoginStatus.success,
            loginResponse: response,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loginStatus: LoginStatus.error,
            loginError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.error,
          loginError: e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void logout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    emit(state.copyWith(logoutStatus: LogoutStatus.loading));

    try {
      final response = await _repository.logout();

      if (response.data['status']) {
        await Future.wait([
          SecureStorage.deleteStorage(key: AppStrings.accessToken),
          SecureStorage.deleteStorage(key: AppStrings.refreshToken),
          sharedPreferences.setBool('biometrics_enabled', false),
        ]);
        await sharedPreferences.reload();

        emit(
          state.copyWith(
            logoutStatus: LogoutStatus.success,
            logoutResponse: response,
          ),
        );
      } else {
        emit(
          state.copyWith(
            logoutStatus: LogoutStatus.error,
            logoutError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          logoutStatus: LogoutStatus.error,
          logoutError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }
}
