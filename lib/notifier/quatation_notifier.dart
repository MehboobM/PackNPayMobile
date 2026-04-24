

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/notifier/quotation_form_notifier.dart';

import '../all_state/quatation_state.dart';
import '../api_services/network_handler.dart';
import '../database/shared_preferences/shared_storage.dart';
import '../models/quatation_form_model.dart';
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

  Future<Map<String, dynamic>> createQuotation(QuotationFormModel model) async {
    try {
      state = state.copyWith(isPageLoading: true);

      final payload = await _buildPayload(model);

      final res = await repository.createQuotation(payload);

      state = state.copyWith(isPageLoading: false);

      return res; // ✅ IMPORTANT

    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      throw Exception("Create quotation failed");
    }
  }
  Future<Map<String, dynamic>> _buildPayload(QuotationFormModel m) async {
    final companyId = await StorageService().getCompanyId();
    final userName = await StorageService().getUserName();
    int companyIdInt = int.parse(companyId ?? "-1");

    print("id is $companyIdInt>>>>>>>>>>$userName");
    return {
      "company_id": companyId,
      "customer_name": userName,
      "phone": m.phone,
      "email": m.email,
      "company_or_party_name": m.companyName,
      "party_name": m.partyName,
      "gst_no": m.gstNo,



      "quotation_date": formatToApiDate(m.quotationDate),
      "packing_date": formatToApiDate(m.packingDate),
      "delivery_date": formatToApiDate(m.deliveryDate),

      "moving_from": m.pickupCityName,
      "moving_to": m.deliveryCityName,

      "vehicle_type": m.vehicleType,
      "load_type": m.loadType,
      "moving_path": m.movingPath,

      "remarks": m.specialNeeds,

      /// INSURANCE
      "insurance_type": m.insuranceType,
      "insurance_charge": m.insurancePercent,
      "insurance_gst": m.insuranceGst,
      "declaration_of_goods": m.goodsDeclaration,

      "vehicle_insurance_type": m.vehicleInsuranceType,
      "vehicle_insurance_charge": m.vehicleInsurancePercent,
      "vehicle_insurance_gst": m.vehicleInsuranceGst,
      "declaration_of_vehicle": m.vehicleDeclaration,

      /// OTHER
      "easy_access": m.easyAccess,
      "balcony_items": m.balconyRemarks,
      "loading_restrictions": m.restriction,
      "unloading_restrictions": m.restriction,
      "special_needs": m.specialNeeds,

      /// PAYMENT
      "freight_charge": m.freightCharge,
      "packing_charge": m.packingCharge,
      "packing_charge_type": m.packingChargeType,
      "unpacking_charge": m.unpackingCharge,
      "unpacking_charge_type": m.unpackingChargeType,
      "loading_charge": m.loadingCharge,
      "loading_charge_type": m.loadingChargeType,
      "unloading_charge": m.unloadingCharge,
      "unloading_charge_type": m.unloadingChargeType,
      "packing_material_charge": m.packingMaterialCharge,
      "packing_material_charge_type": m.packingMaterialChargeType,
      "total_amount": m.totalAmount,
      /// TODO (optional calc)
      "gst_amount": 0,
      "discount": 0,


      "storage_charge": m.storageCharge,
      "car_bike_tpt": m.tptCharge,
      "misc_charge": m.miscCharge,
      "other_charges": m.otherCharges,
      "st_charge": m.stCharges,

      "surcharge": m.surchargeAmount,
      "surcharge_type": m.surchargeType,

      /// GST
      "show_gst": "YES",
      "gst_type": m.gstType,
      "gst_percent": m.gstPercent,


      /// PICKUP
      "pickup_address": {
        "email": m.pickupEmail,
        "phone": m.pickupPhone,
        "state": m.pickupStateId,
        "city": m.pickupCityId,
        "pincode": m.pickupPincode,
        "lift_available": m.pickupLiftAvailable,
        "moving_date":formatToApiDate(m.packingDate),// m.packingDate,
      },

      /// DELIVERY
      "delivery_address": {
        "email": m.deliveryEmail,
        "phone": m.deliveryPhone,
        "state": m.deliveryStateId,
        "city": m.deliveryCityId,
        "pincode": m.deliveryPincode,
        "lift_available": m.deliveryLiftAvailable,
        "moving_date": formatToApiDate(m.deliveryDate),//m.deliveryDate,
      },
    };
  }


  String formatToApiDate(String? date) {
    if (date == null || date.isEmpty) return "";

    final parts = date.split('/'); // [dd, mm, yyyy]

    if (parts.length != 3) return date;

    return "${parts[2]}-${parts[1]}-${parts[0]}"; // yyyy-mm-dd
  }


  Future<bool> deleteQuotation(String quotationNo) async {
    try {
      state = state.copyWith(isPageLoading: true);
      final success = await repository.deleteQuotation(quotationNo);

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

  Future<void> fetchQuotationAndFillForm(
      String uid, WidgetRef ref) async {
    try {
      state = state.copyWith(isPageLoading: true);

      final data = await repository.fetchQuotationByUid(uid);

      final model = QuotationFormModel(
        /// STEP 1
        quotationNo: data["quotation_no"],
        companyName: data["company_or_party_name"],
        partyName: data["party_name"],
        phone: data["phone"],
        email: data["email"],
        gstNo: data["gst_no"],

        shiftingDate: _formatDate(data["pickup_address"]?["moving_date"]),
        quotationDate: _formatDate(data["quotation_date"]),
        packingDate: _formatDate(data["packing_date"]),
        deliveryDate: _formatDate(data["delivery_address"]?["moving_date"]), // ✅ FIX

        /// LOCATION
        movingFrom: data["moving_from"],
        movingTo: data["moving_to"],
        pickupCityName: data["moving_from"],
        deliveryCityName: data["moving_to"],

        vehicleType: data["vehicle_type"],
        loadType: data["load_type"],
        movingPath: data["moving_path"],

        /// PICKUP
        pickupPhone: data["pickup_address"]?["phone"],
        pickupEmail: data["pickup_address"]?["email"],
        pickupPincode: data["pickup_address"]?["pincode"],
        pickupStateId: data["pickup_address"]?["state"]?.toString(),
        pickupCityId: data["pickup_address"]?["city"]?.toString(),
        pickupLiftAvailable: data["pickup_address"]?["lift_available"],

        /// DELIVERY
        deliveryPhone: data["delivery_address"]?["phone"],
        deliveryEmail: data["delivery_address"]?["email"],
        deliveryPincode: data["delivery_address"]?["pincode"],
        deliveryStateId: data["delivery_address"]?["state"]?.toString(),
        deliveryCityId: data["delivery_address"]?["city"]?.toString(),
        deliveryLiftAvailable: data["delivery_address"]?["lift_available"],

        /// CHARGES
        freightCharge: data["freight_charge"],
        packingCharge: data["packing_charge"],
        unpackingCharge: data["unpacking_charge"],
        loadingCharge: data["loading_charge"],
        unloadingCharge: data["unloading_charge"],
        packingMaterialCharge: data["packing_material_charge"],

        storageCharge: data["storage_charge"],
        tptCharge: data["car_bike_tpt"],
        miscCharge: data["misc_charge"],
        otherCharges: data["other_charges"],
        stCharges: data["st_charge"],

        surchargeAmount: data["surcharge"],
        surchargeType: data["surcharge_type"],

        /// TYPES
        packingChargeType: data["packing_charge_type"],
        unpackingChargeType: data["unpacking_charge_type"],
        loadingChargeType: data["loading_charge_type"],
        unloadingChargeType: data["unloading_charge_type"],
        packingMaterialChargeType:
        data["packing_material_charge_type"],

        /// GST
        gstType: data["gst_type"],
        gstPercent: data["gst_percent"],

        /// INSURANCE
        insuranceType: data["insurance_type"],
        insurancePercent: data["insurance_charge"],
        insuranceGst: data["insurance_gst"],

        vehicleInsuranceType: data["vehicle_insurance_type"],
        vehicleInsurancePercent:
        data["vehicle_insurance_charge"],
        vehicleInsuranceGst: data["vehicle_insurance_gst"],

        /// DECLARATION
        goodsDeclaration: data["declaration_of_goods"],
        vehicleDeclaration: data["declaration_of_vehicle"],

        /// OTHER
        easyAccess: data["easy_access"],
        balconyRemarks: data["balcony_items"],
        restriction: data["loading_restrictions"],
        specialNeeds: data["special_needs"],
      );

      ref.read(quotationFormProvider.notifier).state = model;

      state = state.copyWith(isPageLoading: false);
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      throw Exception("Failed to load quotation");
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

  Future<bool> updateQuotation(String uid, QuotationFormModel model,String? keyType) async {
    try {
      state = state.copyWith(isPageLoading: true);

      final payload = await _buildPayload(model);

      final success = await repository.updateQuotation(uid, payload,keyType);

      state = state.copyWith(isPageLoading: false);

      return success;
    } catch (e) {
      state = state.copyWith(isPageLoading: false);
      return false;
    }
  }

}

