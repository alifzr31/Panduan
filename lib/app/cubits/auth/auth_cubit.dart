import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/configs/storage/biom_storage/biom_storage.dart';
import 'package:panduan/app/configs/storage/secure_storage/secure_storage.dart';
import 'package:panduan/app/configs/storage/storage_service.dart';
import 'package:panduan/app/models/profile.dart';
import 'package:panduan/app/repositories/auth_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  String? accessToken;
  String? refreshToken;

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

  void setTokens({
    required String newAccessToken,
    required String newRefreshToken,
  }) {
    accessToken = newAccessToken;
    refreshToken = newRefreshToken;
  }

  void clearTokens() {
    accessToken = null;
    refreshToken = null;
  }

  void login({String? email, String? password}) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    try {
      final response = await _repository.login(
        email: email,
        password: password,
      );

      if (response.data['status']) {
        final sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setBool('biometrics_enabled', false);
        sharedPreferences.reload();

        final rawToken = {
          AppStrings.accessToken: response.data['data'][AppStrings.accessToken],
          AppStrings.refreshToken:
              response.data['data'][AppStrings.refreshToken],
        };
        final token = jsonEncode(rawToken);
        await StorageService.writeAppToken(newAppToken: token);
        setTokens(
          newAccessToken: response.data['data'][AppStrings.accessToken],
          newRefreshToken: response.data['data'][AppStrings.refreshToken],
        );

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

    clearTokens();
    await Future.wait([
      SecureStorage.deleteStorage(key: AppStrings.appToken),
      BiomStorage().delete(),
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
        clearTokens();
        await Future.wait([
          SecureStorage.deleteStorage(key: AppStrings.appToken),
          BiomStorage().delete(),
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
