import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/health_post.dart';
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

  Future<List<Spm>> fetchSpm({
    int? page,
    String? keyword,
    int? month,
    int? year,
    String? districtCode,
    String? subDistrictCode,
    String? healthPostUuid,
    String? spmFieldName,
    Set<String>? statuses,
  }) async {
    try {
      final response = await get(
        '/user-submission/list-with-detail',
        queryParams: {
          'page': page,
          'limit': 10,
          if (keyword != null || (keyword?.isNotEmpty ?? false)) 'q': keyword,
          if (month != null) 'month': month,
          'year': year,
          if (districtCode != null) ...{'district_code': districtCode},
          if (subDistrictCode != null) ...{
            'sub_district_code': subDistrictCode,
          },
          if (healthPostUuid != null) ...{'health_post_uuid': healthPostUuid},
          if (spmFieldName != null) ...{'spm_name': spmFieldName},
          if (statuses?.isNotEmpty ?? false) ...{
            'statuses': statuses?.join(','),
          },
          'order': 'updated_at',
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

  Future<List<HealthPost>> fetchHealthPosts({
    int? page,
    String? keyword,
    String? districtCode,
    String? subDistrictCode,
  }) async {
    try {
      final response = await get(
        '/health-post',
        queryParams: {
          'page': page,
          'limit': 10,
          'order': 'name',
          'sort': 'asc',
          if (keyword != null && keyword.isNotEmpty) ...{'q': keyword},
          if (districtCode != null) ...{'district_code': districtCode},
          if (subDistrictCode != null) ...{
            'sub_district_code': subDistrictCode,
          },
        },
      );

      return await compute(
        (message) =>
            message == null ? const [] : listHealthPostFromJson(message),
        response.data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }
}
