import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/repositories/detailspm_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'detailspm_state.dart';

class DetailSpmCubit extends Cubit<DetailSpmState> {
  DetailSpmCubit(this._repository) : super(const DetailSpmState());

  final DetailSpmRepository _repository;

  Future<void> fetchDetailSpm({String? uuid, bool? isEdit}) async {
    emit(state.copyWith(detailStatus: DetailStatus.loading));

    try {
      final detailSpm = await _repository.fetchDetailSpm(
        uuid: uuid,
        isEdit: isEdit,
      );

      emit(
        state.copyWith(
          detailStatus: DetailStatus.success,
          detailSpm: detailSpm,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          detailStatus: DetailStatus.error,
          detailError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchDetailSpm({String? uuid}) async {
    emit(
      state.copyWith(
        detailStatus: DetailStatus.initial,
        detailSpm: null,
        detailError: null,
      ),
    );

    await fetchDetailSpm(uuid: uuid);
  }

  void deleteSpm({String? uuid}) async {
    emit(
      state.copyWith(
        detailSpm: state.detailSpm,
        deleteStatus: DeleteStatus.loading,
      ),
    );

    try {
      final response = await _repository.deleteSpm(uuid: uuid);

      if (response.data['status']) {
        emit(
          state.copyWith(
            detailSpm: state.detailSpm,
            deleteStatus: DeleteStatus.success,
            deleteResponse: response,
          ),
        );
      } else {
        emit(
          state.copyWith(
            detailSpm: state.detailSpm,
            deleteStatus: DeleteStatus.error,
            deleteError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          detailSpm: state.detailSpm,
          deleteStatus: DeleteStatus.error,
          deleteError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }
}
