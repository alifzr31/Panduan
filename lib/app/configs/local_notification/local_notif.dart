import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class Image {
  static Future<Uint8List> downloadImage(String imageUrl) async {
    final dio = Dio();

    try {
      final response = await dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      return Uint8List.fromList(response.data!);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  static Future<String> saveImage(Uint8List? imageBytes) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temporary_image.png';
    await File(filePath).writeAsBytes(imageBytes ?? []);
    return filePath;
  }
}

class LocalNotif {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
          'global_notification',
          'Global Notification',
          importance: Importance.max,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          showBadge: true,
          sound: RawResourceAndroidNotificationSound('angklung'),
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        final payload = details.payload;

        if (payload != null) {
          if (kDebugMode) print('FOREGROUND PAYLOAD LOCAL NOTIF : $payload');
        }
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> showNotifications({id, title, body, payload, imageUrl}) async {
    try {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'global_notification',
            'Global Notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            fullScreenIntent: false,
            enableLights: true,
            enableVibration: true,
            playSound: true,
            channelShowBadge: true,
            sound: const RawResourceAndroidNotificationSound('angklung'),
            largeIcon: imageUrl == null
                ? null
                : FilePathAndroidBitmap(
                    await Image.saveImage(await Image.downloadImage(imageUrl)),
                  ),
            styleInformation: imageUrl == null
                ? null
                : BigPictureStyleInformation(
                    FilePathAndroidBitmap(
                      await Image.saveImage(
                        await Image.downloadImage(imageUrl),
                      ),
                    ),
                    contentTitle: title,
                    summaryText: body,
                    hideExpandedLargeIcon: true,
                  ),
          );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
