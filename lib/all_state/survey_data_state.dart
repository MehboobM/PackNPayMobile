
import 'package:pack_n_pay/models/survey_list_data.dart';

class SurveyDataState {
  final bool isPageLoading;
  final int? loadingItemId;
  final SurveyData? surveyListData;
  final List<SurveyList>? filteredList;
  final String? error;
  final String? successMessage;
  final bool isInitialLoading;

  final String? sortOrder; // ✅ ADD THIS

  SurveyDataState({
    this.isPageLoading = false,
    this.loadingItemId,
    this.surveyListData,
    this.filteredList,
    this.error,
    this.successMessage,
    this.isInitialLoading = true,
    this.sortOrder, // ✅ ADD
  });

  SurveyDataState copyWith({
    bool? isPageLoading,
    int? loadingItemId,
    SurveyData? surveyListData,
    List<SurveyList>? filteredList,
    String? error,
    String? successMessage,
    bool? isInitialLoading,
    String? sortOrder, // ✅ ADD
    bool clearSort = false, // ✅ ADD FLAG
  }) {
    return SurveyDataState(
      isPageLoading: isPageLoading ?? this.isPageLoading,
      loadingItemId: loadingItemId,
      surveyListData: surveyListData ?? this.surveyListData,
      filteredList: filteredList ?? this.filteredList,
      error: error,
      successMessage: successMessage,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      sortOrder: clearSort ? null : (sortOrder ?? this.sortOrder),
    );
  }

}