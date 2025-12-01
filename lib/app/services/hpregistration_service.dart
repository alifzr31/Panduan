import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/hp_registration.dart';
import 'package:panduan/app/utils/app_env.dart';

class HpRegistrationService extends DioClient {
  @override
  String get baseUrl => AppEnv.basePublicUrl;

  Future<HpRegistration?> fetchHpRegistration({int? healthPostId}) async {
    try {
      final response = await get('/healthpostreg/registrations/$healthPostId');

      return await compute(
        (message) => message.isEmpty ? null : hpRegistrationFromJson(message),
        response.data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }
}
