part of 'spm_cubit.dart';

enum SpmFieldStatus { initial, loading, success, error }

class SpmState extends Equatable {
  final SpmFieldStatus spmFieldStatus;
  final List<SpmField> spmFields;
  final String? spmFieldError;

  const SpmState({
    this.spmFieldStatus = SpmFieldStatus.initial,
    this.spmFields = const [],
    this.spmFieldError,
  });

  SpmState copyWith({
    SpmFieldStatus? spmFieldStatus,
    List<SpmField>? spmFields,
    String? spmFieldError,
  }) {
    return SpmState(
      spmFieldStatus: spmFieldStatus ?? this.spmFieldStatus,
      spmFields: spmFields ?? this.spmFields,
      spmFieldError: spmFieldError,
    );
  }

  @override
  List<Object?> get props => [spmFieldStatus, spmFields, spmFieldError];
}
