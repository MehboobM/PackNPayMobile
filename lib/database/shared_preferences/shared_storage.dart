

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


class StorageService {

  static const String _localeKey = "selected_locale";
  static const String _tokenKey = "auth_token";
  static const String _newUserKey = "new_user";
  static const String _isLoginKey = "login_click";
  static const String _userName = "user_name";
  static const String _companyId = "company_id";


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



}


