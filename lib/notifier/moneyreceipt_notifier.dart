import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/moneyreceipt_list.dart';
import '../repositry/money_receipt_repository.dart';
import '../repositry/userstaff_repository.dart'; // ✅ ADD

final moneyReceiptProvider =
ChangeNotifierProvider<MoneyReceiptNotifier>((ref) {
  return MoneyReceiptNotifier();
});

class MoneyReceiptNotifier extends ChangeNotifier {
  final MoneyReceiptRepo _repo = MoneyReceiptRepo();
  final UserRepository _userRepo = UserRepository(); // ✅ ADD

  List<MoneyReceiptModel> receipts = [];
  List<MoneyReceiptModel> filteredReceipts = [];

  /// ✅ STAFF LIST (for bottom sheet)
  List<Map<String, dynamic>> staffList = []; // ✅ ADD

  bool isLoading = false;

  int page = 1;
  int limit = 10;

  /// 🔥 FILTER STATE
  String _searchQuery = '';
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _sortOrder;
  int? _staffId;

  Timer? _debounce;
  String get searchQuery => _searchQuery;

  /// ✅ GETTERS
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  String? get sortOrder => _sortOrder;
  int? get staffId => _staffId;

  /// ✅ FETCH STAFF LIST (FOR DROPDOWN)
  Future<void> fetchStaffList() async {
    try {
      staffList = await _userRepo.getStaffList();
      notifyListeners();
    } catch (e) {
      print("STAFF LIST ERROR: $e");
    }
  }

  /// 🔹 FETCH RECEIPTS WITH FILTERS
  Future<void> fetchReceipts() async {
    isLoading = true;
    notifyListeners();

    try {
      /// ✅ ENSURE STAFF LIST IS AVAILABLE
      if (staffList.isEmpty) {
        await fetchStaffList();
      }

      final from = _fromDate != null
          ? "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}"
          : null;

      final to = _toDate != null
          ? "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}"
          : null;

      final data = await _repo.getMoneyReceiptsWithFilters(
        page: page,
        limit: limit,
        search: _searchQuery,
        fromDate: from,
        toDate: to,
        sortOrder: _sortOrder,
        staffId: _staffId,
      );

      receipts = data;
      filteredReceipts = data;
    } catch (e) {
      print("Notifier Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔍 SEARCH (DEBOUNCED)
  void updateSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchQuery = query;
      fetchReceipts();
    });
  }

  /// 📅 DATE FILTER
  void updateDateRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    fetchReceipts();
  }

  /// 🔽 SORT
  void updateSort(String? sortOrder) {
    _sortOrder = sortOrder;
    fetchReceipts();
  }

  /// 👤 STAFF FILTER
  void updateStaff(int? staffId) {
    _staffId = staffId;
    fetchReceipts();
  }

  /// ❌ DELETE
  Future<void> deleteReceipt(String uid) async {
    await _repo.deleteReceipt(uid);

    receipts.removeWhere((e) => e.uid == uid);
    filteredReceipts.removeWhere((e) => e.uid == uid);

    notifyListeners();
  }

  /// 🔹 GET SINGLE
  Future<Map<String, dynamic>> getReceiptByUid(String uid) async {
    final data = await _repo.getReceiptByUid(uid);
    return Map<String, dynamic>.from(data);
  }

  /// 🔹 ADD
  void addReceipt(MoneyReceiptModel receipt) {
    receipts.insert(0, receipt);
    filteredReceipts = receipts;
    notifyListeners();
  }

  /// 🔹 UPDATE
  void updateReceiptInList(MoneyReceiptModel receipt) {
    final index = receipts.indexWhere((e) => e.uid == receipt.uid);
    if (index != -1) {
      receipts[index] = receipt;
      filteredReceipts = receipts;
      notifyListeners();
    }
  }
}