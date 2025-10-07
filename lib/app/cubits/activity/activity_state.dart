part of 'activity_cubit.dart';

enum FormStatus { initial, loading, success, error }

enum OpdStatus { initial, loading, success, error }

class ActivityState extends Equatable {
  final FormStatus formStatus;
  final Response? formResponse;
  final String? formError;
  final OpdStatus opdStatus;
  final List<Opd> opd;
  final String? opdError;

  const ActivityState({
    this.formStatus = FormStatus.initial,
    this.formResponse,
    this.formError,
    this.opdStatus = OpdStatus.initial,
    this.opd = const [],
    this.opdError,
  });

  ActivityState copyWith({
    FormStatus? formStatus,
    Response? formResponse,
    String? formError,
    OpdStatus? opdStatus,
    List<Opd>? opd,
    String? opdError,
  }) {
    return ActivityState(
      formStatus: formStatus ?? this.formStatus,
      formResponse: formResponse,
      formError: formError,
      opdStatus: opdStatus ?? this.opdStatus,
      opd: opd ?? this.opd,
      opdError: opdError,
    );
  }

  @override
  List<Object?> get props => [
    formStatus,
    formResponse,
    formError,
    opdStatus,
    opd,
    opdError,
  ];
}
