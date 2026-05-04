import 'package:dio/dio.dart';
import '../api_services/network_handler.dart';
import '../api_services/api_end_points.dart';
import '../models/city_modal.dart';
import '../models/create_lorry_receipt.dart';
import '../models/lorry_receipt.dart';

class LorryReceiptRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  LorryReceiptRepository(NetworkHandler networkHandler);
  Future<List<LorryReceiptModel>> getLorryReceiptsWithFilters({
    int page = 1,
    int limit = 10,
    String? search,
    String? fromDate,
    String? toDate,
    String? sortOrder,
    int? staffId,
  }) async {
    try {
      final queryParams = {
        "page": page,
        "limit": limit,
        if (search != null && search.isNotEmpty) "search": search,
        if (fromDate != null) "from_date": fromDate,
        if (toDate != null) "to_date": toDate,
        if (sortOrder != null) "sort_order": sortOrder,
        if (staffId != null) "staff_id": staffId,
      };

      final response = await _networkHandler.get(
        ApiEndPoints.lrList,
        queryParams: queryParams,
      );

      final data = response.data["data"] as List;

      return data.map((e) => LorryReceiptModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to load lorry receipts");
    }
  }

  Future<List<LorryReceiptModel>> getLorryReceipts() async {
    try {
      Response response =
      await _networkHandler.get(ApiEndPoints.lrList);

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        List<dynamic> data = response.data['data'];
        return data
            .map((json) => LorryReceiptModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load lorry receipts");
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<List<CityModel>> getCities() async {
    try {
      Response response =
      await _networkHandler.get(ApiEndPoints.getAllCities);

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        List<dynamic> data = response.data['data'];
        return data
            .map((json) => CityModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load cities");
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> createLorryReceipt(
      CreateLorryReceiptRequest request) async {
    try {
      final response = await _networkHandler.post(
        ApiEndPoints.createLorryReceipt,
        request.toJson(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return response.data['success'] ?? true;
      } else {
        throw Exception(
            response.data['message'] ??
                "Failed to create Lorry Receipt");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? "Server error occurred");
    }
  }
  Future<Map<String, dynamic>> getLorryReceiptByUid(String uid) async {
    try {
      final response = await _networkHandler.get(
        ApiEndPoints.getLorryReceiptByUid(uid),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? "Failed to fetch lorry receipt");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? "Server error occurred");
    }
  }

  /// 🔹 Update Lorry Receipt
  Future<bool> updateLorryReceipt(
      String uid,
      CreateLorryReceiptRequest request,
      ) async {
    try {
      final response = await _networkHandler.put(
        ApiEndPoints.updateLorryReceipt(uid),
        request.toJson(),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return true;
      } else {
        throw Exception(
            response.data['message'] ?? "Failed to update Lorry Receipt");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? "Server error occurred");
    }
  }

  /// 🔹 Delete Lorry Receipt
  Future<bool> deleteLorryReceipt(String uid) async {
    try {
      final response = await _networkHandler.delete(
        ApiEndPoints.deleteLorryReceipt(uid),
        {},
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return true;
      } else {
        throw Exception(
            response.data['message'] ?? "Failed to delete Lorry Receipt");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? "Server error occurred");
    }
  }
  Future<Map<String, dynamic>> prefillByOrderNo(String orderNo) async {
    try {
      final response = await _networkHandler.get(
        "${ApiEndPoints.prefillByOrderNo}$orderNo",
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception("Failed to fetch prefill data");
      }
    } catch (e) {
      rethrow;
    }
  }

}