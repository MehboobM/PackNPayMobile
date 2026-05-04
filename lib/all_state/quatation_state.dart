


import 'package:pack_n_pay/models/quatation_list_data.dart';

import '../models/city_data.dart';
import '../models/state_data.dart';

class QuotationState {
  final bool isPageLoading;
  final int? loadingItemId;
  final QuotationListData? quatationData;
  final List<QuotationList>? filteredList; // ✅ NEW
  final String? error;
  final String? successMessage;

  final List<States>? states;
  final List<Cities>? cities;

  final States? selectedState;
  final Cities? selectedCity;
  final bool isInitialLoading;
  final String? sortOrder; // ✅ ADD THIS


  QuotationState({

    this.states,
    this.cities,
    this.selectedState,
    this.selectedCity,
    this.isPageLoading = false,
    this.loadingItemId,
    this.quatationData,
    this.filteredList,
    this.error,
    this.successMessage,
    this.isInitialLoading = true,
    this.sortOrder,
  });

  QuotationState copyWith({
    bool? isPageLoading,
    int? loadingItemId,
    QuotationListData? quatationData,
    List<QuotationList>? filteredList, // ✅ NEW
    String? error,
    String? successMessage,

    List<States>? states,
    List<Cities>? cities,
    States? selectedState,
    Cities? selectedCity,

    bool? isInitialLoading,
    String? sortOrder, // ✅ ADD
    bool clearSort = false, // ✅ ADD FLAG
  }) {
    return QuotationState(
      isPageLoading: isPageLoading ?? this.isPageLoading,
      loadingItemId: loadingItemId,
      quatationData: quatationData ?? this.quatationData,
      filteredList: filteredList ?? this.filteredList,
      error: error,
      successMessage: successMessage,
      states: states ?? this.states,
      cities: cities ?? this.cities,
      selectedState: selectedState ?? this.selectedState,
      selectedCity: selectedCity ?? this.selectedCity,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      sortOrder: clearSort ? null : (sortOrder ?? this.sortOrder),
    );
  }
}
