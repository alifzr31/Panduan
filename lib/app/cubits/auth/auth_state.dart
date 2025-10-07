part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, unauthorized, authorized }

enum LoginStatus { initial, loading, success, error }

enum ProfileStatus { initial, loading, success, error }

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
  final LogoutStatus logoutStatus;
  final Response? logoutResponse;
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
    this.logoutStatus = LogoutStatus.initial,
    this.logoutResponse,
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
    LogoutStatus? logoutStatus,
    Response? logoutResponse,
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
      logoutStatus: logoutStatus ?? this.logoutStatus,
      logoutResponse: loginResponse,
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
    logoutStatus,
    logoutResponse,
    logoutError,
  ];
}
