

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


  void clearSort() {
    currentPage = 1;

    state = state.copyWith(
      clearSort: true, // ✅ this removes sortOrder
      isPageLoading: true,
      isInitialLoading: true,
    );

    fetchOrderList(); // ✅ fresh API call
  }

  Future<void> fetchOrderList({
    bool isLoadMore = false,
    String? fromDate,
    String? toDate,
    String? status,
    String? sort,
  }) async {
    try {
      if (!isLoadMore) {
        currentPage = 1;

        state = state.copyWith(
          isPageLoading: true,
          isInitialLoading: true,
          error: null,
          sortOrder: sort, // ✅ SAVE SORT
        );
      }

      final data = await repository.fetchOrderList(
        page: currentPage,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
        sort: sort,
      );

      final oldList = state.orderData?.orderList ?? [];

      final newList = isLoadMore
          ? [...oldList, ...?data.orderList]
          : data.orderList;

      isLastPage = currentPage >= (data.pagination?.totalPages ?? 1);

      currentPage++;

      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false,
        orderData: data..orderList = newList,
        filteredList: newList,
      );
    } catch (e) {
      print("Order list error: $e");

      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false,
        error: "Error loading data",
      );
    }
  }

  // Future<void> fetchOrderList({
  //   bool isLoadMore = false,
  //   String? fromDate,
  //   String? toDate,
  //   String? status,
  //   String? sort,
  // }) async {
  //   try {
  //     if (!isLoadMore) {
  //       currentPage = 1;
  //
  //       state = state.copyWith(
  //         isPageLoading: true,
  //         isInitialLoading: true, // 👈 important
  //         error: null,
  //       );
  //     }
  //
  //     final data = await repository.fetchOrderList(
  //       page: currentPage,
  //       fromDate: fromDate,
  //       toDate: toDate,
  //       status: status,
  //       sort: sort,
  //     );
  //
  //     final oldList = state.orderData?.orderList ?? [];
  //
  //     final newList = isLoadMore ? [...oldList, ...?data.orderList] : data.orderList;
  //
  //     isLastPage = currentPage >= (data.pagination?.totalPages ?? 1);
  //
  //     currentPage++;
  //     // await Future.delayed(const Duration(milliseconds: 300));
  //     state = state.copyWith(
  //       isPageLoading: false,
  //       isInitialLoading: false, // 👈 done loading
  //       orderData: data..orderList = newList,
  //       filteredList: newList,
  //     );
  //   } catch (e) {
  //     state = state.copyWith(
  //       isPageLoading: false,
  //       isInitialLoading: false,
  //       error: "Error loading data",
  //     );
  //   }
  // }
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



  Future<bool> deleteOrder(String quotationNo) async {
    try {
      state = state.copyWith(isPageLoading: true);
      final success = await repository.deleteOrder(quotationNo);

      if (success) {
        state = state.copyWith(isPageLoading: false);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


}