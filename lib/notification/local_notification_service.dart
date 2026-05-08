import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';


class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// GLOBAL NAVIGATION KEY
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  /// ANDROID CHANNEL
  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  /// INIT LOCAL NOTIFICATION
  static Future<void> init() async {
    /// ANDROID
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    /// IOS
    const DarwinInitializationSettings iosInit =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    /// COMBINED SETTINGS
    const InitializationSettings settings =
    InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    /// INITIALIZE
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        debugPrint(
            "🔔 Notification Clicked => ${response.payload}");

        if (response.payload == "dashboard") {
          navigatorKey.currentState
              ?.pushNamed('/dashboard');
        }
      },
    );

    /// CREATE ANDROID CHANNEL
    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// SHOW NOTIFICATION
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription:
      'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details =
    NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    print("🔥 iOS Local Notification Called");
    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: "dashboard",
    );
  }
}



// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//   FlutterLocalNotificationsPlugin();
//
//   /// 🔑 NAVIGATION KEY
//   static final GlobalKey<NavigatorState> navigatorKey =
//   GlobalKey<NavigatorState>();
//
//   /// INIT
//   static Future<void> init() async {
//     // ✅ ANDROID
//     const AndroidInitializationSettings androidInit =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // ✅ iOS (IMPORTANT FIX)
//     const DarwinInitializationSettings iosInit =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     // ✅ COMBINE
//     const InitializationSettings settings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit, // 🔥 THIS FIXES WHITE SCREEN
//     );
//
//     await _notifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (response) {
//         if (response.payload == "dashboard") {
//           navigatorKey.currentState?.pushNamed('/dashboard');
//         }
//       },
//     );
//   }
//
//   /// SHOW NOTIFICATION
//   static Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//     AndroidNotificationDetails(
//       'follow_up_channel',
//       'Follow Ups',
//       channelDescription: 'Follow up reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//       icon: '@mipmap/ic_launcher',
//     );
//
//     const DarwinNotificationDetails iosDetails =
//     DarwinNotificationDetails();
//
//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _notifications.show(
//       id,
//       title,
//       body,
//       details,
//       payload: "dashboard",
//     );
//   }
// }
