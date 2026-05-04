import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location_modal.dart';
import '../repositry/lr_city_state.dart';

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