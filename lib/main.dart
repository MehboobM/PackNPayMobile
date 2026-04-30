import 'package:easy_localization/easy_localization.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> requestNotificationPermission() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  await androidImplementation?.requestNotificationsPermission();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();
  await requestNotificationPermission(); // 👈 ADD THIS
  /// ✅ INIT HIVE
  await Hive.initFlutter();

  /// ✅ OPEN BOX (IMPORTANT)
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
  final initialLocale =
  savedLocale != null ? Locale(savedLocale) : const Locale('en');

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
}

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EasyLocalization.ensureInitialized();
  final storage = StorageService();

  final savedLocale = await storage.getLocal();
  final initialLocale = savedLocale != null ? Locale(savedLocale) : const Locale('en');

  runApp(  // u want to use ths where can use it ToastificationWrapper(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
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



