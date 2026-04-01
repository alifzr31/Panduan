import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/secure_storage/secure_storage.dart';
import 'package:panduan/app/models/profile.dart';
import 'package:panduan/app/repositories/auth_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  void resetState() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      emit(
        state.copyWith(
          authStatus: AuthStatus.initial,
          loginStatus: LoginStatus.initial,
          loginResponse: null,
          loginError: null,
          profileStatus: ProfileStatus.initial,
          profile: null,
          profileError: null,
          changePasswordStatus: ChangePasswordStatus.initial,
          changePasswordResponse: null,
          changePasswordError: null,
          logoutStatus: LogoutStatus.initial,
          logoutResponse: null,
          logoutReason: null,
          logoutError: null,
        ),
      );
    });
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
          loginError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  Future<void> fetchProfile() async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));

    try {
      final profile = await _repository.fetchProfile();

      emit(
        state.copyWith(
          authStatus: AuthStatus.authorized,
          profileStatus: ProfileStatus.success,
          profile: profile,
          userPermissions: profile?.permissions?.map((e) {
            return e.name ?? '';
          }).toList(),
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.error,
          profileError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchProfile() async {
    emit(
      state.copyWith(
        profileStatus: ProfileStatus.initial,
        profile: null,
        userPermissions: const [],
        profileError: null,
      ),
    );

    await fetchProfile();
  }

  void refreshToken() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    try {
      final response = await _repository.refreshToken();

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

        // refetchProfile();
      }
    } on DioException catch (e) {
      if (kDebugMode) print(e.response?.data);
    }
  }

  void changePassword({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    emit(
      state.copyWith(
        profile: state.profile,
        userPermissions: state.userPermissions,
        changePasswordStatus: ChangePasswordStatus.loading,
      ),
    );

    try {
      final response = await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (response.data['status']) {
        emit(
          state.copyWith(
            profile: state.profile,
            userPermissions: state.userPermissions,
            changePasswordStatus: ChangePasswordStatus.success,
            changePasswordResponse: response,
          ),
        );
      } else {
        emit(
          state.copyWith(
            profile: state.profile,
            userPermissions: state.userPermissions,
            changePasswordStatus: ChangePasswordStatus.error,
            changePasswordError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          profile: state.profile,
          userPermissions: state.userPermissions,
          changePasswordStatus: ChangePasswordStatus.error,
          changePasswordError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void logoutSession() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await Future.wait([
      SecureStorage.deleteStorage(key: AppStrings.accessToken),
      SecureStorage.deleteStorage(key: AppStrings.refreshToken),
      sharedPreferences.setBool('biometrics_enabled', false),
    ]);
    await sharedPreferences.reload();

    emit(state.copyWith(authStatus: AuthStatus.unauthorized));
  }

  void logout({String? logoutReason}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    emit(
      state.copyWith(
        profile: state.profile,
        userPermissions: state.userPermissions,
        logoutStatus: LogoutStatus.loading,
      ),
    );

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
            profile: state.profile,
            userPermissions: state.userPermissions,
            logoutStatus: LogoutStatus.success,
            logoutResponse: response,
            logoutReason: logoutReason,
          ),
        );
      } else {
        emit(
          state.copyWith(
            profile: state.profile,
            userPermissions: state.userPermissions,
            logoutStatus: LogoutStatus.error,
            logoutError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          profile: state.profile,
          userPermissions: state.userPermissions,
          logoutStatus: LogoutStatus.error,
          logoutError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }
}
