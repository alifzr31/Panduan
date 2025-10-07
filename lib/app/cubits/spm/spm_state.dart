part of 'spm_cubit.dart';

enum SpmStatus { initial, loading, success, error }

enum SpmFieldStatus { initial, loading, success, error }

class SpmState extends Equatable {
  final SpmStatus spmStatus;
  final bool hasMoreSpm;
  final List<Spm> spm;
  final String? spmError;
  final SpmFieldStatus spmFieldStatus;
  final List<SpmField> spmFields;
  final String? spmFieldError;

  const SpmState({
    this.spmStatus = SpmStatus.initial,
    this.hasMoreSpm = true,
    this.spm = const [],
    this.spmError,
    this.spmFieldStatus = SpmFieldStatus.initial,
    this.spmFields = const [],
    this.spmFieldError,
  });

  SpmState copyWith({
    SpmStatus? spmStatus,
    bool? hasMoreSpm,
    List<Spm>? spm,
    String? spmError,
    SpmFieldStatus? spmFieldStatus,
    List<SpmField>? spmFields,
    String? spmFieldError,
  }) {
    return SpmState(
      spmStatus: spmStatus ?? this.spmStatus,
      hasMoreSpm: hasMoreSpm ?? this.hasMoreSpm,
      spm: spm ?? this.spm,
      spmError: spmError,
      spmFieldStatus: spmFieldStatus ?? this.spmFieldStatus,
      spmFields: spmFields ?? this.spmFields,
      spmFieldError: spmFieldError,
    );
  }

  @override
  List<Object?> get props => [
    spmStatus,
    hasMoreSpm,
    spm,
    spmError,
    spmFieldStatus,
    spmFields,
    spmFieldError,
  ];
}
