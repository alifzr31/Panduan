part of 'auth_cubit.dart';

enum LoginStatus { initial, loading, success, error }

enum LogoutStatus { initial, loading, success, error }

class AuthState extends Equatable {
  final LoginStatus loginStatus;
  final Response? loginResponse;
  final String? loginError;
  final LogoutStatus logoutStatus;
  final String? logoutError;

  const AuthState({
    this.loginStatus = LoginStatus.initial,
    this.loginResponse,
    this.loginError,
    this.logoutStatus = LogoutStatus.initial,
    this.logoutError,
  });

  AuthState copyWith({
    LoginStatus? loginStatus,
    Response? loginResponse,
    String? loginError,
    LogoutStatus? logoutStatus,
    String? logoutError,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      loginResponse: loginResponse,
      loginError: loginError,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      logoutError: logoutError,
    );
  }

  @override
  List<Object?> get props => [
    loginStatus,
    loginResponse,
    loginError,
    logoutStatus,
    logoutError,
  ];
}
