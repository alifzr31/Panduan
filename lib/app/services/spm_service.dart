import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/spm_field.dart';
import 'package:panduan/app/utils/app_env.dart';

class SpmService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<List<SpmField>> fetchSpmFields() async {
    try {
      final response = await get(
        '/spm-field',
        queryParams: {'page': 1, 'limit': 10},
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listSpmFieldFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }
}
