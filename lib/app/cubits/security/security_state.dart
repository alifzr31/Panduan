part of 'security_cubit.dart';

enum Status { initial, safe, compromised }

class SecurityState extends Equatable {
  final Status status;
  final String? message;

  const SecurityState({this.status = Status.initial, this.message});

  SecurityState copyWith({Status? status, String? message}) {
    return SecurityState(status: status ?? this.status, message: message);
  }

  @override
  List<Object?> get props => [status, message];
}
