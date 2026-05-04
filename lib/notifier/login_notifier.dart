

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../all_state/auth_state.dart';
import '../api_services/network_handler.dart';
import '../repositry/auth_repository.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthRepository(NetworkHandler()));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repo;

  AuthNotifier(this.repo) : super(AuthState());



  Future<Map<String, dynamic>?> generateOtp(String mobile) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await repo.generateOtp(mobile);
      print("OTP Message >>> ${response['message']}");
      state = state.copyWith(isLoading: false);
      return response;
    } on DioException catch (e) {
      String message = "Something went wrong";

      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
        } else if (data is String) {
          try {
            final decoded = jsonDecode(data);
            message = decoded['message'] ?? message;
          } catch (_) {
            message = data; // fallback if not JSON
          }
        }
      }

      print("Final Error >>> $message");

      state = state.copyWith(isLoading: false, error: message);
      return null;
    }
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await repo.verifyOtp(
        mobile: mobile,
        otp: otp,
      );
      state = state.copyWith(isLoading: false);
      return response;
    } on DioException catch (e) {
      String message = "Something went wrong";
      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
        } else if (data is String) {
          try {
            final decoded = jsonDecode(data);
            message = decoded['message'] ?? message;
          } catch (_) {
            message = data; // fallback if not JSON
          }
        }
      }
      print("Final Error >>> $message");
      state = state.copyWith(isLoading: false, error: message);
      return null;
    }
  }

  Future<Map<String, dynamic>?> register({
    required String name,
    required String mobile,
    required String email,
    required String otp,
    required String companyName,
    required String gstNumber,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await repo.register(
        mobile: mobile,
        otp: otp,
        companyName: companyName,
        gstNumber: gstNumber,
        name: name,
        email: email,
      );
      state = state.copyWith(isLoading: false);
      return response;
    } on DioException catch (e) {
      String message = "Something went wrong";
      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
        } else if (data is String) {
          try {
            final decoded = jsonDecode(data);
            message = decoded['message'] ?? message;
          } catch (_) {
            message = data; // fallback if not JSON
          }
        }
      }
      print("Final Error >>> $message");
      state = state.copyWith(isLoading: false, error: message);
      return null;
    }
  }


}
