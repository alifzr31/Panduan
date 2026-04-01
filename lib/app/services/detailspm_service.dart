import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/utils/app_env.dart';

class DetailSpmService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<Spm?> fetchDetailSpm({String? uuid, bool? isEdit}) async {
    try {
      final response = await get(
        '/user-submission/$uuid',
        queryParams: {'is_edit': ?isEdit},
      );

      return await compute(
        (message) => spmFromJson(message),
        response.data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteSpm({String? uuid}) async {
    try {
      final response = await delete('/user-submission/delete/$uuid');

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }
}
