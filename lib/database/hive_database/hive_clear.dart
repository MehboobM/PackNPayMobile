

import 'package:hive/hive.dart';

class HiveManager {
  static Future<void> clearAll() async {
    await Hive.box('quotationBox').clear();
    await Hive.box('authBox').clear();
    await Hive.box('notificationBox').clear();
  }
}


//await HiveManager.clearAll();
// await storage.clearAll(); // (if you have this)
// Navigator.pushNamedAndRemoveUntil(
//   context,
//   loginRoute,
//   (route) => false,
// );