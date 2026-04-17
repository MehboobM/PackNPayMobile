

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_state/order_state.dart';
import '../api_services/network_handler.dart';
import '../repositry/order_repository.dart';

final orderDataProvider = StateNotifierProvider<SurveyDataNotifier, OrderDataState>(
      (ref) => SurveyDataNotifier(OrderRepository(NetworkHandler()),),
);

class SurveyDataNotifier extends StateNotifier<OrderDataState> {
  final OrderRepository repository;

  int currentPage = 1;
  bool isLastPage = false;

  SurveyDataNotifier(this.repository) : super(OrderDataState());

  Future<void> fetchOrderList({
    bool isLoadMore = false,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      if (!isLoadMore) {
        currentPage = 1;

        state = state.copyWith(
          isPageLoading: true,
          isInitialLoading: true, // 👈 important
          error: null,
        );
      }

      final data = await repository.fetchOrderList(
        page: currentPage,
        fromDate: fromDate,
        toDate: toDate,
      );

      final oldList = state.orderData?.orderList ?? [];

      final newList = isLoadMore ? [...oldList, ...?data.orderList] : data.orderList;

      isLastPage = currentPage >= (data.pagination?.totalPages ?? 1);

      currentPage++;
      // await Future.delayed(const Duration(milliseconds: 300));
      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false, // 👈 done loading
        orderData: data..orderList = newList,
        filteredList: newList,
      );
    } catch (e) {
      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false,
        error: "Error loading data",
      );
    }
  }
  /// ✅ LOCAL SEARCH METHOD (NEW)
  void filterLocalList(String query) {
    final originalList = state.orderData?.orderList ?? [];

    if (query.isEmpty) {
      state = state.copyWith(filteredList: originalList);
      return;
    }

    final lowerQuery = query.toLowerCase();

    final filtered = originalList.where((item) {
      return (item.orderNo ?? "")
          .toLowerCase()
          .contains(lowerQuery) ||
          (item.customerName ?? "")
              .toLowerCase()
              .contains(lowerQuery) ||
          (item.phone ?? "")
              .toLowerCase()
              .contains(lowerQuery);
    }).toList();

    state = state.copyWith(filteredList: filtered);
  }




}