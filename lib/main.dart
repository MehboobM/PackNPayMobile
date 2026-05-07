
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/routes/routes.dart';
import 'package:toastification/toastification.dart';

import 'database/shared_preferences/shared_storage.dart';
import 'firebase_options.dart';
import 'notification/local_notification_service.dart';

/// ======================================
/// GLOBAL NAVIGATOR KEY
/// ======================================
final GlobalKey<NavigatorState> navigatorKey =
    LocalNotificationService.navigatorKey;

/// ======================================
/// REQUEST NOTIFICATION PERMISSION
/// ======================================
Future<void> requestNotificationPermission() async {
  /// ANDROID 13+
  if (Platform.isAndroid) {
    final FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    final androidImplementation =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation
        ?.requestNotificationsPermission();
  }

  /// FIREBASE PERMISSION
  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  debugPrint(
    "🔔 Notification Permission => ${settings.authorizationStatus}",
  );
}

/// ======================================
/// BACKGROUND HANDLER
/// ======================================
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint(
    "📩 Background Message => ${message.messageId}",
  );
}

/// ======================================
/// GET FCM TOKEN
/// ======================================
Future<String?> getFcmToken() async {
  try {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    String? token =
    await FirebaseMessaging.instance.getToken();

    debugPrint("================================");
    debugPrint("🔥 FCM TOKEN => $token");
    debugPrint("================================");

    return token;
  } catch (e) {
    debugPrint("❌ FCM TOKEN ERROR => $e");
    return null;
  }
}

/// ======================================
/// FIREBASE LISTENERS
/// ======================================
Future<void> setupFirebaseListeners() async {
  /// FOREGROUND MESSAGE
  FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
      debugPrint("📩 Foreground Message Received");

      debugPrint(
        "📩 Title => ${message.notification?.title}",
      );

      debugPrint(
        "📩 Body => ${message.notification?.body}",
      );

      /// SHOW LOCAL NOTIFICATION ONLY IN FOREGROUND
      if (message.notification != null) {
        await LocalNotificationService.showNotification(
          id: message.hashCode,
          title:
          message.notification?.title ??
              "Notification",
          body:
          message.notification?.body ?? "",
        );
      }
    },
  );

  /// APP OPEN FROM BACKGROUND
  FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
      debugPrint(
        "📲 Notification Clicked From Background",
      );

      navigatorKey.currentState
          ?.pushNamed('/dashboard');
    },
  );

  /// APP OPEN FROM TERMINATED
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance
      .getInitialMessage();

  if (initialMessage != null) {
    debugPrint(
      "📲 App Opened From Terminated Notification",
    );

    Future.delayed(
      const Duration(seconds: 1),
          () {
        navigatorKey.currentState
            ?.pushNamed('/dashboard');
      },
    );
  }
}

/// ======================================
/// MAIN
/// ======================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// FIREBASE INIT
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// BACKGROUND HANDLER
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  /// LOCAL NOTIFICATION INIT
  await LocalNotificationService.init();

  /// REQUEST PERMISSION
  await requestNotificationPermission();

  /// FIREBASE LISTENERS
  await setupFirebaseListeners();

  /// GET FCM TOKEN
  await getFcmToken();

  /// HIVE
  await Hive.initFlutter();

  await Hive.openBox('quotationBox');
  await Hive.openBox('authBox');
  await Hive.openBox('notificationBox');

  /// ORIENTATION
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// LOCALIZATION
  await EasyLocalization.ensureInitialized();

  final storage = StorageService();

  final savedLocale =
  await storage.getLocal();

  final initialLocale =
  savedLocale != null
      ? Locale(savedLocale)
      : const Locale('en');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('ka'),
        Locale('ml'),
        Locale('ta'),
      ],
      path: 'assets/lang',
      startLocale: initialLocale,
      fallbackLocale: const Locale('en'),
      child: ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            return ToastificationWrapper(
              child: MaterialApp(
                debugShowCheckedModeBanner:
                false,
                navigatorKey:
                navigatorKey,
                initialRoute:
                splashScreenRoute,
                onGenerateRoute:
                NavigationRouter
                    .generateRoute,
                localizationsDelegates:
                context
                    .localizationDelegates,
                supportedLocales:
                context
                    .supportedLocales,
                locale:
                context.locale,
              ),
            );
          },
        ),
      ),
    ),
  );
}



/*import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/routes/routes.dart';
import 'package:toastification/toastification.dart';

import 'database/shared_preferences/shared_storage.dart';
import 'notification/local_notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = LocalNotificationService.navigatorKey;

Future<void> requestNotificationPermission() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidImplementation?.requestNotificationsPermission();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// Robust function to get FCM Token
Future<void> getFcmToken() async {
  for (int i = 0; i < 3; i++) {
    try {
      // Small delay to allow Google Play Services to warm up
      await Future.delayed(Duration(seconds: 2 * (i + 1)));
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        print("---------------------------------------");
        print("🔥 FCM TOKEN: $token");
        print("---------------------------------------");
        return;
      }
    } catch (e) {
      print("Attempt ${i + 1}: Error getting FCM token: $e");
      if (i == 2) print("❌ Final check: Is your internet working and does this device have Google Play Store?");
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await LocalNotificationService.init();
  await requestNotificationPermission(); 

  // Call the robust token fetch
  getFcmToken();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      LocalNotificationService.showNotification(
        id: message.notification.hashCode,
        title: message.notification?.title ?? "Notification",
        body: message.notification?.body ?? "",
      );
    }
  });

  await Hive.initFlutter();
  await Hive.openBox('quotationBox');
  await Hive.openBox('authBox');
  await Hive.openBox('notificationBox');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EasyLocalization.ensureInitialized();

  final storage = StorageService();
  final savedLocale = await storage.getLocal();
  final initialLocale = savedLocale != null ? Locale(savedLocale) : const Locale('en');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('ka'),
        Locale('ml'),
        Locale('ta'),
      ],
      path: 'assets/lang',
      startLocale: initialLocale,
      fallbackLocale: const Locale('en'),
      child: ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            return ToastificationWrapper(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: splashScreenRoute,
                onGenerateRoute: NavigationRouter.generateRoute,
                navigatorKey: navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              ),
            );
          },
        ),
      ),
    ),
  );
}*/
