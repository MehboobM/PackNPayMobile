
import 'dart:io';

import 'package:dio/dio.dart';

import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/order_detail_model.dart';

class OrderDetailRepository {
  final NetworkHandler network;

  OrderDetailRepository(this.network);


  /// 🔍 STAFF SEARCH
  Future<List<dynamic>> searchStaff({
    required String search,
    required int companyId,
  }) async {
    final response = await network.get(
      "order/staff/search?search=$search&company_id=$companyId",
    );

    if (response.statusCode == 200 && response.data["success"] == true) {
      return response.data["data"];
    } else {
      return [];
    }
  }

  /// 🔍 LABOUR SEARCH
  Future<List<dynamic>> searchLabour({
    required String search,
    required int companyId,
  }) async {
    final response = await network.get(
      "order/labour/search?search=$search&company_id=$companyId",
    );

    if (response.statusCode == 200 && response.data["success"] == true) {
      return response.data["data"];
    } else {
      return [];
    }
  }

  Future<String> updateOrders({
    required int id,
    required String uid,
    String? vehicleNo,
    String? driverName,
    String? driverPhone,
    String? driverLicense,
    List<Map<String, dynamic>>? expenses, // ✅ ADD THIS
    List<Map<String, dynamic>>? staff,     // ✅ ADD
    List<Map<String, dynamic>>? labour,    // ✅ ADD
  }) async {
    try {
      final Map<String, dynamic> body = {
        "quotation_id": id,
        "staff": [],
        "labour": [],
        "expenses": [],
        "expenses": expenses ?? [], // ✅ dynamic
        "labour": labour ?? [],
        "expenses": expenses ?? [],
      };

      /// ✅ Add only if user entered value
      if (vehicleNo != null && vehicleNo.isNotEmpty) {
        body["vehicle_no"] = vehicleNo;
      }
      if (driverName != null && driverName.isNotEmpty) {
        body["driver_name"] = driverName;
      }
      if (driverPhone != null && driverPhone.isNotEmpty) {
        body["driver_phone"] = driverPhone;
      }
      if (driverLicense != null && driverLicense.isNotEmpty) {
        body["driver_license"] = driverLicense;
      }

      final response = await network.put(
        "${ApiEndPoints.updateOrder}/$uid",
        body,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return "Order updated successfully";
      } else {
        throw Exception("Update order failed");
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<String> updateOrder({
    required int id,
    required String uid,
    String? vehicleNo,
    String? driverName,
    String? driverPhone,
    String? driverLicense,
    List<Map<String, dynamic>>? expenses,
    List<Map<String, dynamic>>? staff,
    List<Map<String, dynamic>>? labour,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "quotation_id": id,
        "staff": staff ?? [],       // ✅ FIX
        "labour": labour ?? [],     // ✅ FIX
        "expenses": expenses ?? [], // ✅ FIX
      };

      if (vehicleNo != null && vehicleNo.isNotEmpty) {
        body["vehicle_no"] = vehicleNo;
      }
      if (driverName != null && driverName.isNotEmpty) {
        body["driver_name"] = driverName;
      }
      if (driverPhone != null && driverPhone.isNotEmpty) {
        body["driver_phone"] = driverPhone;
      }
      if (driverLicense != null && driverLicense.isNotEmpty) {
        body["driver_license"] = driverLicense;
      }

      print("FINAL PAYLOAD >>> $body"); // 🔥 DEBUG

      final response = await network.put(
        "${ApiEndPoints.updateOrder}/$uid",
        body,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return "Order updated successfully";
      } else {
        throw Exception("Update order failed");
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<List<dynamic>> fetchExpenseCategories() async {
    final response = await network.get("expense-category-list");

    if (response.statusCode == 200 && response.data["success"] == true) {
      return response.data["data"];
    } else {
      throw Exception("Failed to load categories");
    }
  }


  Future<String> updateOrderStatus({
    required String status,
    required String uid,
    String? otp,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "shipment_status": status,
        "otp": otp ?? ""
      };

      /// ✅ Only send OTP when required
      // if (otp != null && otp.isNotEmpty) {
      //   body["otp"] = otp;
      // }

      final response = await network.put(
        "${ApiEndPoints.updateOrderStatus}/$uid",
        body,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return response.data['message'] ?? "Order status updated";
      } else {
        throw Exception(response.data['message'] ?? "Update failed");
      }
    } catch (e) {
      rethrow;
    }
  }



  Future<OrderDetailModel> fetchOrderById(String uid) async {
    try {
      final response = await network.get(
        "${ApiEndPoints.prefillOrderFormApi}/$uid",
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return OrderDetailModel.fromJson(response.data); // ✅ full model
      } else {
        throw Exception("Failed to fetch");
      }
    } catch (e) {
      rethrow;
    }
  }



  Future<String> createOrder(String quotationId) async {
    try {
      final response = await network.post(ApiEndPoints.createOrder,
         {
          "quotation_id": quotationId,
          "vehicle_no": "",
          "driver_name": "",
          "driver_phone": "",
          "driver_license": "",
          "staff": [],
          "labour": [],
          "expenses": []
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['uid']; // ✅ IMPORTANT
      } else {
        throw Exception("Create order failed");
      }
    } catch (e) {
      rethrow;
    }
  }





  Future<OrderDetailModel> fetchOrderByUid(String uid) async {
    try {
      final response = await network.get(
        "${ApiEndPoints.getOrderByUid}?uid=$uid",
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return OrderDetailModel.fromJson(response.data); // ✅ SAME MODEL
      } else {
        throw Exception("Fetch order failed");
      }
    } catch (e) {
      rethrow;
    }
  }



  Future<String> uploadPackingUnpacking({
    required String uid,
    required String mediaType, // PACKING / UNPACKING
   /// required String description,
    required List<File> images,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "media_type": mediaType,
       // "description": description,

        /// 👇 multiple images like web
        "files": [
          for (var file in images)
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            )
        ],
      });

      final response = await network.post(
        "${ApiEndPoints.uploadMedia}/$uid",
        formData,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return "Uploaded successfully";
      } else {
        throw Exception("Upload failed");
      }
    } catch (e) {
      rethrow;
    }
  }




}