import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/models/spm_field.dart';
import 'package:panduan/app/utils/app_env.dart';

class SpmService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<List<Spm>> fetchSpm({
    int? page,
    String? keyword,
    int? month,
    int? year,
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
          if (statuses?.isNotEmpty ?? false) ...{
            'statuses': statuses?.join(','),
          },
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
