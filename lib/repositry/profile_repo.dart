import 'dart:io';
import 'package:dio/dio.dart';

import '../api_services/network_handler.dart';
import '../api_services/api_end_points.dart';
import '../models/profile_modal.dart';
import '../models/location_modal.dart';

class ProfileRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  /// ================= GET PROFILE =================
  Future<ProfileModel?> getProfile() async {
    final response = await _networkHandler.get(ApiEndPoints.getProfile);

    if (response.statusCode == 200 && response.data["success"] == true) {
      return ProfileModel.fromJson(response.data["data"]);
    }
    return null;
  }

  /// ================= GET STATES =================
  Future<List<StateModel>> getStates() async {
    final response = await _networkHandler.get(ApiEndPoints.getStates);

    if (response.statusCode == 200 && response.data["success"] == true) {
      return (response.data["data"] as List)
          .map((e) => StateModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// ================= GET CITIES =================
  Future<List<CityModel>> getCities(int stateId) async {
    final response = await _networkHandler.get(
      ApiEndPoints.getCitiesByState,
      queryParams: {"state_id": stateId},
    );

    if (response.statusCode == 200 && response.data["success"] == true) {
      return (response.data["data"] as List)
          .map((e) => CityModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// ================= PINCODE =================
  Future<Map<String, dynamic>?> getLocationByPincode(String pincode) async {
    final response = await _networkHandler.get(
      ApiEndPoints.getLocationByPincode,
      queryParams: {"pincode": pincode},
    );

    if (response.statusCode == 200 && response.data["success"] == true) {
      return response.data["data"];
    }
    return null;
  }

  /// ================= UPDATE PROFILE =================
  Future<Response> updateProfile({
    required Map<String, dynamic> body,
    File? profileImage,
  }) async {
    body.removeWhere((key, value) => value == null || value == "");

    if (profileImage != null) {
      return await _networkHandler.putMultipart(
        ApiEndPoints.updateProfile,
        body: body,
        files: {
          "profile_image": profileImage,
        },
      );
    } else {
      return await _networkHandler.put(
        ApiEndPoints.updateProfile,
        body,
      );
    }
  }
}