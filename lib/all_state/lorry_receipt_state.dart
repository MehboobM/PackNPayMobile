import '../models/lorry_receipt.dart';

class LorryReceiptState {
  final bool isLoading;
  final bool isInitialLoading;
  final String? error;
  final String? successMessage;
  final List<LorryReceiptModel> receipts;
  final List<LorryReceiptModel> filteredReceipts;

  const LorryReceiptState({
    this.isLoading = false,
    this.isInitialLoading = false,
    this.error,
    this.successMessage,
    this.receipts = const [],
    this.filteredReceipts = const [],
  });

  LorryReceiptState copyWith({
    bool? isLoading,
    bool? isInitialLoading,
    String? error,
    String? successMessage,
    List<LorryReceiptModel>? receipts,
    List<LorryReceiptModel>? filteredReceipts,
  }) {
    return LorryReceiptState(
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      error: error,
      successMessage: successMessage,
      receipts: receipts ?? this.receipts,
      filteredReceipts:
      filteredReceipts ?? this.filteredReceipts,
    );
  }

  factory LorryReceiptState.initial() {
    return const LorryReceiptState();
  }
}