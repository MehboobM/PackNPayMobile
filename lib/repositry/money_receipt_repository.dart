import 'package:dio/dio.dart';

import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/moneyreceipt_list.dart';

class MoneyReceiptRepo {
  final NetworkHandler _networkHandler = NetworkHandler();

  /// 🔹 NORMAL LIST (optional fallback)
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

  /// ✅ 🔥 MAIN FILTER API (USE THIS)
  Future<List<MoneyReceiptModel>> getMoneyReceiptsWithFilters({
    int page = 1,
    int limit = 10,
    String? search,
    String? fromDate,
    String? toDate,
    String? sortOrder,
    int? staffId, // ✅ ADD
  }) async {
    try {
      final queryParams = {
        "page": page,
        "limit": limit,
        if (search != null && search.isNotEmpty) "search": search,
        if (fromDate != null) "from_date": fromDate,
        if (toDate != null) "to_date": toDate,
        if (sortOrder != null) "sort_order": sortOrder,
        if (staffId != null) "staff_id": staffId, // ✅ ADD
      };

      final response = await _networkHandler.get(
        ApiEndPoints.moneyReceiptList,
        queryParams: queryParams,
      );

      final data = response.data["data"] as List;

      return data
          .map((e) => MoneyReceiptModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Failed to load receipts");
    }
  }

  /// 🔹 OTHER METHODS (UNCHANGED)
  Future<void> createReceipt(Map<String, dynamic> body) async {
    await _networkHandler.post(
      ApiEndPoints.createMoneyReceipt,
      body,
    );
  }

  Future<Map<String, dynamic>> getReceiptByUid(String uid) async {
    final response = await _networkHandler.get(
      "/money-receipt",
      queryParams: {"uid": uid},
    );

    return response.data["data"];
  }

  Future<void> updateReceipt(String uid, Map<String, dynamic> body) async {
    await _networkHandler.put(
      "/money-receipt/update/$uid",
      body,
    );
  }

  Future<void> deleteReceipt(String uid) async {
    await _networkHandler.delete(
      "/money-receipt/$uid",
      null,
    );
  }
}