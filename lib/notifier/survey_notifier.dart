
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/all_state/survey_data_state.dart';
import 'package:pack_n_pay/repositry/survey_repository.dart';
import '../api_services/network_handler.dart';

final surveyDataProvider = StateNotifierProvider<SurveyDataNotifier, SurveyDataState>(
      (ref) => SurveyDataNotifier(SurveyRepository(NetworkHandler()),),
);

class SurveyDataNotifier extends StateNotifier<SurveyDataState> {
  final SurveyRepository repository;

  int currentPage = 1;
  bool isLastPage = false;

  SurveyDataNotifier(this.repository) : super(SurveyDataState());

  Future<void> fetchSurveyList({
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

      final data = await repository.fetchSurveyList(
        page: currentPage,
        fromDate: fromDate,
        toDate: toDate,
      );

      final oldList = state.surveyListData?.data ?? [];

      final newList = isLoadMore
          ? [...oldList, ...?data.data]
          : data.data;

      isLastPage =
          currentPage >= (data.pagination?.totalPages ?? 1);

      currentPage++;
     // await Future.delayed(const Duration(milliseconds: 300));
      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false, // 👈 done loading
        surveyListData: data..data = newList,
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
    final originalList = state.surveyListData?.data ?? [];

    if (query.isEmpty) {
      state = state.copyWith(filteredList: originalList);
      return;
    }

    final lowerQuery = query.toLowerCase();

    final filtered = originalList.where((item) {
      return (item.id ?? "")
          .toLowerCase()
          .contains(lowerQuery) ||
          (item.customer ?? "")
              .toLowerCase()
              .contains(lowerQuery) ||
          (item.phone ?? "")
              .toLowerCase()
              .contains(lowerQuery);
    }).toList();

    state = state.copyWith(filteredList: filtered);
  }
}

