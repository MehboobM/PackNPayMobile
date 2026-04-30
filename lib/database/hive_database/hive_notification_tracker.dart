

import 'package:hive/hive.dart';

class NotificationTracker {
  static final box = Hive.box('notificationBox');

  static String _key(String id) => "notification_shown_$id";

  static bool isShown(String id) {
    return box.get(_key(id)) == true;
  }

  static Future<void> markShown(String id) async {
    await box.put(_key(id), true);
  }
}