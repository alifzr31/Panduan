import 'package:dio/dio.dart';
import 'package:panduan/app/models/notification.dart';
import 'package:panduan/app/services/notification_service.dart';

abstract class NotificationRepository {
  Future<List<Notification>> fetchNotifications({int? page});
  Future<Notification?> fetchDetailNotification({String? notificationUuid});
  Future<Response> readAllNotification();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService _service;

  NotificationRepositoryImpl(this._service);

  @override
  Future<List<Notification>> fetchNotifications({int? page}) async {
    return await _service.fetchNotifications(page: page);
  }

  @override
  Future<Notification?> fetchDetailNotification({
    String? notificationUuid,
  }) async {
    return await _service.fetchDetailNotification(
      notificationUuid: notificationUuid,
    );
  }

  @override
  Future<Response> readAllNotification() async {
    return await _service.readAllNotification();
  }
}
