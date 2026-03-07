

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


class StorageService {

  static const String _localeKey = "selected_locale";
  static const String _tokenKey = "auth_token";


  Future<void> writeData(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value ?? "");
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


  ///Clear
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }



}


