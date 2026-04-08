import 'package:dio/dio.dart';

import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/moneyreceipt_list.dart';

class MoneyReceiptRepo {
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<List<MoneyReceiptModel>> getMoneyReceipts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Response response = await _networkHandler.get(
        ApiEndPoints.moneyReceiptList,
        queryParams: {
          "page": page,
          "limit": limit,
        },
      );

      final data = response.data["data"] as List;

      return data
          .map((e) => MoneyReceiptModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Failed to load receipts");
    }
  }
  Future<void> createReceipt(Map<String, dynamic> body) async {
    try {
      final Response response = await _networkHandler.post(
        ApiEndPoints.createMoneyReceipt,
        body,
      );

      print("CREATE RESPONSE: ${response.data}");
    } catch (e) {
      print("CREATE ERROR: $e");
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getReceiptByUid(String uid) async {
    final response = await _networkHandler.get(
      "/money-receipt",
      queryParams: {"uid": uid}, // ✅ FIXED
    );

    return response.data["data"];
  }
  Future<void> updateReceipt(String uid, Map<String, dynamic> body) async {
    try {
      final response = await _networkHandler.put(
        "/money-receipt/update/$uid",
        body,
      );

      print("UPDATE RESPONSE: ${response.data}");
    } catch (e) {
      print("UPDATE ERROR: $e");
      rethrow;
    }
  }
  Future<void> deleteReceipt(String uid) async {
    try {
      await _networkHandler.delete(
        "/money-receipt/$uid",
        null, // 👈 no body needed
      );
    } catch (e) {
      print("DELETE ERROR: $e");
      rethrow;
    }
  }
}