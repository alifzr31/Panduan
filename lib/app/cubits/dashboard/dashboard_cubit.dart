import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/models/spm_count.dart';
import 'package:panduan/app/models/spm_district_count.dart';
import 'package:panduan/app/models/spm_field_count.dart';
import 'package:panduan/app/models/spm_hp_count.dart';
import 'package:panduan/app/models/spm_subdistrict_count.dart';
import 'package:panduan/app/repositories/dashboard_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/app_strings.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());

  final DashboardRepository _repository;

  void initDataByLevel({
    List<String>? userPermissions,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await fetchUnreadNotificationCount();

    if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-walikota',
    )) {
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
      await fetchSpmDistrictCount(startDate: startDate, endDate: endDate);
      await fetchSpmSubDistrictCount(startDate: startDate, endDate: endDate);
      await fetchSpm();
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-opd',
    )) {
      await fetchSpmCount(startDate: startDate, endDate: endDate);
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
      await fetchSpm();
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-kecamatan',
    )) {
      await fetchSpmCount(startDate: startDate, endDate: endDate);
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
      await fetchSpmSubDistrictCount(startDate: startDate, endDate: endDate);
      await fetchSpm();
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-kelurahan',
    )) {
      await fetchSpmCount(startDate: startDate, endDate: endDate);
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
      await fetchSpmHpCount(startDate: startDate, endDate: endDate);
      await fetchSpm();
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-posyandu',
    )) {
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
    }
  }

  void refetchDataByLevel({
    List<String>? userPermissions,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    refetchUnreadNotificationCount();

    if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-walikota',
    )) {
      refetchSpmFieldCount(startDate: startDate, endDate: endDate);
      refetchSpmDistrictCount(startDate: startDate, endDate: endDate);
      refetchSpmSubDistrictCount(startDate: startDate, endDate: endDate);
      refetchSpm();
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-opd',
    )) {
      refetchSpmCount(startDate: startDate, endDate: endDate);
      refetchSpmFieldCount(startDate: startDate, endDate: endDate);
      refetchSpm();
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-kecamatan',
    )) {
      refetchSpmCount(startDate: startDate, endDate: endDate);
      refetchSpmFieldCount(startDate: startDate, endDate: endDate);
      refetchSpmSubDistrictCount(startDate: startDate, endDate: endDate);
      refetchSpm();
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-kelurahan',
    )) {
      refetchSpmCount(startDate: startDate, endDate: endDate);
      refetchSpmFieldCount(startDate: startDate, endDate: endDate);
      refetchSpmHpCount(startDate: startDate, endDate: endDate);
      refetchSpm();
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-posyandu',
    )) {
      refetchSpmFieldCount(startDate: startDate, endDate: endDate);
    }
  }

  Future<void> fetchUnreadNotificationCount() async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        unreadNotificationStatus: UnreadNotificationStatus.loading,
      ),
    );

    try {
      final unreadNotificationCount = await _repository
          .fetchUnreadNotificationCount();

      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          unreadNotificationStatus: UnreadNotificationStatus.success,
          unreadNotificationCount: unreadNotificationCount,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          unreadNotificationStatus: UnreadNotificationStatus.error,
          unreadNotificationError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchUnreadNotificationCount() async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        unreadNotificationStatus: UnreadNotificationStatus.initial,
        unreadNotificationCount: 0,
        unreadNotificationError: null,
      ),
    );

    await fetchUnreadNotificationCount();
  }

  Future<void> fetchSpmCount({DateTime? startDate, DateTime? endDate}) async {
    emit(state.copyWith(spmCountStatus: SpmCountStatus.loading));

    try {
      final spmCount = await _repository.fetchSpmCount(
        startDate: startDate,
        endDate: endDate,
      );

      emit(
        state.copyWith(
          spmCountStatus: SpmCountStatus.success,
          spmCount: spmCount,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCountStatus: SpmCountStatus.error,
          spmCountError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchSpmCount({DateTime? startDate, DateTime? endDate}) async {
    emit(
      state.copyWith(
        spmCountStatus: SpmCountStatus.initial,
        spmCount: null,
        spmCountError: null,
        spmFieldCount: state.spmFieldCount,
      ),
    );

    await fetchSpmCount(startDate: startDate, endDate: endDate);
  }

  Future<void> fetchSpmFieldCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCountStatus: SpmFieldCountStatus.loading,
      ),
    );

    try {
      final spmFieldCount = await _repository.fetchSpmFieldCount(
        startDate: startDate,
        endDate: endDate,
      );

      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCountStatus: SpmFieldCountStatus.success,
          spmFieldCount: spmFieldCount,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCountStatus: SpmFieldCountStatus.error,
          spmFieldCountError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchSpmFieldCount({DateTime? startDate, DateTime? endDate}) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCountStatus: SpmFieldCountStatus.initial,
        spmFieldCount: null,
        spmFieldCountError: null,
      ),
    );

    await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
  }

  Future<void> fetchSpmDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmDistrictCountStatus: SpmDistrictCountStatus.loading,
      ),
    );

    try {
      final spmDistrictCounts = await _repository.fetchSpmDistrictCount(
        startDate: startDate,
        endDate: endDate,
      );

      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmDistrictCountStatus: SpmDistrictCountStatus.success,
          spmDistrictCounts: spmDistrictCounts,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmDistrictCountStatus: SpmDistrictCountStatus.error,
          spmDistrictCountError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchSpmDistrictCount({DateTime? startDate, DateTime? endDate}) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmDistrictCountStatus: SpmDistrictCountStatus.initial,
        spmDistrictCounts: const [],
        spmDistrictCountError: null,
      ),
    );

    await fetchSpmDistrictCount(startDate: startDate, endDate: endDate);
  }

  Future<void> fetchSpmSubDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmSubDistrictCountStatus: SpmSubDistrictCountStatus.loading,
      ),
    );

    try {
      final spmSubDistrictCounts = await _repository.fetchSpmSubDistrictCount(
        startDate: startDate,
        endDate: endDate,
      );

      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmSubDistrictCountStatus: SpmSubDistrictCountStatus.success,
          spmSubDistrictCounts: spmSubDistrictCounts,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmSubDistrictCountStatus: SpmSubDistrictCountStatus.error,
          spmSubDistrictCountError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchSpmSubDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmSubDistrictCountStatus: SpmSubDistrictCountStatus.initial,
        spmSubDistrictCounts: const [],
        spmSubDistrictCountError: null,
      ),
    );

    await fetchSpmSubDistrictCount(startDate: startDate, endDate: endDate);
  }

  Future<void> fetchSpmHpCount({DateTime? startDate, DateTime? endDate}) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmHpCountStatus: SpmHpCountStatus.loading,
      ),
    );

    try {
      final spmHpCounts = await _repository.fetchSpmHpCount(
        startDate: startDate,
        endDate: endDate,
      );

      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmHpCountStatus: SpmHpCountStatus.success,
          spmHpCounts: spmHpCounts,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmHpCountStatus: SpmHpCountStatus.error,
          spmHpCountError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchSpmHpCount({DateTime? startDate, DateTime? endDate}) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmHpCountStatus: SpmHpCountStatus.initial,
        spmHpCounts: const [],
        spmHpCountError: null,
      ),
    );

    await fetchSpmHpCount(startDate: startDate, endDate: endDate);
  }

  Future<void> fetchSpm() async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmStatus: SpmStatus.loading,
      ),
    );

    try {
      final spm = await _repository.fetchSpm();

      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmStatus: SpmStatus.success,
          spm: spm,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmStatus: SpmStatus.error,
          spmError: e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchSpm() async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmStatus: SpmStatus.initial,
        spm: const [],
        spmError: null,
      ),
    );

    await fetchSpm();
  }
}
