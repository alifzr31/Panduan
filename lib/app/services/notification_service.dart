import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/models/notification.dart';
import 'package:panduan/app/utils/app_env.dart';

class NotificationService extends DioClient {
  @override
  String get baseUrl => AppEnv.baseOwnerUrl;

  Future<List<Notification>> fetchNotifications({int? page}) async {
    try {
      final response = await get(
        '/notification',
        queryParams: {'page': page, 'limit': 10},
      );

      return response.data['data'] == null
          ? const []
          : await compute(
              (message) => listNotificationFromJson(message),
              response.data['data'],
            );
    } catch (e) {
      rethrow;
    }
  }

  Future<Notification?> fetchDetailNotification({
    String? notificationUuid,
  }) async {
    try {
      final response = await get('/notification/$notificationUuid');

      return await compute(
        (message) => message == null ? null : notificationFromJson(message),
        response.data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> readAllNotification() async {
    try {
      final response = await get('/notification/read-all');

      return await compute((message) => message, response);
    } catch (e) {
      rethrow;
    }
  }
}
