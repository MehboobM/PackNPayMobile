import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/notifier/quotation_form_notifier.dart';

import '../all_state/quatation_state.dart';
import '../api_services/network_handler.dart';
import '../database/shared_preferences/shared_storage.dart';
import '../models/quatation_form_model.dart';
import '../models/state_data.dart';
import '../repositry/quatation_repository.dart';

final quotationProvider = StateNotifierProvider<QuotationNotifier, QuotationState>(
      (ref) => QuotationNotifier(QuatationRepository(NetworkHandler())),
);

class QuotationNotifier extends StateNotifier<QuotationState> {
  final QuatationRepository repository;

  int currentPage = 1;
  bool isLastPage = false;

  QuotationNotifier(this.repository) : super(QuotationState());

  void clearSort() {
    currentPage = 1;
    state = state.copyWith(
      clearSort: true,
      isPageLoading: true,
      isInitialLoading: true,
    );
    fetchQuotationList();
  }

  Future<void> fetchQuotationList({
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
          sortOrder: sort,
        );
      }

      final data = await repository.fetchQuatation(
        page: currentPage,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
        sort: sort,
      );

      final oldList = state.quatationData?.data ?? [];
      final newList = isLoadMore ? [...oldList, ...?data.data] : data.data;

      isLastPage = currentPage >= (data.pagination?.totalPages ?? 1);
      currentPage++;

      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false,
        quatationData: data..data = newList,
        filteredList: newList,
      );
    } catch (e) {
      debugPrint("Quotation error: $e");
      state = state.copyWith(
        isPageLoading: false,
        isInitialLoading: false,
        error: "Error loading data",
      );
    }
  }

  void filterLocalList(String query) {
    final originalList = state.quatationData?.data ?? [];
    if (query.isEmpty) {
      state = state.copyWith(filteredList: originalList);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = originalList.where((item) {
      return (item.quotationNo ?? "").toLowerCase().contains(lowerQuery) ||
          (item.customerName ?? "").toLowerCase().contains(lowerQuery) ||
          (item.phone ?? "").toLowerCase().contains(lowerQuery);
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

  Future<Map<String, dynamic>> createQuotation(QuotationFormModel model) async {
    try {
      state = state.copyWith(isPageLoading: true);
      final payload = await _buildPayload(model);
      final res = await repository.createQuotation(payload);
      state = state.copyWith(isPageLoading: false);
      return res;
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      rethrow;
    }
  }

  /// ✅ UPDATED PAYLOAD BUILDER WITH TYPE SAFETY
  Future<Map<String, dynamic>> _buildPayload(QuotationFormModel m) async {
    final companyId = await StorageService().getCompanyId();
    final userName = await StorageService().getUserName();

    return {
      "company_id": companyId?.toString(), // Ensure String
      "customer_name": userName?.toString(),
      "phone": m.phone?.toString(),
      "email": m.email?.toString(),
      "company_or_party_name": m.companyName?.toString(),
      "party_name": m.partyName?.toString(),
      "gst_no": m.gstNo?.toString(),

      "quotation_date": formatToApiDate(m.quotationDate),
      "packing_date": formatToApiDate(m.packingDate),
      "delivery_date": formatToApiDate(m.deliveryDate),

      "moving_from": m.pickupCityName?.toString(),
      "moving_to": m.deliveryCityName?.toString(),

      "vehicle_type": m.vehicleType?.toString(),
      "load_type": m.loadType?.toString(),
      "moving_path": m.movingPath?.toString(),

      "remarks": m.specialNeeds?.toString(),

      /// INSURANCE
      "insurance_type": m.insuranceType?.toString(),
      "insurance_charge": m.insurancePercent?.toString(),
      "insurance_gst": m.insuranceGst?.toString(),
      "declaration_of_goods": m.goodsDeclaration?.toString(),

      "vehicle_insurance_type": m.vehicleInsuranceType?.toString(),
      "vehicle_insurance_charge": m.vehicleInsurancePercent?.toString(),
      "vehicle_insurance_gst": m.vehicleInsuranceGst?.toString(),
      "declaration_of_vehicle": m.vehicleDeclaration?.toString(),

      /// OTHER
      "easy_access": m.easyAccess?.toString(),
      "balcony_items": m.balconyRemarks?.toString(),
      "loading_restrictions": m.restriction?.toString(),
      "unloading_restrictions": m.restriction?.toString(),
      "special_needs": m.specialNeeds?.toString(),

      /// PAYMENT - All charges forced to String
      "freight_charge": m.freightCharge?.toString(),
      "packing_charge": m.packingCharge?.toString(),
      "packing_charge_type": m.packingChargeType?.toString(),
      "unpacking_charge": m.unpackingCharge?.toString(),
      "unpacking_charge_type": m.unpackingChargeType?.toString(),
      "loading_charge": m.loadingCharge?.toString(),
      "loading_charge_type": m.loadingChargeType?.toString(),
      "unloading_charge": m.unloadingCharge?.toString(),
      "unloading_charge_type": m.unloadingChargeType?.toString(),
      "packing_material_charge": m.packingMaterialCharge?.toString(),
      "packing_material_charge_type": m.packingMaterialChargeType?.toString(),
      "total_amount": m.totalAmount?.toString(),

      "gst_amount": "0", // Force string
      "discount": "0",   // Force string

      "storage_charge": m.storageCharge?.toString(),
      "car_bike_tpt": m.tptCharge?.toString(),
      "misc_charge": m.miscCharge?.toString(),
      "other_charges": m.otherCharges?.toString(),
      "st_charge": m.stCharges?.toString(),

      "surcharge": m.surchargeAmount?.toString(),
      "surcharge_type": m.surchargeType?.toString(),

      /// GST
      "show_gst": "YES",
      "gst_type": m.gstType?.toString(),
      "gst_percent": m.gstPercent?.toString(),

      /// PICKUP
      "pickup_address": {
        "email": m.pickupEmail?.toString(),
        "phone": m.pickupPhone?.toString(),
        "state": m.pickupStateId?.toString(), // Force String
        "city": m.pickupCityId?.toString(),   // Force String
        "pincode": m.pickupPincode?.toString(),
        "lift_available": m.pickupLiftAvailable?.toString(),
        "moving_date": formatToApiDate(m.packingDate),
      },

      /// DELIVERY
      "delivery_address": {
        "email": m.deliveryEmail?.toString(),
        "phone": m.deliveryPhone?.toString(),
        "state": m.deliveryStateId?.toString(), // Force String
        "city": m.deliveryCityId?.toString(),   // Force String
        "pincode": m.deliveryPincode?.toString(),
        "lift_available": m.deliveryLiftAvailable?.toString(),
        "moving_date": formatToApiDate(m.deliveryDate),
      },
    };
  }

  String formatToApiDate(String? date) {
    if (date == null || date.isEmpty) return "";
    final parts = date.split('/');
    if (parts.length != 3) return date;
    return "${parts[2]}-${parts[1]}-${parts[0]}"; // yyyy-mm-dd
  }

  Future<bool> deleteQuotation(String quotationNo) async {
    try {
      state = state.copyWith(isPageLoading: true);
      final success = await repository.deleteQuotation(quotationNo);
      state = state.copyWith(isPageLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      return false;
    }
  }

  Future<void> fetchQuotationAndFillForm(String uid, WidgetRef ref) async {
    try {
      state = state.copyWith(isPageLoading: true);
      final data = await repository.fetchQuotationByUid(uid);

      final model = QuotationFormModel(
        quotationNo: data["quotation_no"]?.toString(),
        companyName: data["company_or_party_name"]?.toString(),
        partyName: data["party_name"]?.toString(),
        phone: data["phone"]?.toString(),
        email: data["email"]?.toString(),
        gstNo: data["gst_no"]?.toString(),
        shiftingDate: _formatDate(data["pickup_address"]?["moving_date"]),
        quotationDate: _formatDate(data["quotation_date"]),
        packingDate: _formatDate(data["packing_date"]),
        deliveryDate: _formatDate(data["delivery_address"]?["moving_date"]),
        movingFrom: data["moving_from"]?.toString(),
        movingTo: data["moving_to"]?.toString(),
        pickupCityName: data["moving_from"]?.toString(),
        deliveryCityName: data["moving_to"]?.toString(),
        vehicleType: data["vehicle_type"]?.toString(),
        loadType: data["load_type"]?.toString(),
        movingPath: data["moving_path"]?.toString(),
        pickupPhone: data["pickup_address"]?["phone"]?.toString(),
        pickupEmail: data["pickup_address"]?["email"]?.toString(),
        pickupPincode: data["pickup_address"]?["pincode"]?.toString(),
        pickupStateId: data["pickup_address"]?["state"]?.toString(),
        pickupCityId: data["pickup_address"]?["city"]?.toString(),
        pickupLiftAvailable: data["pickup_address"]?["lift_available"]?.toString(),
        deliveryPhone: data["delivery_address"]?["phone"]?.toString(),
        deliveryEmail: data["delivery_address"]?["email"]?.toString(),
        deliveryPincode: data["delivery_address"]?["pincode"]?.toString(),
        deliveryStateId: data["delivery_address"]?["state"]?.toString(),
        deliveryCityId: data["delivery_address"]?["city"]?.toString(),
        deliveryLiftAvailable: data["delivery_address"]?["lift_available"]?.toString(),
        freightCharge: data["freight_charge"]?.toString(),
        packingCharge: data["packing_charge"]?.toString(),
        unpackingCharge: data["unpacking_charge"]?.toString(),
        loadingCharge: data["loading_charge"]?.toString(),
        unloadingCharge: data["unloading_charge"]?.toString(),
        packingMaterialCharge: data["packing_material_charge"]?.toString(),
        storageCharge: data["storage_charge"]?.toString(),
        tptCharge: data["car_bike_tpt"]?.toString(),
        miscCharge: data["misc_charge"]?.toString(),
        otherCharges: data["other_charges"]?.toString(),
        stCharges: data["st_charge"]?.toString(),
        surchargeAmount: data["surcharge"]?.toString(),
        surchargeType: data["surcharge_type"]?.toString(),
        packingChargeType: data["packing_charge_type"]?.toString(),
        unpackingChargeType: data["unpacking_charge_type"]?.toString(),
        loadingChargeType: data["loading_charge_type"]?.toString(),
        unloadingChargeType: data["unloading_charge_type"]?.toString(),
        packingMaterialChargeType: data["packing_material_charge_type"]?.toString(),
        gstType: data["gst_type"]?.toString(),
        gstPercent: data["gst_percent"]?.toString(),
        insuranceType: data["insurance_type"]?.toString(),
        insurancePercent: data["insurance_charge"]?.toString(),
        insuranceGst: data["insurance_gst"]?.toString(),
        vehicleInsuranceType: data["vehicle_insurance_type"]?.toString(),
        vehicleInsurancePercent: data["vehicle_insurance_charge"]?.toString(),
        vehicleInsuranceGst: data["vehicle_insurance_gst"]?.toString(),
        goodsDeclaration: data["declaration_of_goods"]?.toString(),
        vehicleDeclaration: data["declaration_of_vehicle"]?.toString(),
        easyAccess: data["easy_access"]?.toString(),
        balconyRemarks: data["balcony_items"]?.toString(),
        restriction: data["loading_restrictions"]?.toString(),
        specialNeeds: data["special_needs"]?.toString(),
      );

      ref.read(quotationFormProvider.notifier).state = model;
      state = state.copyWith(isPageLoading: false);
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      throw Exception("Failed to load quotation: $e");
    }
  }

  String _formatDate(String? date) {
    if (date == null) return "";
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return "";
    return "${parsed.day.toString().padLeft(2, '0')}/"
        "${parsed.month.toString().padLeft(2, '0')}/"
        "${parsed.year}";
  }

  Future<bool> updateQuotation(String uid, QuotationFormModel model, String? keyType) async {
    try {
      state = state.copyWith(isPageLoading: true);
      final payload = await _buildPayload(model);
      final success = await repository.updateQuotation(uid, payload, keyType);
      state = state.copyWith(isPageLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      return false;
    }
  }
}
