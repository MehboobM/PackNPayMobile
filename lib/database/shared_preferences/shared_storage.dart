

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _localeKey = "selected_locale";
  static const String _tokenKey = "auth_token";
  static const String _newUserKey = "new_user";
  static const String _isLoginKey = "login_click";
  static const String _userName = "user_name";
  static const String _companyId = "company_id";
  static const String _companyStatus = "company_status";
  static const String _subscriptionStatus = "subscription_status";
  static const String _companyName = "company_name";
  static const String _companyFullName = "company_full_name";
  static const String _companyLogo = "company_logo";
  static const String _fcmTokenKey = "FCMtoken";
  static const String _companyUid = "company_uid";

  Future<void> writeData(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null || value.isEmpty) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }

  Future<String?> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> saveLocal(String locale) async {
    await writeData(_localeKey, locale);
  }

  Future<String?> getLocal() async {
    return await readData(_localeKey);
  }

  /// ---- TOKEN ----
  Future<void> saveToken(String token) async {
    await writeData(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return await readData(_tokenKey);
  }

  Future<void> saveNewUser(String isNewUser) async {
    await writeData(_newUserKey, isNewUser);
  }

  Future<String?> getNewUser() async {
    return await readData(_newUserKey);
  }

  Future<void> saveIsLoginClick(String isLoginClick) async {
    await writeData(_isLoginKey, isLoginClick);
  }

  Future<String?> getIsLoginClick() async {
    return await readData(_isLoginKey);
  }

  Future<void> saveUserName(String name) async {
    await writeData(_userName, name);
  }

  Future<String?> getUserName() async {
    return await readData(_userName);
  }

  Future<void> saveCompanyId(String name) async {
    await writeData(_companyId, name);
  }

  Future<String?> getCompanyId() async {
    return await readData(_companyId);
  }

  ///Clear
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Refactored to avoid race conditions with clear()
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();

    // Explicitly remove only session-related keys
    // Keep FCM Token, Locale, and New User status
    final keysToRemove = [
      _tokenKey,
      _isLoginKey,
      _userName,
      _companyId,
      _companyStatus,
      _subscriptionStatus,
      _companyName,
      _companyFullName,
      _companyLogo,
    ];

    for (final key in keysToRemove) {
      await prefs.remove(key);
    }

    print("User session cleared. FCM Token and Locale preserved.");
  }

  Future<void> saveCompanyStatus(String status) async {
    await writeData(_companyStatus, status);
  }

  Future<String?> getCompanyStatus() async {
    return await readData(_companyStatus);
  }

  Future<void> saveSubscriptionStatus(String status) async {
    await writeData(_subscriptionStatus, status);
  }

  Future<String?> getSubscriptionStatus() async {
    return await readData(_subscriptionStatus);
  }

  Future<void> saveCompanyName(String name) async {
    await writeData(_companyName, name);
  }

  Future<String?> getCompanyName() async {
    return await readData(_companyName);
  }

  Future<void> saveCompanyFullName(String name) async {
    await writeData(_companyFullName, name);
  }

  Future<String?> getCompanyFullName() async {
    return await readData(_companyFullName);
  }

  Future<void> saveCompanyLogo(String logo) async {
    await writeData(_companyLogo, logo);
  }

  Future<String?> getCompanyLogo() async {
    return await readData(_companyLogo);
  }

  Future<void> saveFCMToken(String token) async {
    print("Saving FCM Token to Shared Preferences: $token");
    await writeData(_fcmTokenKey, token);
  }

  Future<String?> getFCMToken() async {
    final token = await readData(_fcmTokenKey);
    print("Reading FCM Token from Shared Preferences: $token");
    return token;
  }
  Future<void> saveCompanyUid(String uid) async {
    await writeData(_companyUid, uid);
  }

  Future<String?> getCompanyUid() async {
    return await readData(_companyUid);
  }
  Future<void> clearCompanyUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("company_uid");
  }
}


// class StorageService {
//
//   static const String _localeKey = "selected_locale";
//   static const String _tokenKey = "auth_token";
//   static const String _newUserKey = "new_user";
//   static const String _isLoginKey = "login_click";
//   static const String _userName = "user_name";
//   static const String _companyId = "company_id";
//   static const String _companyStatus = "company_status";
//   static const String _subscriptionStatus = "subscription_status";
//   static const String _companyName = "company_name";
//   static const String _companyFullName = "company_full_name";
//   static const String _companyLogo = "company_logo";
//
//
//   Future<void> writeData(String key, String? value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(key, value ?? "");
//   }
//   Future<String?> readData(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }
//
//
//
//   Future<void> saveLocal(String locale) async {
//     await writeData(_localeKey, locale);
//   }
//
//   Future<String?> getLocal() async {
//     return await readData(_localeKey);
//   }
//
//
//
//   /// ---- TOKEN ----
//   Future<void> saveToken(String token) async {
//     await writeData(_tokenKey, token);
//   }
//   Future<String?> getToken() async {
//     return await readData(_tokenKey);
//   }
//
//
//   Future<void> saveNewUser(String isNewUser) async {
//     await writeData(_newUserKey, isNewUser);
//   }
//   Future<String?> getNewUser() async {
//     return await readData(_newUserKey);
//   }
//
//   Future<void> saveIsLoginClick(String isLoginClick) async {
//     await writeData(_isLoginKey, isLoginClick);
//   }
//
//   Future<String?> getIsLoginClick() async {
//     return await readData(_isLoginKey);
//   }
//
//
//   Future<void> saveUserName(String name) async {
//     await writeData(_userName, name);
//   }
//
//   Future<String?> getUserName() async {
//     return await readData(_userName);
//   }
//
//
//   Future<void> saveCompanyId(String id) async {
//     await writeData(_companyId, id);
//   }
//
//   Future<String?> getCompanyId() async {
//     return await readData(_companyId);
//   }
//
//
//
//
//   ///Clear
//   Future<void> clearToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_tokenKey);
//   }
//
//   Future<void> clearAll() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
//
//   Future<void> saveCompanyStatus(String status) async {
//     await writeData(_companyStatus, status);
//   }
//
//   Future<String?> getCompanyStatus() async {
//     return await readData(_companyStatus);
//   }
//
//   Future<void> saveSubscriptionStatus(String status) async {
//     await writeData(_subscriptionStatus, status);
//   }
//
//   Future<String?> getSubscriptionStatus() async {
//     return await readData(_subscriptionStatus);
//   }
//   Future<void> saveCompanyName(String name) async {
//     await writeData(_companyName, name);
//   }
//
//   Future<String?> getCompanyName() async {
//     return await readData(_companyName);
//   }
//
//   Future<void> saveCompanyFullName(String name) async {
//     await writeData(_companyFullName, name);
//   }
//
//   Future<String?> getCompanyFullName() async {
//     return await readData(_companyFullName);
//   }
//
//   Future<void> saveCompanyLogo(String logo) async {
//     await writeData(_companyLogo, logo);
//   }
//
//   Future<String?> getCompanyLogo() async {
//     return await readData(_companyLogo);
//   }
//
//
// }


