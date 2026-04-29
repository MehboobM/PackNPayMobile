import 'package:dio/dio.dart';
import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/subscription_history.dart';

class SubscriptionRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<List<SubscriptionHistoryModel>> getSubscriptionHistory() async {
    try {
      final Response response = await _networkHandler.get(
        ApiEndPoints.subscriptionHistory,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final List data = response.data['data'];

        return data
            .map((e) => SubscriptionHistoryModel.fromJson(e))
            .toList();
      } else {
        throw Exception(
          response.data['error'] ?? "Failed to load history",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ??
            "Unable to fetch subscription history",
      );
    }
  }
}