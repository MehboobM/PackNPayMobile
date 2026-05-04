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
}