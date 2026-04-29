import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/all_state/follow_up_state.dart';
import 'package:pack_n_pay/repositry/follow_up_repo.dart';

import '../api_services/network_handler.dart';

final followUpProvider = StateNotifierProvider<FollowUpNotifier, FollowUpState>((ref) {
  return FollowUpNotifier(FollowUpRepo(NetworkHandler()));
});

class FollowUpNotifier extends StateNotifier<FollowUpState> {
  final FollowUpRepo repo;

  FollowUpNotifier(this.repo) : super(FollowUpState());

  Future<Map<String, dynamic>> setFollowUp(Map<String, dynamic> body) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await repo.setFollowUp(body);

      state = state.copyWith(isLoading: false);

      return {
        "success": response['success'] ?? false,
        "message": response['message'] ?? "Success",
      };
    } catch (e) {
      state = state.copyWith(isLoading: false);

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}