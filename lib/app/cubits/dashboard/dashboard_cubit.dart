import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/health_post.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/models/spm_count.dart';
import 'package:panduan/app/models/spm_district_count.dart';
import 'package:panduan/app/models/spm_field_count.dart';
import 'package:panduan/app/models/spm_hp_count.dart';
import 'package:panduan/app/models/spm_subdistrict_count.dart';
import 'package:panduan/app/repositories/dashboard_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());

  final DashboardRepository _repository;

  int _currentSpmPage = 1;
  int _currentHealthPostPage = 1;

  void initHomeDataByLevel({
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
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-opd',
    )) {
      await fetchSpmCount(startDate: startDate, endDate: endDate);
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-kecamatan',
    )) {
      await fetchSpmCount(startDate: startDate, endDate: endDate);
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
      await fetchSpmSubDistrictCount(startDate: startDate, endDate: endDate);
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-kelurahan',
    )) {
      await fetchSpmCount(startDate: startDate, endDate: endDate);
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
      await fetchSpmHpCount(startDate: startDate, endDate: endDate);
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-posyandu',
    )) {
      await fetchSpmFieldCount(startDate: startDate, endDate: endDate);
    }
  }

  void refetchHomeDataByLevel({
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
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-opd',
    )) {
      refetchSpmCount(startDate: startDate, endDate: endDate);
      refetchSpmFieldCount(startDate: startDate, endDate: endDate);
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-kecamatan',
    )) {
      refetchSpmCount(startDate: startDate, endDate: endDate);
      refetchSpmFieldCount(startDate: startDate, endDate: endDate);
      refetchSpmSubDistrictCount(startDate: startDate, endDate: endDate);
    } else if (AppHelpers.hasPermission(
      userPermissions ?? const [],
      permissionName: 'level-kelurahan',
    )) {
      refetchSpmCount(startDate: startDate, endDate: endDate);
      refetchSpmFieldCount(startDate: startDate, endDate: endDate);
      refetchSpmHpCount(startDate: startDate, endDate: endDate);
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
          unreadNotificationError: AppHelpers.errorHandlingApiMessage(e),
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
          spmCountError: AppHelpers.errorHandlingApiMessage(e),
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
          spmFieldCountError: AppHelpers.errorHandlingApiMessage(e),
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
          spmDistrictCountError: AppHelpers.errorHandlingApiMessage(e),
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
          spmSubDistrictCountError: AppHelpers.errorHandlingApiMessage(e),
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
          spmHpCountError: AppHelpers.errorHandlingApiMessage(e),
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

  Future<void> fetchSpm({
    String? keyword,
    int? month,
    int? year,
    String? districtCode,
    String? subDistrictCode,
    String? healthPostUuid,
    String? spmFieldName,
    Set<String>? statuses,
  }) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmStatus: _currentSpmPage == 1 ? SpmStatus.loading : null,
      ),
    );

    try {
      final spm = await _repository.fetchSpm(
        page: _currentSpmPage,
        keyword: keyword,
        month: month,
        year: year,
        districtCode: districtCode,
        subDistrictCode: subDistrictCode,
        healthPostUuid: healthPostUuid,
        spmFieldName: spmFieldName,
        statuses: statuses,
      );

      if (spm.length < 10) {
        emit(
          state.copyWith(
            spmCount: state.spmCount,
            spmFieldCount: state.spmFieldCount,
            hasMoreSpm: false,
          ),
        );
      }

      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmStatus: SpmStatus.success,
          spm: List.of(state.spm)..addAll(spm),
        ),
      );
      _currentSpmPage++;
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          spmStatus: SpmStatus.error,
          spmError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchSpm({
    String? keyword,
    int? month,
    int? year,
    String? districtCode,
    String? subDistrictCode,
    String? healthPostUuid,
    String? spmFieldName,
    Set<String>? statuses,
  }) async {
    _currentSpmPage = 1;
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        spmStatus: SpmStatus.initial,
        hasMoreSpm: true,
        spm: const [],
        spmError: null,
      ),
    );

    await fetchSpm(
      keyword: keyword,
      month: month,
      year: year,
      districtCode: districtCode,
      subDistrictCode: subDistrictCode,
      healthPostUuid: healthPostUuid,
      spmFieldName: spmFieldName,
      statuses: statuses,
    );
  }

  void onSelectedSpmStatus(String? spmStatus) {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        selectedSpmStatus: spmStatus,
      ),
    );
  }

  void clearSelectedSpmStatus() {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        selectedSpmStatus: null,
      ),
    );
  }

  void onSelectedSpmField(String? spmFieldName) {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        selectedSpmField: spmFieldName,
      ),
    );
  }

  void clearSelectedSpmField() {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        selectedSpmField: null,
      ),
    );
  }

  Future<void> fetchHealthPosts({
    String? keyword,
    String? districtCode,
    String? subDistrictCode,
  }) async {
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        selectedSpmField: state.selectedSpmField,
        selectedSpmStatus: state.selectedSpmStatus,
        healthPostStatus: _currentHealthPostPage == 1
            ? HealthPostStatus.loading
            : null,
      ),
    );

    try {
      final healthPosts = await _repository.fetchHealthPosts(
        page: _currentHealthPostPage,
        keyword: keyword,
        districtCode: districtCode,
        subDistrictCode: subDistrictCode,
      );

      if (healthPosts.length < 10) {
        emit(
          state.copyWith(
            spmCount: state.spmCount,
            spmFieldCount: state.spmFieldCount,
            selectedSpmField: state.selectedSpmField,
            selectedSpmStatus: state.selectedSpmStatus,
            hasMoreHealthPost: false,
          ),
        );
      }

      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          selectedSpmField: state.selectedSpmField,
          selectedSpmStatus: state.selectedSpmStatus,
          healthPostStatus: HealthPostStatus.success,
          healthPosts: List.of(state.healthPosts)..addAll(healthPosts),
        ),
      );
      _currentHealthPostPage++;
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmCount: state.spmCount,
          spmFieldCount: state.spmFieldCount,
          selectedSpmField: state.selectedSpmField,
          selectedSpmStatus: state.selectedSpmStatus,
          healthPostStatus: HealthPostStatus.error,
          healthPostError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchHealthPosts({
    String? keyword,
    String? districtCode,
    String? subDistrictCode,
  }) async {
    _currentHealthPostPage = 1;
    emit(
      state.copyWith(
        spmCount: state.spmCount,
        spmFieldCount: state.spmFieldCount,
        selectedSpmField: state.selectedSpmField,
        selectedSpmStatus: state.selectedSpmStatus,
        healthPostStatus: HealthPostStatus.initial,
        hasMoreHealthPost: true,
        healthPosts: const [],
        healthPostError: null,
      ),
    );

    await fetchHealthPosts(
      keyword: keyword,
      districtCode: districtCode,
      subDistrictCode: subDistrictCode,
    );
  }
}
