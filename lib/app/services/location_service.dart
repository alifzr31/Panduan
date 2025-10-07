import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/subdistrict.dart';
import 'package:panduan/app/utils/app_env.dart';

class LocationService extends DioClient {
  @override
  String get baseUrl => AppEnv.basePublicUrl;

  Future<List<District>> fetchDistricts({String? keyword}) async {
    try {
      final response = await get(
        '/district',
        queryParams: {
          'page': 1,
          'limit': 5,
          if (keyword != null || (keyword?.isNotEmpty ?? false)) 'q': keyword,
          'province_code': 32,
          'city_code': 73,
          'get_all_data': true,
        },
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listDistrictFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SubDistrict>> fetchSubDistricts({
    String? districtCode,
    String? keyword,
  }) async {
    try {
      final response = await get(
        '/sub-district',
        queryParams: {
          'page': 1,
          'limit': 5,
          if (keyword != null || (keyword?.isNotEmpty ?? false)) 'q': keyword,
          'province_code': 32,
          'city_code': 73,
          'district_code': districtCode,
          'get_all_data': true,
        },
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listSubDistrictFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }
}
