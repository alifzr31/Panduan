import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/resident.dart';
import 'package:panduan/app/models/service_category.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/repositories/createspm_repository.dart';
import 'package:panduan/app/utils/app_strings.dart';

part 'createspm_state.dart';

class CreateSpmCubit extends Cubit<CreateSpmState> {
  CreateSpmCubit(this._repository) : super(const CreateSpmState());

  final CreateSpmRepository _repository;

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

  Future<void> fetchResidentByNik({String? nik}) async {
    emit(state.copyWith(residentStatus: ResidentStatus.loading));

    try {
      final resident = await _repository.fetchResidentByNik(nik: nik);

      emit(
        state.copyWith(
          residentStatus: ResidentStatus.success,
          resident: resident,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          residentStatus: ResidentStatus.error,
          residentError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void verifyNikName({String? nik, String? name}) async {
    emit(
      state.copyWith(
        resident: state.resident,
        verifyNikNameStatus: VerifyNikNameStatus.loading,
      ),
    );

    try {
      final response = await _repository.verifyNikName(nik: nik, name: name);

      if (response.data['status']) {
        emit(
          state.copyWith(
            resident: state.resident,
            verifyNikNameStatus: VerifyNikNameStatus.success,
            verifyNikNameResponse: response,
          ),
        );
      } else {
        emit(
          state.copyWith(
            resident: state.resident,
            verifyNikNameStatus: VerifyNikNameStatus.error,
            verifyNikNameError: response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          resident: state.resident,
          verifyNikNameStatus: VerifyNikNameStatus.error,
          verifyNikNameError:
              e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }

  void createSpm({
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
    List<SpmAttachment>? spmAttachments,
    Map<String, String>? attachmentPaths,
    List<bool>? checklistAttachments,
  }) async {
    emit(
      state.copyWith(resident: state.resident, formStatus: FormStatus.loading),
    );

    try {
      final response = await _repository.createSpm(
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
        spmAttachments: spmAttachments,
        attachmentPaths: attachmentPaths,
        checklistAttachments: checklistAttachments,
      );

      if (response.data['status']) {
        emit(
          state.copyWith(
            resident: state.resident,
            formStatus: FormStatus.success,
            formResponse: response,
          ),
        );
      } else {
        emit(
          state.copyWith(
            resident: state.resident,
            formStatus: FormStatus.error,
            formError: response.data['message'] ?? AppStrings.errorApiMessage,
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          resident: state.resident,
          formStatus: FormStatus.error,
          formError: e.response?.data['message'] ?? AppStrings.errorApiMessage,
        ),
      );
    }
  }
}
