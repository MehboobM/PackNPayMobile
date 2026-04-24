import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../all_state/Money_recepitformstate.dart';
import '../repositry/money_receipt_repository.dart';

final moneyReceiptFormProvider = StateNotifierProvider<
    MoneyReceiptFormNotifier, MoneyReceiptFormState>((ref) {
  return MoneyReceiptFormNotifier();
});

class MoneyReceiptFormNotifier extends StateNotifier<MoneyReceiptFormState> {
  MoneyReceiptFormNotifier()
      : super(const MoneyReceiptFormState());

  final MoneyReceiptRepo _repo = MoneyReceiptRepo();

  Future<void> loadReceipt(String uid) async {
    state = state.copyWith(isLoading: true);

    try {
      final data = await _repo.getReceiptByUid(uid);

      state = state.copyWith(
        isLoading: false,
        isEdit: true,
        data: data,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> saveReceipt({
    required Map<String, dynamic> body,
    String? uid,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      if (uid != null && uid.isNotEmpty) {
        await _repo.updateReceipt(uid, body);
      } else {
        await _repo.createReceipt(body);
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  void clear() {
    state = const MoneyReceiptFormState();
  }
}