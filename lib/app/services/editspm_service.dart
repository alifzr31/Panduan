import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/service_category.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class EditSpmService extends DioClient {
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
      for (var i = 0; i < (attachmentUuids?.length ?? 0); i++) ...{
        'uuid_file[$i]': attachmentUuids?[i],
      },
      if (spmAttachments != null) ...{
        for (var i = 0; i < (spmAttachments.length); i++) ...{
          'key_file[$i]': spmAttachments[i].key,
          if (attachmentPaths?[spmAttachments[i].key] != null &&
              (attachmentPaths?[spmAttachments[i].key]?.isNotEmpty ??
                  false)) ...{
            'file[$i]': await MultipartFile.fromFile(
              attachmentPaths?[spmAttachments[i].key] ?? '',
            ),
          },
          'checklist[$i]': (checklistAttachments?[i] ?? false) ? 1 : 0,
        },
      },
    });

    try {
      final response = await post(
        '/user-submission/update/$spmUuid',
        data: formData,
      );

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }
}
