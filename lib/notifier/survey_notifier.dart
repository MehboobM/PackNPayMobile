
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/all_state/survey_data_state.dart';
import 'package:pack_n_pay/notifier/quotation_form_notifier.dart';
import 'package:pack_n_pay/repositry/survey_repository.dart';
import '../api_services/network_handler.dart';
import '../models/quatation_form_model.dart';

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
          sortOrder: sort, // ✅ SAVE SORT HERE
        );
      }

      final data = await repository.fetchSurveyList(
        page: currentPage,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
        sort: sort,
      );

      final oldList = state.surveyListData?.data ?? [];

      final newList = isLoadMore
          ? [...oldList, ...?data.data]
          : data.data;

      isLastPage = currentPage >= (data.pagination?.totalPages ?? 1);

      currentPage++;

      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false,
        surveyListData: data..data = newList,
        filteredList: newList,
      );
    } catch (e) {
      print("the survey error in  $e");
      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false,
        error: "Error loading data",
      );
    }
  }


  void clearSort() {
    currentPage = 1;

    state = state.copyWith(
      clearSort: true, // ✅ this removes sortOrder
      isPageLoading: true,
      isInitialLoading: true,
    );

    fetchSurveyList(); // ✅ fresh API call
  }

  // Future<void> fetchSurveyList({
  //   bool isLoadMore = false,
  //   String? fromDate,
  //   String? toDate,
  //   String? status, // ✅ ADD THIS
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
  //     final data = await repository.fetchSurveyList(
  //       page: currentPage,
  //       fromDate: fromDate,
  //       toDate: toDate,
  //       status: status,
  //       sort: sort,
  //
  //
  //     );
  //
  //     final oldList = state.surveyListData?.data ?? [];
  //
  //     final newList = isLoadMore
  //         ? [...oldList, ...?data.data]
  //         : data.data;
  //
  //     isLastPage =
  //         currentPage >= (data.pagination?.totalPages ?? 1);
  //
  //     currentPage++;
  //    // await Future.delayed(const Duration(milliseconds: 300));
  //     state = state.copyWith(
  //       isPageLoading: false,
  //       isInitialLoading: false, // 👈 done loading
  //       surveyListData: data..data = newList,
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


  Future<void> fetchSurveyAndFillForm(
      String surveyId, WidgetRef ref) async {
    try {
      state = state.copyWith(isPageLoading: true);

      final data = await repository.fetchSurveyById(surveyId);
      /// ✅ MAP API → MODEL
      final model = QuotationFormModel(
        /// STEP 1
        quotationNo: data["survey_no"],
        companyName: data["company_name"],
        partyName: data["customer_name"],
        phone: data["phone"],
        quotationDate: data["survey_date"],

        /// 🔥 IMPORTANT FIX (your case)
        deliveryDate: data["delivery_address"]?["moving_date"],

        /// STEP 2 (Pickup)
        pickupPhone: data["pickup_address"]?["phone"],
        pickupEmail: data["pickup_address"]?["email"],
        pickupPincode: data["pickup_address"]?["pincode"],
        pickupStateCode: data["pickup_address"]?["state"],
        pickupCityName: data["pickup_address"]?["city"],
        pickupLiftAvailable: data["pickup_address"]?["lift_available"],

        /// STEP 2 (Delivery)
        deliveryPhone: data["delivery_address"]?["phone"],
        deliveryEmail: data["delivery_address"]?["email"],
        deliveryPincode: data["delivery_address"]?["pincode"],
        deliveryStateId: data["delivery_address"]?["state"],
        deliveryCityId: data["delivery_address"]?["city"],
        deliveryLiftAvailable: data["delivery_address"]?["lift_available"],

        /// Moving path
        movingPath:
        "${data["moving_from"]} - ${data["moving_to"]}",
      );

      /// ✅ SET INTO FORM PROVIDER
      ref.read(quotationFormProvider.notifier).state = model;
      /// ✅ OPTIONAL: SAVE TO HIVE
     // await HiveService.saveForm(model);
      state = state.copyWith(isPageLoading: false);
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      print("ERROR 👉 $e");

      throw Exception("Failed to load survey"); // ✅ IMPORTANT
    }
  }

  Future<String?> getSurveyShareLink() async {
    final encoded = await repository.generateSurveyLink();
    print("objectencoded   ${encoded}");
    if (encoded == null) return null;


    return "https://packnpay.in/survey/form?d=$encoded";
  }

}

