part of 'landing_page_cubit.dart';

enum Status { initial, loading, success, error }

class LandingPageState extends Equatable {
  final Status status;
  final String? userManualUrl;
  final String? error;

  const LandingPageState({
    this.status = Status.initial,
    this.userManualUrl,
    this.error,
  });

  LandingPageState copyWith({
    Status? status,
    String? userManualUrl,
    String? error,
  }) {
    return LandingPageState(
      status: status ?? this.status,
      userManualUrl: userManualUrl,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, userManualUrl, error];
}
