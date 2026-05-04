import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/repositry/lorry_receipt_repository.dart';
import '../api_services/network_handler.dart';
import '../models/city_modal.dart';

final cityRepositoryProvider = Provider<LorryReceiptRepository>((ref) {
  return LorryReceiptRepository(NetworkHandler());
});

final cityProvider =
FutureProvider<List<CityModel>>((ref) async {
  final repository = ref.read(cityRepositoryProvider);
  return repository.getCities();
});