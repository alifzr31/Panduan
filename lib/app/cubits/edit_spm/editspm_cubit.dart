import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/service_category.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/repositories/editspm_repository.dart';
import 'package:panduan/app/utils/app_strings.dart';

part 'editspm_state.dart';

class EditSpmCubit extends Cubit<EditSpmState> {
  EditSpmCubit(this._repository) : super(const EditSpmState());

  final EditSpmRepository _repository;

  Future<void> fetchServiceCategories({String? spmFieldUuid}) async {
    emit(state.copyWith(serviceCategoryStatus: ServiceCategoryStatus.loading));

    try {
      final serviceCategories = await _repository.fetchServiceCategories(
        spmFieldUuid: spmFieldUuid,
      );

      emit(
        state.copyWith(
          serviceCategoryStatus: ServiceCategoryStatus.success,
          serviceCategories: serviceCategories,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          serviceCategoryStatus: ServiceCategoryStatus.error,
          serviceCategoryError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void updateSpm({
    String? spmUuid,
    DateTime? submissionDate,
    String? nik,
    String? name,
    String? address,
    String? rt,
    String? rw,
    String? districtCode,
    String? subDistrictCode,
    String? phone,
    String? serviceType,
    String? spmFieldUuid,
    String? serviceCategoryUuid,
    String? reportDescription,
    double? latitude,
    double? longitude,
    List<String>? attachmentUuids,
    List<SpmAttachment>? spmAttachments,
    Map<String, String>? attachmentPaths,
    List<bool>? checklistAttachments,
  }) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    try {
      final response = await _repository.updateSpm(
        spmUuid: spmUuid,
        submissionDate: submissionDate,
        nik: nik,
        name: name,
        address: address,
        rt: rt,
        rw: rw,
        districtCode: districtCode,
        subDistrictCode: subDistrictCode,
        phone: phone,
        serviceType: serviceType,
        spmFieldUuid: spmFieldUuid,
        serviceCategoryUuid: serviceCategoryUuid,
        reportDescription: reportDescription,
        latitude: latitude,
        longitude: longitude,
        attachmentUuids: attachmentUuids,
        spmAttachments: spmAttachments,
        attachmentPaths: attachmentPaths,
        checklistAttachments: checklistAttachments,
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
            formError: response.data['message'] ?? AppStrings.errorApiMessage,
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
}
