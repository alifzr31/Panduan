import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/models/spm_field.dart';
import 'package:panduan/app/repositories/spm_repository.dart';
import 'package:panduan/app/utils/app_strings.dart';

part 'spm_state.dart';

class SpmCubit extends Cubit<SpmState> {
  SpmCubit(this._repository) : super(const SpmState());

  final SpmRepository _repository;
  int currentSpmPage = 1;

  Future<void> fetchSpm({
    String? keyword,
    int? month,
    int? year,
    Set<String>? statuses,
  }) async {
    if (currentSpmPage == 1) {
      emit(state.copyWith(spmStatus: SpmStatus.loading));
    }

    try {
      final spm = await _repository.fetchSpm(
        page: currentSpmPage,
        keyword: keyword,
        month: month,
        year: year,
        statuses: statuses,
      );

      if (spm.length < 10) {
        emit(state.copyWith(hasMoreSpm: false));
      }

      emit(
        state.copyWith(
          spmStatus: SpmStatus.success,
          spm: List.of(state.spm)..addAll(spm),
        ),
      );
      currentSpmPage++;
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmStatus: SpmStatus.error,
          spmError: e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchSpm({
    String? keyword,
    int? month,
    int? year,
    Set<String>? statuses,
  }) async {
    currentSpmPage = 1;
    emit(
      state.copyWith(
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
      statuses: statuses,
    );
  }

  Future<void> refreshSpm() async {
    await Future.delayed(const Duration(milliseconds: 2500), () {
      refetchSpm();
    });
  }

  Future<void> fetchSpmFields() async {
    emit(state.copyWith(spmFieldStatus: SpmFieldStatus.loading));

    try {
      final spmFields = await _repository.fetchSpmFields();

      emit(
        state.copyWith(
          spmFieldStatus: SpmFieldStatus.success,
          spmFields: spmFields,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmFieldStatus: SpmFieldStatus.error,
          spmFields: e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void refetchSpmFields() async {
    emit(
      state.copyWith(
        spmFieldStatus: SpmFieldStatus.initial,
        spmFields: const [],
        spmFieldError: null,
      ),
    );

    await fetchSpmFields();
  }

  Future<void> refreshSpmFields() async {
    await Future.delayed(const Duration(milliseconds: 2500), () {
      refetchSpmFields();
    });
  }
}
