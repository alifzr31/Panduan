import 'dart:io' show Platform;

import 'package:panduan/app/configs/local_notification/local_notif.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseNotif {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final LocalNotif localNotif = LocalNotif();

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) print('Provosional Notif Permission');
    } else {
      if (kDebugMode) print('Authorized Notif Permission');
    }
  }

  void firebaseInit() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) print('FOREGROUND FIREBASE NOTIF : $message');
      if (kDebugMode) print('DATA : ${message.data}');
      if (kDebugMode) print('DATA DATA : ${message.data['data']}');

      if (message.notification != null) {
        localNotif.showNotifications(
          id: message.notification.hashCode,
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data.toString(),
          imageUrl: message.notification?.android?.imageUrl,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) print(message.notification?.title);
      if (kDebugMode) print(message.notification?.body);
      if (kDebugMode) print(message.notification?.android?.imageUrl);
      if (kDebugMode) print(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        if (kDebugMode) {
          print('APP OPEN FROM NOTIFICATION WHEN APP TERMINATED');
          print(message.notification?.title);
          print(message.notification?.body);
          print(message.notification?.android?.imageUrl);
          print(message.data);
        }
      }
    });
  }

  Future<String?> getDeviceToken() async {
    try {
      if (Platform.isAndroid) {
        return await messaging.getToken();
      } else if (Platform.isIOS) {
        return await messaging.getAPNSToken();
      }

      return null;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}
