import 'dart:io';
import 'package:dio/dio.dart';

import '../api_services/network_handler.dart';
import '../api_services/api_end_points.dart';

class ProfileRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<Response> updateProfile({
    required Map<String, dynamic> body,
    File? profileImage,
  }) async {
    try {
      /// Remove null values (clean request)
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
    } catch (e) {
      rethrow;
    }
  }
}