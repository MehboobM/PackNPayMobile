

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_state/quatation_state.dart';
import '../api_services/network_handler.dart';
import '../models/state_data.dart';
import '../repositry/quatation_repository.dart';

final quotationProvider = StateNotifierProvider<QuotationNotifier, QuotationState>(
      (ref) => QuotationNotifier(QuatationRepository(NetworkHandler()),),
);

class QuotationNotifier extends StateNotifier<QuotationState> {
  final QuatationRepository repository;

  int currentPage = 1;
  bool isLastPage = false;

  QuotationNotifier(this.repository) : super(QuotationState());

  Future<void> fetchQuotationList({
    bool isLoadMore = false,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      if (!isLoadMore) {
        currentPage = 1;
        state = state.copyWith(isPageLoading: true);
      }

      final data = await repository.fetchQuatation(
        page: currentPage,
        fromDate: fromDate,
        toDate: toDate,
      );

      final oldList = state.quatationData?.data ?? [];

      final newList = isLoadMore
          ? [...oldList, ...?data.data]
          : data.data;

      isLastPage =
          currentPage >= (data.pagination?.totalPages ?? 1);

      currentPage++;

      state = state.copyWith(
        isPageLoading: false,
        quatationData: data..data = newList,
        filteredList: newList, // ✅ IMPORTANT (initial data)
      );
    } catch (e) {
      state = state.copyWith(
        isPageLoading: false,
        error: "Error loading data",
      );
    }
  }

  /// ✅ LOCAL SEARCH METHOD (NEW)
  void filterLocalList(String query) {
    final originalList = state.quatationData?.data ?? [];

    if (query.isEmpty) {
      state = state.copyWith(filteredList: originalList);
      return;
    }

    final lowerQuery = query.toLowerCase();

    final filtered = originalList.where((item) {
      return (item.quotationNo ?? "")
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


  Future<void> loadStates() async {
    try {
      state = state.copyWith(isPageLoading: true);

      final res = await repository.fetchStates();

      state = state.copyWith(
        isPageLoading: false,
        states: res.data ?? [],
      );
    } catch (e) {
      state = state.copyWith(
        isPageLoading: false,
        error: e.toString(),
      );
    }
  }


  Future<void> onStateSelected(States selectedState) async {
    try {
      // reset city first
      state = state.copyWith(
        selectedState: selectedState,
        selectedCity: null,
        cities: [],
      );

      final res = await repository.fetchCities(selectedState.id!);

      state = state.copyWith(
        cities: res.data ?? [],
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }
}

