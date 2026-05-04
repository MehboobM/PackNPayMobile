
import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';

class FollowUpRepo {
  final NetworkHandler network;

  FollowUpRepo(this.network);

  Future<dynamic> setFollowUp(Map<String, dynamic> body) async {
    try {
      final response = await network.post(
        ApiEndPoints.setFollowUp, body,
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        return response.data;
      } else {
        throw Exception("Failed to create quotation");
      }
    } catch (e) {
      rethrow;
    }
  }
}