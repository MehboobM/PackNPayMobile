
import '../models/order_model.dart';

class OrderDataState {
  final bool isPageLoading;
  final int? loadingItemId;
  final OrderData? orderData;
  final List<OrderDataList>? filteredList; // ✅ NEW
  final String? error;
  final String? successMessage;
  final bool isInitialLoading; // 👈 NEW
  final String? sortOrder; // ✅ ADD THIS

  OrderDataState({
    this.isPageLoading = false,
    this.loadingItemId,
    this.orderData,
    this.filteredList,
    this.error,
    this.successMessage,
    this.isInitialLoading = true, // 👈 default true
    this.sortOrder

  });

  OrderDataState copyWith({
    bool? isPageLoading,
    int? loadingItemId,
    OrderData? orderData,
    List<OrderDataList>? filteredList,
    String? error,
    String? successMessage,
    bool? isInitialLoading,
    String? sortOrder, // ✅ ADD
    bool clearSort = false, // ✅ ADD FLAG
  }) {
    return OrderDataState(
      isPageLoading: isPageLoading ?? this.isPageLoading,
      loadingItemId: loadingItemId,
      orderData: orderData ?? this.orderData,
      filteredList: filteredList ?? this.filteredList,
      error: error,
      successMessage: successMessage,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      sortOrder: clearSort ? null : (sortOrder ?? this.sortOrder),
    );
  }
}
