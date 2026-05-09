import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location_modal.dart';
import '../repositry/lr_city_state.dart';
import '../utils/toast_message.dart';

final locationRepositoryProvider =
Provider<LocationRepository>((ref) {
  return LocationRepository();
});

final stateProvider =
FutureProvider<List<StateModel>>((ref) async {
  return ref.read(locationRepositoryProvider).getStates();
});

final cityProvider =
FutureProvider.family<List<CityModel>, int>((ref, stateId) async {
  return ref
      .read(locationRepositoryProvider)
      .getCitiesByState(stateId);
});




final pincodeProvider =
StateNotifierProvider<PincodeNotifier, PincodeState>((ref) {
  return PincodeNotifier(ref);
});

class PincodeNotifier extends StateNotifier<PincodeState> {
  final Ref ref;

  PincodeNotifier(this.ref) : super(PincodeState());

  Future<bool> fetch(String pincode) async {
    state = state.copyWith(isLoading: true);

    final res = await ref.read(locationRepositoryProvider).getLocationByPincode(pincode);
    print("1111>>>>>>>>>>>>>>>>>>>$res");
    if (res != null && res['success'] == true) {
      final data = res['data'];

      state = state.copyWith(
        isLoading: false,
        stateId: data['state_id']?.toString(),
        cityId: data['city_id']?.toString(),
        stateName: data['state_name'],
        cityName: data['city_name'],
      );
      return true;
    } else {
      state = state.copyWith(isLoading: false);

      /// ✅ SHOW ERROR TOAST HERE
      ToastHelper.showError(
        message: res?['message'] ?? "Invalid pincode",
      );
      return false;
    }
  }
}


class PincodeState {
  final bool isLoading;
  final String? stateId;
  final String? cityId;
  final String? stateName;
  final String? cityName;

  PincodeState({
    this.isLoading = false,
    this.stateId,
    this.cityId,
    this.stateName,
    this.cityName,
  });

  PincodeState copyWith({
    bool? isLoading,
    String? stateId,
    String? cityId,
    String? stateName,
    String? cityName,
  }) {
    return PincodeState(
      isLoading: isLoading ?? this.isLoading,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      stateName: stateName ?? this.stateName,
      cityName: cityName ?? this.cityName,
    );
  }
}