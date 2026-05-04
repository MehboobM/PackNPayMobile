import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../all_state/lorry_receipt_state.dart';
import '../api_services/network_handler.dart';
import '../models/create_lorry_receipt.dart';
import '../models/lorry_receipt.dart';
import '../repositry/lorry_receipt_repository.dart';
import '../repositry/userstaff_repository.dart';

final lorryReceiptProvider =
StateNotifierProvider<LorryReceiptNotifier, LorryReceiptState>(
      (ref) => LorryReceiptNotifier(
    LorryReceiptRepository(NetworkHandler()),
  ),
);

class LorryReceiptNotifier extends StateNotifier<LorryReceiptState> {
  final LorryReceiptRepository repository;

  LorryReceiptNotifier(this.repository)
      : super(const LorryReceiptState()) {
    fetchStaffList();       // ✅ load staff
    fetchLorryReceipts();   // ✅ initial API call
  }

  /// 🔥 FILTER STATE
  String get searchQuery => _searchQuery;
  String _searchQuery = '';
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _sortOrder;
  int? _staffId;

  /// 👤 STAFF LIST (for dropdown)
  List<Map<String, dynamic>> staffList = [];

  /// ✅ GETTERS
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  String? get sortOrder => _sortOrder;
  int? get staffId => _staffId;

  /// 👤 FETCH STAFF LIST
  Future<void> fetchStaffList() async {
    try {
      final repo = UserRepository();
      staffList = await repo.getStaffList();
      state = state.copyWith(); // refresh UI
    } catch (e) {
      print("Staff fetch error: $e");
    }
  }

  /// 🔹 MAIN FETCH (API FILTER BASED)
  Future<void> fetchLorryReceipts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final from = _fromDate != null
          ? "${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}"
          : null;

      final to = _toDate != null
          ? "${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}"
          : null;

      final data = await repository.getLorryReceiptsWithFilters(
        search: _searchQuery,
        fromDate: from,
        toDate: to,
        sortOrder: _sortOrder,
        staffId: _staffId,
      );

      state = state.copyWith(
        isLoading: false,
        receipts: data,
        filteredReceipts: data,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to load lorry receipts",
      );
    }
  }

  /// 🔍 SEARCH
  void updateSearch(String query) {
    _searchQuery = query;
    fetchLorryReceipts();
  }

  /// 📅 DATE FILTER
  void updateDateRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    fetchLorryReceipts();
  }

  /// 🔽 SORT
  void updateSort(String? sortOrder) {
    _sortOrder = sortOrder;
    fetchLorryReceipts();
  }

  /// 👤 STAFF FILTER
  void updateStaff(int? staffId) {
    _staffId = staffId;
    fetchLorryReceipts();
  }

  /// 🔹 CREATE
  Future<bool> createLorryReceipt(
      CreateLorryReceiptRequest request) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        successMessage: null,
      );

      final success =
      await repository.createLorryReceipt(request);

      if (success) {
        await fetchLorryReceipts();
        state = state.copyWith(
          isLoading: false,
          successMessage: "Lorry Receipt created successfully",
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to create Lorry Receipt",
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void resetCreateState() {
    state = state.copyWith(
      isLoading: false,
      error: null,
      successMessage: null,
    );
  }

  /// 🔹 GET BY UID
  Future<Map<String, dynamic>> getLorryReceiptByUid(String uid) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final data = await repository.getLorryReceiptByUid(uid);

      state = state.copyWith(isLoading: false);
      return data;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 🔹 UPDATE
  Future<bool> updateLorryReceipt(
      String uid,
      CreateLorryReceiptRequest request,
      ) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final success =
      await repository.updateLorryReceipt(uid, request);

      if (success) {
        await fetchLorryReceipts();
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to update Lorry Receipt",
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 🔹 DELETE
  Future<bool> deleteLorryReceipt(String uid) async {
    try {
      state = state.copyWith(isLoading: true);

      final success =
      await repository.deleteLorryReceipt(uid);

      if (success) {
        await fetchLorryReceipts();
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to delete Lorry Receipt",
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 🔹 PREFILL
  Future<Map<String, dynamic>> prefillByOrderNo(String orderNo) async {
    try {
      state = state.copyWith(isLoading: true);

      final data =
      await repository.prefillByOrderNo(orderNo);

      state = state.copyWith(isLoading: false);
      return data;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to fetch prefill data",
      );
      rethrow;
    }
  }
}