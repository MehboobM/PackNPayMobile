import 'package:dio/dio.dart';
import '../api_services/network_handler.dart';
import '../api_services/api_end_points.dart';
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

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
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
  Future<UserModel> getUserByUid(String uid) async {
    try {
      Response response =
      await _networkHandler.get("user?uid=$uid");

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch user");
      }
    } catch (e) {
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
}