import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_state/OrderDetailState.dart';
import '../api_services/network_handler.dart';
import '../database/shared_preferences/shared_storage.dart';
import '../repositry/order_detail_repo.dart';

final orderDetailProvider =
    StateNotifierProvider<OrderDetailNotifier, OrderDetailState>(
      (ref) => OrderDetailNotifier(OrderDetailRepository(NetworkHandler())),
    );

class OrderDetailNotifier extends StateNotifier<OrderDetailState> {
  final OrderDetailRepository repository;

  OrderDetailNotifier(this.repository) : super(OrderDetailState());


  void clearState() {
    state = OrderDetailState();
    //If you only want to clear data but keep loading state untouched:
     //state = state.copyWith(orderData: null);
  }

  Future<bool> fetchOrderByUid(String uid) async {
    state = state.copyWith(isPageLoading: true);

    try {
      final orderData = await repository.fetchOrderByUid(uid);

      state = state.copyWith(isPageLoading: false, orderData: orderData);

      return true; // ✅ success
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      return false; // ❌ fail
    }
  }

  Future<List<dynamic>> searchStaff(String query) async {
    final companyId = await StorageService().getCompanyId() ?? "-1";
    try {
      return await repository.searchStaff(
        search: query,
        companyId: int.parse(companyId), // ✅ dynamic later
      );
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> searchLabour(String query) async {
    final companyId = await StorageService().getCompanyId() ?? "-1";
    try {
      return await repository.searchLabour(
        search: query,
        companyId: int.parse(companyId), // ✅ dynamic later
      );
    } catch (e) {
      return [];
    }
  }


  Future<String?> updateOrder({
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
    state = state.copyWith(isPageLoading: true);

    try {
      await repository.updateOrder(
        id: id,
        uid: uid,
        vehicleNo: vehicleNo,
        driverName: driverName,
        driverPhone: driverPhone,
        driverLicense: driverLicense,
        expenses: expenses, // ✅ PASS
        staff: staff,       // ✅ PASS
        labour: labour,     // ✅ PASS
      );

      final orderData = await repository.fetchOrderByUid(uid);

      state = state.copyWith(isPageLoading: false, orderData: orderData);

      return "Order updated successfully";
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      return e.toString();
    }
  }


  Future<List<dynamic>> fetchExpenseCategories() async {
    try {
      final data = await repository.fetchExpenseCategories();
      return data ?? []; // ✅ always return list
    } catch (e) {
      print("Expense Category Error: $e");
      return []; // ✅ avoid null crash
    }
  }



  Future<String?> updateOrderStatus({
    required String uid,
    required String status,
    String? otp,
  }) async {
    state = state.copyWith(isPageLoading: true);

    try {
      final message = await repository.updateOrderStatus(
        uid: uid,
        status: status,
        otp: otp,
      );

      final orderData = await repository.fetchOrderByUid(uid);

      state = state.copyWith(
        isPageLoading: false,
        orderData: orderData,
      );

      return message;
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      return null;
    }
  }




  Future<void> getFormData(String uid) async {
    state = state.copyWith(isPageLoading: true);

    try {
      final data = await repository.fetchOrderById(uid);

      state = state.copyWith(isPageLoading: false, orderData: data);
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      rethrow;
    }
  }

  Future<String?> createOrderAndRefresh(String quotationId) async {
    state = state.copyWith(isPageLoading: true);
    try {
      final uid = await repository.createOrder(quotationId);
      final orderData = await repository.fetchOrderByUid(uid);

      state = state.copyWith(isPageLoading: false, orderData: orderData);

      return "Order created successfully"; // or from API
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      return e.toString(); // error message
    }
  }




  Future<String?> updatePackingAndUnpackingOrder({
    required String uid,
    required String mediaType,
    required List<File> images,
  }) async {
    state = state.copyWith(isPageLoading: true);

    try {
      final responseMessage = await repository.uploadPackingUnpacking(
        uid: uid,
        mediaType: mediaType,
        images: images,
      );

      final orderData = await repository.fetchOrderByUid(uid);

      state = state.copyWith(
        isPageLoading: false,
        orderData: orderData,
      );

      return responseMessage; // ✅ dynamic message from API
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      return null; // ❗ return null for error
    }
  }






}
