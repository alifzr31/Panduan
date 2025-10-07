import 'package:dio/dio.dart';
import 'package:panduan/app/models/resident.dart';
import 'package:panduan/app/models/service_category.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/services/createspm_service.dart';

abstract class CreateSpmRepository {
  Future<List<ServiceCategory>> fetchServiceCategories({String? spmFieldUuid});
  Future<Resident?> fetchResidentByNik({String? nik});
  Future<Response> verifyNikName({String? nik, String? name});
  Future<Response> createSpm({
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
  });
}

class CreateSpmRepositoryImpl implements CreateSpmRepository {
  final CreateSpmService _service;

  CreateSpmRepositoryImpl(this._service);

  @override
  Future<List<ServiceCategory>> fetchServiceCategories({
    String? spmFieldUuid,
  }) async {
    return await _service.fetchServiceCategories(spmFieldUuid: spmFieldUuid);
  }

  @override
  Future<Resident?> fetchResidentByNik({String? nik}) async {
    return await _service.fetchResidentByNik(nik: nik);
  }

  @override
  Future<Response> verifyNikName({String? nik, String? name}) async {
    return await _service.verifyNikName(nik: nik, name: name);
  }

  @override
  Future<Response> createSpm({
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
    return await _service.createSpm(
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
  }
}
