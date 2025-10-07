import 'package:dio/dio.dart';
import 'package:panduan/app/models/service_category.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/services/editspm_service.dart';

abstract class EditSpmRepository {
  Future<List<ServiceCategory>> fetchServiceCategories({String? spmFieldUuid});
  Future<Response> updateSpm({
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
  });
}

class EditSpmRepositoryImpl implements EditSpmRepository {
  final EditSpmService _service;

  EditSpmRepositoryImpl(this._service);

  @override
  Future<List<ServiceCategory>> fetchServiceCategories({
    String? spmFieldUuid,
  }) async {
    return await _service.fetchServiceCategories(spmFieldUuid: spmFieldUuid);
  }

  @override
  Future<Response> updateSpm({
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
    return await _service.updateSpm(
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
  }
}
