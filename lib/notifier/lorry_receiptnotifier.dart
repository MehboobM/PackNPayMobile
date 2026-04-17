import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../all_state/lorry_receipt_state.dart';
import '../api_services/network_handler.dart';
import '../models/create_lorry_receipt.dart';
import '../models/lorry_receipt.dart';
import '../repositry/lorry_receipt_repository.dart';

final lorryReceiptProvider =
StateNotifierProvider<LorryReceiptNotifier, LorryReceiptState>(
      (ref) => LorryReceiptNotifier(
    LorryReceiptRepository(NetworkHandler()),
  ),
);

class LorryReceiptNotifier extends StateNotifier<LorryReceiptState> {
  final LorryReceiptRepository repository;

  String _searchQuery = '';
  DateTime? _fromDate;
  DateTime? _toDate;

  LorryReceiptNotifier(this.repository)
      : super(const LorryReceiptState()) {
    fetchLorryReceipts();
  }

  /// 🔹 Fetch Lorry Receipts
  Future<void> fetchLorryReceipts() async {
    try {
      state = state.copyWith(
        isLoading: true,
        isInitialLoading: true,
        error: null,
      );

      final data = await repository.getLorryReceipts();

      state = state.copyWith(
        isLoading: false,
        isInitialLoading: false,
        receipts: data,
        filteredReceipts: data,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isInitialLoading: false,
        error: "Failed to load lorry receipts",
      );
    }
  }

  /// 🔍 Search Filter
  void updateSearch(String query) {
    _searchQuery = query.trim().toLowerCase();
    applyFilters();
  }

  /// 📅 Date Filter
  void updateDateRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    applyFilters();
  }

  /// 🔹 Apply Filters
  /// 🔹 Apply Filters (Search + Date)
  void applyFilters() {
    final filtered = state.receipts.where((receipt) {
      final query = _searchQuery.trim().toLowerCase();

      // Fields to search
      final name = receipt.customerName.toLowerCase();
      final lrNo = receipt.lrNo.toLowerCase();
      final phone = receipt.phone.toLowerCase();
      final vehicleNo = receipt.vehicleNo.toLowerCase();

      /// 🔍 Search Condition
      bool matchesSearch = query.isEmpty ||
          name.contains(query) ||
          lrNo.contains(query) ||
          phone.contains(query) ||
          vehicleNo.contains(query);

      /// 📅 Date Filter Condition
      bool matchesDate = true;
      if (_fromDate != null && _toDate != null) {
        final date = DateTime.tryParse(receipt.lrDate);
        if (date != null) {
          matchesDate =
              date.isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
                  date.isBefore(_toDate!.add(const Duration(days: 1)));
        }
      }

      return matchesSearch && matchesDate;
    }).toList();

    state = state.copyWith(filteredReceipts: filtered);
  }
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
        state = state.copyWith(
          isLoading: false,
          successMessage: "Lorry Receipt created successfully",
        );

        await fetchLorryReceipts(); // Refresh list
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
  /// 🔹 Get LR by UID
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

  /// 🔹 Update LR
  Future<bool> updateLorryReceipt(
      String uid,
      CreateLorryReceiptRequest request,
      ) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        successMessage: null,
      );

      final success =
      await repository.updateLorryReceipt(uid, request);

      if (success) {
        state = state.copyWith(
          isLoading: false,
          successMessage: "Lorry Receipt updated successfully",
        );

        await fetchLorryReceipts();
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

  /// 🔹 Delete LR
  Future<bool> deleteLorryReceipt(String uid) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

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
  // lorry_receiptnotifier.dart

  Future<Map<String, dynamic>> prefillByOrderNo(String orderNo) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

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