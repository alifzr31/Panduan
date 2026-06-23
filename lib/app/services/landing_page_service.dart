import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/utils/app_env.dart';

class LandingPageService extends DioClient {
  @override
  String get baseUrl => AppEnv.basePublicUrl;

  Future<String?> fetchUserManualUrl({CancelToken? cancelToken}) async {
    try {
      final response = await get(
        '/landingpage/profile',
        queryParams: {'page': 1, 'limit': 1},
        cancelToken: cancelToken,
      );

      final listData = response.data['data'] as List?;

      if (listData == null || listData.isEmpty) {
        return null;
      }

      final data = listData.first;

      return await compute((message) => message['link'], data);
    } catch (e) {
      rethrow;
    }
  }
}
