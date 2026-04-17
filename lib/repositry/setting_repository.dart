import 'package:dio/dio.dart';
import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/setting_modal.dart';

class SettingsRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<SettingsModel> getSettings() async {
    final response = await NetworkHandler().get(
      ApiEndPoints.getSettings,
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return SettingsModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['error'] ?? "Failed to load settings");
    }
  }
  Future<bool> updateWatermarkSettings(
      Map<String, dynamic> body) async {
    try {
      final response = await _networkHandler.put(
        ApiEndPoints.updateWatermarkSettings,
        body,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return response.data['success'] ?? true;
      } else {
        throw Exception(
          response.data['error'] ?? "Failed to update settings",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ??
            "Unable to update watermark settings",
      );
    }
  }
  Future<bool> updateLetterHeadSettings(
      Map<String, dynamic> body) async {
    try {
      final response = await _networkHandler.put(
        ApiEndPoints.updateLetterHeadSettings,
        body,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return response.data['success'] ?? true;
      } else {
        throw Exception(
          response.data['error'] ?? "Failed to update letterhead settings",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ??
            "Unable to update letterhead settings",
      );
    }
  }
  Future<bool> updateQuotationSettings(
      Map<String, dynamic> body) async {
    try {
      final response = await _networkHandler.put(
        ApiEndPoints.updateQuotationSettings,
        body,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return response.data['success'] ?? true;
      } else {
        throw Exception(
          response.data['error'] ??
              "Failed to update quotation settings",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ??
            "Unable to update quotation settings",
      );
    }
  }

  Future<bool> updateLRSettings(
      Map<String, dynamic> body) async {
    try {
      final response = await _networkHandler.put(
        ApiEndPoints.updateLRSettings,
        body,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return response.data['success'] ?? true;
      } else {
        throw Exception(
          response.data['error'] ??
              "Failed to update LR settings",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ??
            "Unable to update LR settings",
      );
    }
  }
}