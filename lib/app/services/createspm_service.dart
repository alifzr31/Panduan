import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/resident.dart';
import 'package:panduan/app/models/service_category.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class CreateSpmService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<List<ServiceCategory>> fetchServiceCategories({
    String? spmFieldUuid,
  }) async {
    try {
      final response = await get(
        '/service-category',
        queryParams: {
          'page': 1,
          'limit': 10,
          'q': null,
          'spm_field_uuid': spmFieldUuid,
        },
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listServiceCategoryFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }

  Future<Resident?> fetchResidentByNik({String? nik}) async {
    try {
      final response = await get('/user/show-by-nik/$nik');

      return await compute(
        (message) => residentFromJson(message),
        response.data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> verifyNikName({String? nik, String? name}) async {
    try {
      final response = await post(
        '/user/verify-nik',
        data: {'nik': nik, 'name': name},
      );

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }

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
    final attachmentKeys = spmAttachments?.map((e) {
      return e.key ?? '';
    }).toList();

    final attachments =
        (attachmentKeys?.contains('location_coordinates') ?? false)
        ? spmAttachments?.where((element) {
            return element.key != 'location_coordinates';
          }).toList()
        : spmAttachments;

    final formData = FormData.fromMap({
      'date': AppHelpers.formDateTimeFormat(submissionDate ?? DateTime(0000)),
      'nik': nik,
      'name': name,
      'address': address,
      'rt': rt,
      'rw': rw,
      'district_code': districtCode,
      'sub_district_code': subDistrictCode,
      'phone': phone,
      'type': serviceType?.toUpperCase(),
      'spm_field_uuid': spmFieldUuid,
      'service_category_uuid': serviceCategoryUuid,
      'description': reportDescription,
      if (latitude != null) ...{'latitude': latitude},
      if (longitude != null) ...{'longitude': longitude},
      if (attachments != null) ...{
        for (var i = 0; i < (attachments.length); i++) ...{
          'key_file[$i]': attachments[i].key,
          if (attachmentPaths?[attachments[i].key] != null &&
              (attachmentPaths?[attachments[i].key]?.isNotEmpty ?? false)) ...{
            'file[$i]': await MultipartFile.fromFile(
              attachmentPaths?[attachments[i].key] ?? '',
            ),
          } else ...{
            'checklist[$i]': (checklistAttachments?[i] ?? false) ? 1 : 0,
          },
        },
      },
    });

    try {
      final response = await post('/user-submission/create', data: formData);

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }
}
