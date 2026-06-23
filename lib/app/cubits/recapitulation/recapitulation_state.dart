part of 'recapitulation_cubit.dart';

enum Status { initial, loading, success, error }

class RecapitulationState extends Equatable {
  final Status spmDistrictCountStatus;
  final List<SpmDistrictCount> spmDistrictCounts;
  final String? spmDistrictCountError;
  final Status spmSubDistrictCountStatus;
  final List<SpmSubDistrictCount> spmSubDistrictCounts;
  final String? spmSubDistrictCountError;
  final Status spmHpCountStatus;
  final List<SpmHpCount> spmHpCounts;
  final String? spmHpCountError;

  const RecapitulationState({
    this.spmDistrictCountStatus = Status.initial,
    this.spmDistrictCounts = const [],
    this.spmDistrictCountError,
    this.spmSubDistrictCountStatus = Status.initial,
    this.spmSubDistrictCounts = const [],
    this.spmSubDistrictCountError,
    this.spmHpCountStatus = Status.initial,
    this.spmHpCounts = const [],
    this.spmHpCountError,
  });

  RecapitulationState copyWith({
    Status? spmDistrictCountStatus,
    List<SpmDistrictCount>? spmDistrictCounts,
    String? spmDistrictCountError,
    Status? spmSubDistrictCountStatus,
    List<SpmSubDistrictCount>? spmSubDistrictCounts,
    String? spmSubDistrictCountError,
    Status? spmHpCountStatus,
    List<SpmHpCount>? spmHpCounts,
    String? spmHpCountError,
  }) {
    return RecapitulationState(
      spmDistrictCountStatus:
          spmDistrictCountStatus ?? this.spmDistrictCountStatus,
      spmDistrictCounts: spmDistrictCounts ?? this.spmDistrictCounts,
      spmDistrictCountError: spmDistrictCountError,
      spmSubDistrictCountStatus:
          spmSubDistrictCountStatus ?? this.spmSubDistrictCountStatus,
      spmSubDistrictCounts: spmSubDistrictCounts ?? this.spmSubDistrictCounts,
      spmSubDistrictCountError: spmSubDistrictCountError,
      spmHpCountStatus: spmHpCountStatus ?? this.spmHpCountStatus,
      spmHpCounts: spmHpCounts ?? this.spmHpCounts,
      spmHpCountError: spmHpCountError,
    );
  }

  @override
  List<Object?> get props => [
    spmDistrictCountStatus,
    spmDistrictCounts,
    spmDistrictCountError,
    spmSubDistrictCountStatus,
    spmSubDistrictCounts,
    spmSubDistrictCountError,
    spmHpCountStatus,
    spmHpCounts,
    spmHpCountError,
  ];
}
