part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, unauthorized, authorized }

enum LoginStatus { initial, loading, success, error }

enum ProfileStatus { initial, loading, success, error }

enum ChangePasswordStatus { initial, loading, success, error }

enum LogoutStatus { initial, loading, success, error }

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final LoginStatus loginStatus;
  final Response? loginResponse;
  final String? loginError;
  final ProfileStatus profileStatus;
  final Profile? profile;
  final List<String> userPermissions;
  final String? profileError;
  final ChangePasswordStatus changePasswordStatus;
  final Response? changePasswordResponse;
  final String? changePasswordError;
  final LogoutStatus logoutStatus;
  final Response? logoutResponse;
  final String? logoutReason;
  final String? logoutError;

  const AuthState({
    this.authStatus = AuthStatus.initial,
    this.loginStatus = LoginStatus.initial,
    this.loginResponse,
    this.loginError,
    this.profileStatus = ProfileStatus.initial,
    this.profile,
    this.userPermissions = const [],
    this.profileError,
    this.changePasswordStatus = ChangePasswordStatus.initial,
    this.changePasswordResponse,
    this.changePasswordError,
    this.logoutStatus = LogoutStatus.initial,
    this.logoutResponse,
    this.logoutReason,
    this.logoutError,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    LoginStatus? loginStatus,
    Response? loginResponse,
    String? loginError,
    ProfileStatus? profileStatus,
    Profile? profile,
    List<String>? userPermissions,
    String? profileError,
    ChangePasswordStatus? changePasswordStatus,
    Response? changePasswordResponse,
    String? changePasswordError,
    LogoutStatus? logoutStatus,
    Response? logoutResponse,
    String? logoutReason,
    String? logoutError,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      loginResponse: loginResponse,
      loginError: loginError,
      profileStatus: profileStatus ?? this.profileStatus,
      profile: profile,
      userPermissions: userPermissions ?? this.userPermissions,
      profileError: loginError,
      changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
      changePasswordResponse: changePasswordResponse,
      changePasswordError: changePasswordError,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      logoutResponse: logoutResponse,
      logoutReason: logoutReason,
      logoutError: logoutError,
    );
  }

  @override
  List<Object?> get props => [
    authStatus,
    loginStatus,
    loginResponse,
    loginError,
    profileStatus,
    profile,
    userPermissions,
    profileError,
    changePasswordStatus,
    changePasswordResponse,
    changePasswordError,
    logoutStatus,
    logoutResponse,
    logoutReason,
    logoutError,
  ];
}
