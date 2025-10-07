import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/opd.dart';
import 'package:panduan/app/repositories/activity_repository.dart';
import 'package:panduan/app/utils/app_strings.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit(this._repository) : super(const ActivityState());

  final ActivityRepository _repository;

  void createActivity({
    String? spmUuid,
    String? status,
    String? description,
    String? opdUuid,
    double? latitude,
    double? longitude,
    List<String>? attachmentKeys,
    List<String>? attachmentPaths,
  }) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    try {
      final response = await _repository.createActivity(
        spmUuid: spmUuid,
        status: status,
        description: description,
        opdUuid: opdUuid,
        latitude: latitude,
        longitude: longitude,
        attachmentKeys: attachmentKeys,
        attachmentPaths: attachmentPaths,
      );

      if (response.data['status']) {
        emit(
          state.copyWith(
            formStatus: FormStatus.success,
            formResponse: response,
          ),
        );
      } else {
        emit(
          state.copyWith(
            formStatus: FormStatus.error,
            formError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          formStatus: FormStatus.error,
          formError: e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  Future<void> fetchOpd({String? serviceCategoryUuid}) async {
    emit(state.copyWith(opdStatus: OpdStatus.loading));

    try {
      final opd = await _repository.fetchOpd(
        serviceCategoryUuid: serviceCategoryUuid,
      );

      emit(state.copyWith(opdStatus: OpdStatus.success, opd: opd));
    } on DioException catch (e) {
      emit(
        state.copyWith(
          opdStatus: OpdStatus.error,
          opdError: e.response?.data['meesage'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }
}
