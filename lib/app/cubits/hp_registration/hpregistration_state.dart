part of 'hp_registration_cubit.dart';

enum RegistrationStatus { initial, loading, success, error }

class HpRegistrationState extends Equatable {
  final RegistrationStatus registrationStatus;
  final HpRegistration? hpRegistration;
  final String? registrationError;

  const HpRegistrationState({
    this.registrationStatus = RegistrationStatus.initial,
    this.hpRegistration,
    this.registrationError,
  });

  HpRegistrationState copyWith({
    RegistrationStatus? registrationStatus,
    HpRegistration? hpRegistration,
    String? registrationError,
  }) {
    return HpRegistrationState(
      registrationStatus: registrationStatus ?? this.registrationStatus,
      hpRegistration: hpRegistration,
      registrationError: registrationError,
    );
  }

  @override
  List<Object?> get props => [
    registrationStatus,
    hpRegistration,
    registrationError,
  ];
}
