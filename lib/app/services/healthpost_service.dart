import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/health_post.dart';
import 'package:panduan/app/utils/app_env.dart';

class HealthPostService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<List<HealthPost>> fetchHealthPosts({
    int? page,
    int? limit,
    String? keyword,
    String? districtCode,
    String? subDistrictCode,
  }) async {
    try {
      final response = await get(
        '/health-post',
        queryParams: {
          'page': page,
          'limit': limit,
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
