import 'package:dio/dio.dart';
import '../api_services/network_handler.dart';
import '../api_services/api_end_points.dart';
import '../models/location_modal.dart';

class LocationRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<List<StateModel>> getStates() async {
    Response response =
    await _networkHandler.get(ApiEndPoints.getStates);

    if (response.statusCode == 200 &&
        response.data['success'] == true) {
      List data = response.data['data'];
      return data.map((e) => StateModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch states");
    }
  }

  Future<List<CityModel>> getCitiesByState(int stateId) async {
    try {
      Response response = await _networkHandler.get(
        ApiEndPoints.getCitiesByState,
        queryParams: {"state_id": stateId},
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(response.data['message'] ??
            "Failed to fetch cities");
      }
    } catch (e) {
      throw Exception("Error fetching cities: $e");
    }
  }

  Future<Map<String, dynamic>> getLocationByPincode(String pincode) async {
    try {
      Response response = await _networkHandler.get(
        ApiEndPoints.getLocationByPincode,
        queryParams: {"pincode": pincode},
      );

      /// ✅ ALWAYS RETURN RESPONSE (even if success = false)
      return response.data;

    } on DioException catch (e) {
      /// 🔥 IMPORTANT: HANDLE API ERROR RESPONSE
      if (e.response != null && e.response?.data != null) {
        return e.response!.data; // ✅ returns {"success":false,"message":"Invalid pincode"}
      }

      return {
        "success": false,
        "message": "Network error"
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong"
      };
    }
  }

  Future<Map<String, dynamic>?> getLocationByPincodes(String pincode) async {
    try {
      Response response = await _networkHandler.get(
        ApiEndPoints.getLocationByPincode, // 🔥 ADD THIS ENDPOINT
        queryParams: {"pincode": pincode},
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return response.data['data'];
      } else {
        return null;
      }
    } catch (e) {
      print("Pincode API Error: $e");
      return null;
    }
  }
}