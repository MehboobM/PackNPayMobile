
import 'package:pack_n_pay/models/survey_list_data.dart';

class SurveyDataState {
  final bool isPageLoading;
  final int? loadingItemId;
  final SurveyData? surveyListData;
  final List<SurveyList>? filteredList; // ✅ NEW
  final String? error;
  final String? successMessage;
  final bool isInitialLoading; // 👈 NEW

  SurveyDataState({
    this.isPageLoading = false,
    this.loadingItemId,
    this.surveyListData,
    this.filteredList,
    this.error,
    this.successMessage,
    this.isInitialLoading = true, // 👈 default true

  });

  SurveyDataState copyWith({
    bool? isPageLoading,
    int? loadingItemId,
    SurveyData? surveyListData,
    List<SurveyList>? filteredList,
    String? error,
    String? successMessage,
    bool? isInitialLoading,
  }) {
    return SurveyDataState(
      isPageLoading: isPageLoading ?? this.isPageLoading,
      loadingItemId: loadingItemId,
      surveyListData: surveyListData ?? this.surveyListData,
      filteredList: filteredList ?? this.filteredList,
      error: error,
      successMessage: successMessage,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
    );
  }
}
