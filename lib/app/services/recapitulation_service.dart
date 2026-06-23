import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/spm_district_count.dart';
import 'package:panduan/app/models/spm_hp_count.dart';
import 'package:panduan/app/models/spm_subdistrict_count.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class RecapitulationService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<List<SpmDistrictCount>> fetchSpmDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await get(
        '/dashboard/by-district',
        cancelToken: cancelToken,
        queryParams: {
          'date_from': AppHelpers.formDateFormat(startDate ?? DateTime(0000)),
          'date_to': AppHelpers.formDateFormat(endDate ?? DateTime(0000)),
        },
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listSpmDistrictCountFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SpmSubDistrictCount>> fetchSpmSubDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await get(
        '/dashboard/by-sub-district',
        cancelToken: cancelToken,
        queryParams: {
          'date_from': AppHelpers.formDateFormat(startDate ?? DateTime(0000)),
          'date_to': AppHelpers.formDateFormat(endDate ?? DateTime(0000)),
        },
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listSpmSubDistrictCountFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SpmHpCount>> fetchSpmHpCount({
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await get(
        '/dashboard/by-health-post',
        cancelToken: cancelToken,
        queryParams: {
          'date_from': AppHelpers.formDateFormat(startDate ?? DateTime(0000)),
          'date_to': AppHelpers.formDateFormat(endDate ?? DateTime(0000)),
        },
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listSpmHpCountFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }
}
