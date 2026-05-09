


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/city_modal.dart';

final cityProviders = StateNotifierProvider<CityNotifier, CityState>((ref) {
  return CityNotifier();
});

class CityState {
  final List<CityModel> cities;
  final bool isLoading;
  final String? error;

  CityState({
    this.cities = const [],
    this.isLoading = false,
    this.error,
  });

  CityState copyWith({
    List<CityModel>? cities,
    bool? isLoading,
    String? error,
  }) {
    return CityState(
      cities: cities ?? this.cities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CityNotifier extends StateNotifier<CityState> {
  CityNotifier() : super(CityState());

  final NetworkHandler _network = NetworkHandler();

  /// 🔹 GET ALL CITIES
  Future<void> loadCities() async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _network.get(ApiEndPoints.getAllCities);

      if (response.data["success"] == true) {
        List list = response.data["data"];

        final cities = list.map((e) => CityModel.fromJson(e)).toList();

        state = state.copyWith(
          cities: cities,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to load cities",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<CityModel?> getCityByPincode(String pincode) async {
    try {
      final response = await _network.get(
        ApiEndPoints.getLocationByPincode,
        queryParams: {"pincode": pincode},
      );

      if (response.data["success"] == true) {
        final data = response.data["data"];

        return CityModel(
          id: data["city_id"],
          name: data["city"],        // ✅ FIXED
          stateName: data["state"],  // ✅ FIXED
        );
      } else {
        throw Exception(response.data["message"]);
      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>>pin code error is $e");
      rethrow;
    }
  }
}