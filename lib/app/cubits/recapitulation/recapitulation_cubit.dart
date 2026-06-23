import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/spm_district_count.dart';
import 'package:panduan/app/models/spm_hp_count.dart';
import 'package:panduan/app/models/spm_subdistrict_count.dart';
import 'package:panduan/app/repositories/recapitulation_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'recapitulation_state.dart';

class RecapitulationCubit extends Cubit<RecapitulationState> {
  RecapitulationCubit(this._repository) : super(const RecapitulationState());

  final RecapitulationRepository _repository;
  final Map<String, CancelToken> _cancelTokens = {};

  Future<void> fetchSpmDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final cancelToken = AppHelpers.createCancelToken(
      _cancelTokens,
      key: 'spmDistrictCount',
    );

    emit(state.copyWith(spmDistrictCountStatus: Status.loading));

    try {
      final spmDistrictCounts = await _repository.fetchSpmDistrictCount(
        startDate: startDate,
        endDate: endDate,
        cancelToken: cancelToken,
      );

      emit(
        state.copyWith(
          spmDistrictCountStatus: Status.success,
          spmDistrictCounts: spmDistrictCounts,
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;

      emit(
        state.copyWith(
          spmDistrictCountStatus: Status.error,
          spmDistrictCountError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchSpmDistrictCount({DateTime? startDate, DateTime? endDate}) async {
    emit(
      state.copyWith(
        spmDistrictCountStatus: Status.initial,
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
    final cancelToken = AppHelpers.createCancelToken(
      _cancelTokens,
      key: 'spmSubDistrictCount',
    );

    emit(state.copyWith(spmSubDistrictCountStatus: Status.loading));

    try {
      final spmSubDistrictCounts = await _repository.fetchSpmSubDistrictCount(
        startDate: startDate,
        endDate: endDate,
        cancelToken: cancelToken,
      );

      emit(
        state.copyWith(
          spmSubDistrictCountStatus: Status.success,
          spmSubDistrictCounts: spmSubDistrictCounts,
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;

      emit(
        state.copyWith(
          spmSubDistrictCountStatus: Status.error,
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
        spmSubDistrictCountStatus: Status.initial,
        spmSubDistrictCounts: const [],
        spmSubDistrictCountError: null,
      ),
    );

    await fetchSpmSubDistrictCount(startDate: startDate, endDate: endDate);
  }

  Future<void> fetchSpmHpCount({DateTime? startDate, DateTime? endDate}) async {
    final cancelToken = AppHelpers.createCancelToken(
      _cancelTokens,
      key: 'spmHpCount',
    );

    emit(state.copyWith(spmHpCountStatus: Status.loading));

    try {
      final spmHpCounts = await _repository.fetchSpmHpCount(
        startDate: startDate,
        endDate: endDate,
        cancelToken: cancelToken,
      );

      emit(
        state.copyWith(
          spmHpCountStatus: Status.success,
          spmHpCounts: spmHpCounts,
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;

      emit(
        state.copyWith(
          spmHpCountStatus: Status.error,
          spmHpCountError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchSpmHpCount({DateTime? startDate, DateTime? endDate}) async {
    emit(
      state.copyWith(
        spmHpCountStatus: Status.initial,
        spmHpCounts: const [],
        spmHpCountError: null,
      ),
    );

    await fetchSpmHpCount(startDate: startDate, endDate: endDate);
  }

  @override
  Future<void> close() {
    AppHelpers.removeAllCancelToken(_cancelTokens);
    return super.close();
  }
}
