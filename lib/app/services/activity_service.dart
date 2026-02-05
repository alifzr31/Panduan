import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/opd.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class ActivityService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<Response> createActivity({
    String? spmUuid,
    String? serviceType,
    String? status,
    String? description,
    List<String>? opdUuids,
    double? latitude,
    double? longitude,
    List<String>? attachmentKeys,
    List<String>? attachmentPaths,
  }) async {
    final formData = FormData.fromMap({
      'user_submission_uuid': spmUuid,
      'type': serviceType?.toUpperCase(),
      'status': status,
      'description': description,
      'date': AppHelpers.formDateTimeFormat(DateTime.now()),
      if (opdUuids != null && opdUuids.isNotEmpty) ...{
        for (var i = 0; i < opdUuids.length; i++) ...{
          'opd_uuids[$i]': opdUuids[i],
        },
      },
      if (latitude != null) ...{'latitude': latitude},
      if (longitude != null) ...{'longitude': longitude},
      if (attachmentKeys?.first.isNotEmpty ?? false) ...{
        for (var i = 0; i < (attachmentKeys?.length ?? 0); i++) ...{
          if (attachmentKeys?.first.isNotEmpty ?? false) ...{
            'key_file[$i]': attachmentKeys?[i],
            'file[$i]': await MultipartFile.fromFile(attachmentPaths?[i] ?? ''),
          },
        },
      },
    });

    try {
      final response = await post(
        '/user-submission-activity/create',
        data: formData,
      );

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Opd>> fetchOpd() async {
    try {
      final response = await get(
        '/opd',
        queryParams: {
          'page': 1,
          'limit': 100,
          'province_code': 32,
          'city_code': 73,
          'order': 'name',
          'sort': 'asc',
        },
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listOpdFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }
}
