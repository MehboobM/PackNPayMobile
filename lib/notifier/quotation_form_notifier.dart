

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

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$'); // exactly 10 digits
    return phoneRegex.hasMatch(phone);
  }

  String? validateStep(int step) {
    switch (step) {

    /// =======================
    /// STEP 0 👉 QUOTATION DETAILS
    /// =======================
      case 0:
        if (state.companyName == null || state.companyName!.isEmpty) {
          return "Company Name is required";
        }

        if (state.partyName == null || state.partyName!.isEmpty) {
          return "Party Name is required";
        }

        if (state.phone == null || state.phone!.isEmpty) {
          return "Phone number is required";
        }

        /// ✅ PHONE VALIDATION
        if (!isValidPhone(state.phone!)) {
          return "Enter valid 10 digit phone number";
        }

        if (state.email == null || state.email!.isEmpty) {
          return "Email is required";
        }

        /// ✅ EMAIL VALIDATION
        if (!isValidEmail(state.email!)) {
          return "Enter valid email address";
        }

        if (state.quotationDate == null || state.quotationDate!.isEmpty) {
          return "Quotation date is required";
        }

        if (state.packingDate == null || state.packingDate!.isEmpty) {
          return "Packing date is required";
        }

        if (state.deliveryDate == null || state.deliveryDate!.isEmpty) {
          return "Delivery date is required";
        }

        if (state.vehicleType == null || state.vehicleType!.isEmpty) {
          return "Vehicle type is required";
        }

        if (state.loadType == null || state.loadType!.isEmpty) {
          return "Load type is required";
        }

        if (state.movingPath == null || state.movingPath!.isEmpty) {
          return "Moving path is required";
        }

        return null;


    /// =======================
    /// STEP 1 👉 MOVING DETAILS
    /// =======================
      case 1:

        if (state.shiftingDate == null || state.shiftingDate!.isEmpty) {
          return "Shifting date is required";
        }

        /// PICKUP
        if (state.pickupPhone == null || state.pickupPhone!.isEmpty) {
          return "Pickup phone is required";
        }

        if (!isValidPhone(state.pickupPhone!)) {
          return "Enter valid pickup phone (10 digits)";
        }

        if (state.pickupEmail == null || state.pickupEmail!.isEmpty) {
          return "Pickup email is required";
        }

        if (!isValidEmail(state.pickupEmail!)) {
          return "Enter valid pickup email";
        }

        if (state.pickupStateId == null || state.pickupStateId!.isEmpty) {
          return "Pickup state is required";
        }

        if (state.pickupCityId == null || state.pickupCityId!.isEmpty) {
          return "Pickup city is required";
        }

        if (state.pickupPincode == null || state.pickupPincode!.isEmpty) {
          return "Pickup pincode is required";
        }

        if (state.pickupLiftAvailable == null || state.pickupLiftAvailable!.isEmpty) {
          return "Pickup Lift is required";
        }

        /// DELIVERY
        if (state.deliveryPhone == null || state.deliveryPhone!.isEmpty) {
          return "Delivery phone is required";
        }

        if (!isValidPhone(state.deliveryPhone!)) {
          return "Enter valid delivery phone (10 digits)";
        }

        if (state.deliveryEmail == null || state.deliveryEmail!.isEmpty) {
          return "Delivery email is required";
        }

        if (!isValidEmail(state.deliveryEmail!)) {
          return "Enter valid delivery email";
        }

        if (state.deliveryStateId == null || state.deliveryStateId!.isEmpty) {
          return "Delivery state is required";
        }

        if (state.deliveryCityId == null || state.deliveryCityId!.isEmpty) {
          return "Delivery city is required";
        }

        if (state.deliveryPincode == null || state.deliveryPincode!.isEmpty) {
          return "Delivery pincode is required";
        }

        if (state.deliveryLiftAvailable == null || state.deliveryLiftAvailable!.isEmpty) {
          return "Delivery Lift is required";
        }

        return null;


    /// =======================
    /// STEP 2 👉 PAYMENT DETAILS
    /// =======================
      case 2:

        if (state.freightCharge == null || state.freightCharge!.isEmpty) {
          return "Freight charge is required";
        }


        if ((state.packingCharge == null || state.packingCharge!.isEmpty) && state.packingChargeType=="extra") {
          return "Packing charge is required";
        }

        if ((state.unpackingCharge == null || state.unpackingCharge!.isEmpty)  && state.unpackingChargeType=="extra") {
          return "Unpacking charge is required";
        }


        if ((state.loadingCharge == null || state.loadingCharge!.isEmpty)  && state.loadingChargeType=="extra") {
          return "Loading charge is required";
        }


        if ((state.unloadingCharge == null || state.unloadingCharge!.isEmpty)  && state.unloadingChargeType=="extra") {
          return "Unloading charge is required";
        }


        if ((state.packingMaterialCharge == null || state.packingMaterialCharge!.isEmpty)  && state.packingMaterialChargeType=="extra") {
          return "Packing material charge is required";
        }
        if (state.storageCharge == null || state.storageCharge!.isEmpty) {
          return "Storage charges are required";
        }
        if (state.tptCharge == null || state.tptCharge!.isEmpty) {
          return "TPT charges are required";
        }

        if (state.miscCharge == null || state.miscCharge!.isEmpty) {
          return "Miscellaneous charges are required";
        }

        if (state.otherCharges == null || state.otherCharges!.isEmpty) {
          return "Other charges are required";
        }

        if (state.stCharges == null || state.stCharges!.isEmpty) {
          return "ST charges are required";
        }

        if (state.gstPercent == null) {
          return "GST percentage is required";
        }

        if (state.gstType == null || state.gstType!.isEmpty) {
          return "GST type is required";
        }

        if ((state.surchargeAmount == null || state.surchargeAmount!.isEmpty) && state.surchargeType=="extra") {
          return "Surcharge amount is required";
        }

        return null;


    /// =======================
    /// STEP 3 👉 INSURANCE & OTHER
    /// =======================
      case 3:

        if (state.insuranceType == null || state.insuranceType!.isEmpty) {
          return "Insurance type is required";
        }
        if (state.insurancePercent == null) {
          return "Insurance percentage is required";
        }

        if (state.insuranceGst == null) {
          return "Insurance GST is required";
        }

        if (state.goodsDeclaration == null || state.goodsDeclaration!.isEmpty) {
          return "Goods declaration is required";
        }

        if (state.vehicleInsuranceType == null || state.vehicleInsuranceType!.isEmpty) {
          return "Vehicle insurance type is required";
        }

        if (state.vehicleInsurancePercent == null) {
          return "Vehicle insurance % is required";
        }

        if (state.vehicleInsuranceGst == null) {
          return "Vehicle insurance GST is required";
        }

        if (state.vehicleDeclaration == null || state.vehicleDeclaration!.isEmpty) {
          return "Vehicle declaration is required";
        }

        /*if (state.balconyRemarks == null || state.balconyRemarks!.isEmpty) {
          return "Balcony remark is required";
        }

        if (state.specialNeeds == null || state.specialNeeds!.isEmpty) {
          return "Special needs is required";
        }


        if (state.easyAccess == null || state.easyAccess!.isEmpty) {
          return "Easy access selection required";
        }

        if (state.restriction == null || state.restriction!.isEmpty) {
          return "Restriction selection required";
        }*/

        return null;

      default:
        return null;
    }
  }

  // String? validateStep(int step) {
  //   switch (step) {
  //
  //   /// =======================
  //   /// STEP 0 (Already Done)
  //   /// =======================
  //     case 0:
  //       if (state.companyName == null || state.companyName!.isEmpty) {
  //         return "Company Name is required";
  //       }
  //       if (state.partyName == null || state.partyName!.isEmpty) {
  //         return "Party Name is required";
  //       }
  //       if (state.phone == null || state.phone!.isEmpty) {
  //         return "Phone number is required";
  //       }
  //       if (state.email == null || state.email!.isEmpty) {
  //         return "Email is required";
  //       }
  //       if (state.quotationDate == null || state.quotationDate!.isEmpty) {
  //         return "Quotation date is required";
  //       }
  //       if (state.packingDate == null || state.packingDate!.isEmpty) {
  //         return "Packing date is required";
  //       }
  //       if (state.deliveryDate == null || state.deliveryDate!.isEmpty) {
  //         return "Delivery date is required";
  //       }
  //       if (state.vehicleType == null || state.vehicleType!.isEmpty) {
  //         return "Vehicle type is required";
  //       }
  //       if (state.loadType == null || state.loadType!.isEmpty) {
  //         return "Load type is required";
  //       }
  //       if (state.movingPath == null || state.movingPath!.isEmpty) {
  //         return "Moving path is required";
  //       }
  //       return null;
  //
  //
  //   /// =======================
  //   /// STEP 1 👉 MOVING DETAILS
  //   /// =======================
  //     case 1:
  //
  //       if (state.shiftingDate == null || state.shiftingDate!.isEmpty) {
  //         return "Shifting date is required";
  //       }
  //
  //       if (state.pickupPhone == null || state.pickupPhone!.isEmpty) {
  //         return "Pickup phone is required";
  //       }
  //
  //       if (state.pickupEmail == null || state.pickupEmail!.isEmpty) {
  //         return "Pickup email is required";
  //       }
  //
  //       if (state.pickupStateId == null || state.pickupStateId!.isEmpty) {
  //         return "Pickup state is required";
  //       }
  //       if (state.pickupCityId == null || state.pickupCityId!.isEmpty) {
  //         return "Pickup city is required";
  //       }
  //
  //       if (state.pickupPincode == null || state.pickupPincode!.isEmpty) {
  //         return "Pickup pincode is required";
  //       }
  //
  //       if (state.deliveryPhone == null || state.deliveryPhone!.isEmpty) {
  //         return "Delivery phone is required";
  //       }
  //
  //       if (state.deliveryEmail == null || state.deliveryEmail!.isEmpty) {
  //         return "Delivery email is required";
  //       }
  //
  //       if (state.deliveryStateId == null || state.deliveryStateId!.isEmpty) {
  //         return "Delivery state is required";
  //       }
  //       if (state.deliveryCityId == null || state.deliveryCityId!.isEmpty) {
  //         return "Delivery city is required";
  //       }
  //
  //       /// ❗ OPTIONAL FIELD (you can change later)
  //       if (state.deliveryPincode == null || state.deliveryPincode!.isEmpty) {
  //         return "Delivery pincode is required";
  //       }
  //
  //       return null;
  //
  //
  //   /// =======================
  //   /// STEP 2 👉 PAYMENT DETAILS
  //   /// =======================
  //     case 2:
  //
  //       if (state.freightCharge == null || state.freightCharge!.isEmpty) {
  //         return "Freight charge is required";
  //       }
  //
  //       if (state.advancePaid == null || state.advancePaid!.isEmpty) {
  //         return "Advance amount is required";
  //       }
  //
  //       if (state.packingCharge == null || state.packingCharge!.isEmpty) {
  //         return "Packing charge is required";
  //       }
  //
  //       if (state.unpackingCharge == null || state.unpackingCharge!.isEmpty) {
  //         return "Unpacking charge is required";
  //       }
  //
  //       if (state.loadingCharge == null || state.loadingCharge!.isEmpty) {
  //         return "Loading charge is required";
  //       }
  //
  //       if (state.unloadingCharge == null || state.unloadingCharge!.isEmpty) {
  //         return "Unloading charge is required";
  //       }
  //
  //       if (state.packingMaterialCharge == null || state.packingMaterialCharge!.isEmpty) {
  //         return "Packing material charge is required";
  //       }
  //
  //       if (state.stCharges == null || state.stCharges!.isEmpty) {
  //         return "ST charges are required";
  //       }
  //
  //       if (state.surchargeAmount == null || state.surchargeAmount!.isEmpty) {
  //         return "Surcharge amount is required";
  //       }
  //
  //       if (state.storageCharge == null || state.storageCharge!.isEmpty) {
  //         return "Storage charge is required";
  //       }
  //
  //       if (state.tptCharge == null || state.tptCharge!.isEmpty) {
  //         return "Transport charge is required";
  //       }
  //
  //       /// ❗ OPTIONAL FIELD (example)
  //       if (state.miscCharge == null || state.miscCharge!.isEmpty) {
  //         return "Misc charge is required";
  //       }
  //
  //       if (state.otherCharges == null || state.otherCharges!.isEmpty) {
  //         return "Other charge is required";
  //       }
  //
  //       /// GST
  //       if (state.gstPercent == null) {
  //         return "GST percentage is required";
  //       }
  //
  //       if (state.gstType == null || state.gstType!.isEmpty) {
  //         return "GST type is required";
  //       }
  //
  //       return null;
  //
  //
  //   /// =======================
  //   /// STEP 3 👉 INSURANCE & OTHER
  //   /// =======================
  //     case 3:
  //
  //       if (state.goodsDeclaration == null || state.goodsDeclaration!.isEmpty) {
  //         return "Goods declaration is required";
  //       }
  //
  //       if (state.vehicleDeclaration == null || state.vehicleDeclaration!.isEmpty) {
  //         return "Vehicle declaration is required";
  //       }
  //
  //       if (state.balconyRemarks == null || state.balconyRemarks!.isEmpty) {
  //         return "Balcony remark is required";
  //       }
  //
  //       if (state.specialNeeds == null || state.specialNeeds!.isEmpty) {
  //         return "Special needs is required";
  //       }
  //
  //       /// Insurance
  //       if (state.insuranceType == null || state.insuranceType!.isEmpty) {
  //         return "Insurance type is required";
  //       }
  //
  //       if (state.insurancePercent == null) {
  //         return "Insurance percentage is required";
  //       }
  //
  //       if (state.insuranceGst == null) {
  //         return "Insurance GST is required";
  //       }
  //
  //       if (state.vehicleInsuranceType == null || state.vehicleInsuranceType!.isEmpty) {
  //         return "Vehicle insurance type is required";
  //       }
  //
  //       if (state.vehicleInsurancePercent == null) {
  //         return "Vehicle insurance % is required";
  //       }
  //
  //       /// ❗ OPTIONAL FIELD
  //       if (state.vehicleInsuranceGst == null) {
  //         return "Vehicle insurance GST is required";
  //       }
  //
  //       /// Access & restriction
  //       if (state.easyAccess == null || state.easyAccess!.isEmpty) {
  //         return "Easy access selection required";
  //       }
  //
  //       if (state.restriction == null || state.restriction!.isEmpty) {
  //         return "Restriction selection required";
  //       }
  //
  //       return null;
  //
  //
  //     default:
  //       return null;
  //   }
  // }
}