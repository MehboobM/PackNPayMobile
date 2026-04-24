import 'package:dio/dio.dart';
import '../api_services/network_handler.dart';
import '../api_services/api_end_points.dart';
import '../models/staff_details_modal.dart';
import '../models/staff_user_model.dart';

class UserRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<List<UserModel>> getUserList() async {
    try {
      Response response = await _networkHandler.get(ApiEndPoints.userList);

      if (response.statusCode == 200 && response.data['success'] == true) {
        List<dynamic> usersJson = response.data['data'];
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> createUser(Map<String, dynamic> body) async {
    try {
      Response response =
      await _networkHandler.post(ApiEndPoints.createUser, body);

      print("API RESPONSE => ${response.data}");

      if (response.data['success'] == true) {
        return true; // ✅ SUCCESS
      } else {
        throw Exception(response.data['message'] ?? "Something went wrong");
      }
    } catch (e) {
      print("CREATE USER ERROR => $e");
      rethrow;
    }
  }
  Future<bool> toggleUserStatus(String userId) async {
    try {
      Response response = await _networkHandler.patch(
        "user/toggle-status/$userId",
        {},
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? "Toggle failed");
      }
    } catch (e) {
      print("TOGGLE ERROR => $e");
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getUserByUid(String uid) async {
    try {
      Response response = await _networkHandler.get("user?uid=$uid");

      if (response.statusCode == 200) {
        return response.data; // ✅ DIRECT RETURN
      } else {
        throw Exception("Failed to fetch user");
      }
    } catch (e) {
      print("GET USER ERROR => $e");
      rethrow;
    }
  }

  Future<bool> updateUser(String uid, Map<String, dynamic> body) async {
    try {
      Response response = await _networkHandler.put(
        "user/update/$uid",
        body,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? "Update failed");
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> deleteUser(String uid) async {
    try {
      Response response = await _networkHandler.delete(
        "user/$uid", // Endpoint
        {},
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return true;
      } else {
        throw Exception(
          response.data['message'] ?? "Failed to delete user",
        );
      }
    } catch (e) {
      print("DELETE USER ERROR => $e");
      rethrow;
    }
  }
  Future<List<UserModel>> getUserListWithFilters({
    int page = 1,
    int limit = 15,
    String? search,
    String? fromDate,
    String? toDate,
    String? sortBy,
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
        if (sortBy != null) "sort_by": sortBy,
        if (sortOrder != null) "sort_order": sortOrder,
        if (staffId != null) "staff_id": staffId,
      };

      Response response = await _networkHandler.get(
        ApiEndPoints.userList,
        queryParams: queryParams,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        List<dynamic> usersJson = response.data['data'];
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<List<Map<String, dynamic>>> getStaffList() async {
    try {
      Response response = await _networkHandler.get("get-staff");

      if (response.statusCode == 200 && response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception("Failed to fetch staff");
      }
    } catch (e) {
      rethrow;
    }
  }
}