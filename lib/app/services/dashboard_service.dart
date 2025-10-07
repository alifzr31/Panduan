import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/models/spm_count.dart';
import 'package:panduan/app/models/spm_district_count.dart';
import 'package:panduan/app/models/spm_field_count.dart';
import 'package:panduan/app/models/spm_hp_count.dart';
import 'package:panduan/app/models/spm_subdistrict_count.dart';
import 'package:panduan/app/utils/app_env.dart';
import 'package:panduan/app/utils/app_helpers.dart';

class DashboardService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<int> fetchUnreadNotificationCount() async {
    try {
      final response = await get('/notification/count');

      return await compute(
        (message) => message,
        response.data['data']['unread'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<SpmCount?> fetchSpmCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await get(
        '/dashboard/count',
        queryParams: {
          'date_from': AppHelpers.formDateFormat(startDate ?? DateTime(0000)),
          'date_to': AppHelpers.formDateFormat(endDate ?? DateTime(0000)),
        },
      );

      return await compute(
        (message) => spmCountFromJson(message),
        response.data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<SpmFieldCount?> fetchSpmFieldCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await get(
        '/dashboard/by-spm',
        queryParams: {
          'date_from': AppHelpers.formDateFormat(startDate ?? DateTime(0000)),
          'date_to': AppHelpers.formDateFormat(endDate ?? DateTime(0000)),
        },
      );

      return await compute(
        (message) => spmFieldCountFromJson(message),
        response.data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SpmDistrictCount>> fetchSpmDistrictCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await get(
        '/dashboard/by-district',
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
  }) async {
    try {
      final response = await get(
        '/dashboard/by-sub-district',
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
  }) async {
    try {
      final response = await get(
        '/dashboard/by-health-post',
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

  Future<List<Spm>> fetchSpm() async {
    try {
      final response = await get(
        '/user-submission/list-with-detail',
        queryParams: {
          'page': 1,
          'limit': 3,
          'year': DateTime.now().year,
          'month': DateTime.now().month,
          'order': 'date',
          'sort': 'desc',
        },
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listSpmFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }
}
