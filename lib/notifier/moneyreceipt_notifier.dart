import 'package:flutter/material.dart';
import '../models/moneyreceipt_list.dart';
import '../repositry/money_receipt_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyReceiptProvider =
ChangeNotifierProvider<MoneyReceiptNotifier>((ref) {
  return MoneyReceiptNotifier();
});

class MoneyReceiptNotifier extends ChangeNotifier {
  MoneyReceiptNotifier(); // 👈 ensure this

  final MoneyReceiptRepo _repo = MoneyReceiptRepo();

  List<MoneyReceiptModel> receipts = [];
  List<MoneyReceiptModel> filteredReceipts = [];

  bool isLoading = false;

  int page = 1;
  int limit = 10;
  Future<Map<String, dynamic>> getReceiptByUid(String uid) {
    return _repo.getReceiptByUid(uid);
  }

  Future<void> fetchReceipts() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _repo.getMoneyReceipts(
        page: page,
        limit: limit,
      );

      receipts = data;
      filteredReceipts = data;
    } catch (e) {
      print("Notifier Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredReceipts = receipts;
    } else {
      final q = query.toLowerCase();
      filteredReceipts = receipts.where((e) {
        return e.name.toLowerCase().contains(q) ||
            e.receiptNo.toLowerCase().contains(q) ||
            e.phone.contains(q);
      }).toList();
    }
    notifyListeners();
  }
  Future<void> deleteReceipt(String uid) async {
    try {
      await _repo.deleteReceipt(uid);

      /// 🔥 Remove from local list (instant UI update)
      receipts.removeWhere((e) => e.uid == uid);
      filteredReceipts.removeWhere((e) => e.uid == uid);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}