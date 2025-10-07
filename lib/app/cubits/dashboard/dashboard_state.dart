part of 'dashboard_cubit.dart';

enum UnreadNotificationStatus { initial, loading, success, error }

enum SpmCountStatus { initial, loading, success, error }

enum SpmFieldCountStatus { initial, loading, success, error }

enum SpmDistrictCountStatus { initial, loading, success, error }

enum SpmSubDistrictCountStatus { initial, loading, success, error }

enum SpmHpCountStatus { initial, loading, success, error }

enum SpmStatus { initial, loading, success, error }

class DashboardState extends Equatable {
  final UnreadNotificationStatus unreadNotificationStatus;
  final int unreadNotificationCount;
  final String? unreadNotificationError;
  final SpmCountStatus spmCountStatus;
  final SpmCount? spmCount;
  final String? spmCountError;
  final SpmFieldCountStatus spmFieldCountStatus;
  final SpmFieldCount? spmFieldCount;
  final String? spmFieldCountError;
  final SpmDistrictCountStatus spmDistrictCountStatus;
  final List<SpmDistrictCount> spmDistrictCounts;
  final String? spmDistrictCountError;
  final SpmSubDistrictCountStatus spmSubDistrictCountStatus;
  final List<SpmSubDistrictCount> spmSubDistrictCounts;
  final String? spmSubDistrictCountError;
  final SpmHpCountStatus spmHpCountStatus;
  final List<SpmHpCount> spmHpCounts;
  final String? spmHpCountError;
  final SpmStatus spmStatus;
  final List<Spm> spm;
  final String? spmError;

  const DashboardState({
    this.unreadNotificationStatus = UnreadNotificationStatus.initial,
    this.unreadNotificationCount = 0,
    this.unreadNotificationError,
    this.spmCountStatus = SpmCountStatus.initial,
    this.spmCount,
    this.spmCountError,
    this.spmFieldCountStatus = SpmFieldCountStatus.initial,
    this.spmFieldCount,
    this.spmFieldCountError,
    this.spmDistrictCountStatus = SpmDistrictCountStatus.initial,
    this.spmDistrictCounts = const [],
    this.spmDistrictCountError,
    this.spmSubDistrictCountStatus = SpmSubDistrictCountStatus.initial,
    this.spmSubDistrictCounts = const [],
    this.spmSubDistrictCountError,
    this.spmHpCountStatus = SpmHpCountStatus.initial,
    this.spmHpCounts = const [],
    this.spmHpCountError,
    this.spmStatus = SpmStatus.initial,
    this.spm = const [],
    this.spmError,
  });

  DashboardState copyWith({
    UnreadNotificationStatus? unreadNotificationStatus,
    int? unreadNotificationCount,
    String? unreadNotificationError,
    SpmCountStatus? spmCountStatus,
    SpmCount? spmCount,
    String? spmCountError,
    SpmFieldCountStatus? spmFieldCountStatus,
    SpmFieldCount? spmFieldCount,
    String? spmFieldCountError,
    SpmDistrictCountStatus? spmDistrictCountStatus,
    List<SpmDistrictCount>? spmDistrictCounts,
    String? spmDistrictCountError,
    SpmSubDistrictCountStatus? spmSubDistrictCountStatus,
    List<SpmSubDistrictCount>? spmSubDistrictCounts,
    String? spmSubDistrictCountError,
    SpmHpCountStatus? spmHpCountStatus,
    List<SpmHpCount>? spmHpCounts,
    String? spmHpCountError,
    SpmStatus? spmStatus,
    List<Spm>? spm,
    String? spmError,
  }) {
    return DashboardState(
      unreadNotificationStatus:
          unreadNotificationStatus ?? this.unreadNotificationStatus,
      unreadNotificationCount:
          unreadNotificationCount ?? this.unreadNotificationCount,
      unreadNotificationError: unreadNotificationError,
      spmCountStatus: spmCountStatus ?? this.spmCountStatus,
      spmCount: spmCount,
      spmCountError: spmCountError,
      spmFieldCountStatus: spmFieldCountStatus ?? this.spmFieldCountStatus,
      spmFieldCount: spmFieldCount,
      spmFieldCountError: spmFieldCountError,
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
      spmStatus: spmStatus ?? this.spmStatus,
      spm: spm ?? this.spm,
      spmError: spmError,
    );
  }

  @override
  List<Object?> get props => [
    unreadNotificationStatus,
    unreadNotificationCount,
    unreadNotificationError,
    spmCountStatus,
    spmCount,
    spmCountError,
    spmFieldCountStatus,
    spmFieldCount,
    spmFieldCountError,
    spmDistrictCountStatus,
    spmDistrictCounts,
    spmDistrictCountError,
    spmSubDistrictCountStatus,
    spmSubDistrictCounts,
    spmSubDistrictCountError,
    spmHpCountStatus,
    spmHpCounts,
    spmHpCountError,
    spmStatus,
    spm,
    spmError,
  ];
}
