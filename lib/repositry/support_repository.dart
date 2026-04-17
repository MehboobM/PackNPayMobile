import 'package:dio/dio.dart';
import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/compalint_history.dart';

class SupportRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  /// Create Support Ticket
  Future<bool> createSupportTicket({
    required String issueType,
    required String message,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "issue_type": issueType,
        "message": message,
      };

      final Response response = await _networkHandler.post(
        ApiEndPoints.createSupportTicket,
        body,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return response.data['success'] ?? true;
      } else {
        throw Exception(
          response.data['error'] ?? "Failed to submit complaint",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ??
            "Unable to submit complaint",
      );
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
  Future<List<SupportTicketModel>> getMySupportTickets() async {
    try {
      final Response response = await _networkHandler.get(
        ApiEndPoints.getMySupportTickets,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final List data = response.data['data'];
        return data
            .map((e) => SupportTicketModel.fromJson(e))
            .toList();
      } else {
        throw Exception(
          response.data['error'] ?? "Failed to load tickets",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ??
            "Unable to fetch complaint history",
      );
    }
  }
}