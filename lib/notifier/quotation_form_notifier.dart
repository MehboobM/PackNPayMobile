

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quatation_form_model.dart';

final quotationFormProvider = StateNotifierProvider<QuotationFormNotifier, QuotationFormModel>((ref) {
  return QuotationFormNotifier();
});


class QuotationFormNotifier extends StateNotifier<QuotationFormModel> {
  QuotationFormNotifier() : super(QuotationFormModel());

  /// 🔹 SET FULL DATA (init from Hive / other screen)
  void setData(QuotationFormModel model) {
    state = model;
  }

  /// 🔹 CLEAR (final save)
  void clear() {
    state = QuotationFormModel();
  }

  /// 🔹 UPDATE METHODS (IMPORTANT)

  void updateCompany(String val) {
    state = state..companyName = val;
  }

  void updateQuotationNo(String val) {
    state = state..quotationNo = val;
  }

  void updateVehicleType(String val) {
    state = state..vehicleType = val;
  }

  void updateLoadType(String val) {
    state = state..loadType = val;
  }

  void updateMovingPath(String val) {
    state = state..movingPath = val;
  }

  void updateShiftingDate(String val) {
    state = state..shiftingDate = val;
  }

  void updatePickupPhone(String val) {
    state = state..pickupPhone = val;
  }

  void updateFreight(String val) {
    state = state..freightCharge = val;
  }

  void updateInsuranceType(String val) {
    state = state..insuranceType = val;
  }
}