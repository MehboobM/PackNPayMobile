
class QuotationFormModel {
  /// =========================
  /// STEP 1: QUOTATION DETAILS
  /// =========================

  String? quotationNo;
  String? companyName;
  String? partyName;
  String? gstNo;
  String? phone;
  String? email;

  String? quotationDate;
  String? packingDate;
  String? deliveryDate;

  /// Dropdowns (STORE VALUE)
  String? vehicleType;     // tempo, truck
  String? loadType;        // ftl, ptl
  String? movingPath;      // by_road, by_air


  /// =========================
  /// STEP 2: MOVING DETAILS
  /// =========================

  String? shiftingDate;

  String? pickupPhone;
  String? pickupEmail;
  String? pickupPincode;

  String? deliveryPhone;
  String? deliveryEmail;
  String? deliveryPincode;

  /// Dropdowns
  String? pickupLiftAvailable;   // yes/no
  String? deliveryLiftAvailable; // yes/no

  /// State & City (IMPORTANT → store ID)
  String? pickupStateId;
  String? pickupCityId;

  String? deliveryStateId;
  String? deliveryCityId;




  /// =========================
  /// STEP 3: PAYMENT DETAILS
  /// =========================

  String? freightCharge;
  String? advancePaid;

  String? packingCharge;
  String? unpackingCharge;
  String? loadingCharge;
  String? unloadingCharge;
  String? packingMaterialCharge;

  String? stCharges;
  String? surchargeAmount;


  /// ✅ ADD THESE (MISSING)
  String? otherCharges;
  String? storageCharge;
  String? tptCharge;
  String? miscCharge;

  /// Dropdowns (Included / Excluded)
  String? packingChargeType;
  String? unpackingChargeType;
  String? loadingChargeType;
  String? unloadingChargeType;
  String? packingMaterialChargeType;

  /// GST
  dynamic gstPercent; // 5, 12, 18
  String? gstType;    // CGST/SGST, IGST

  /// Surcharge
  String? surchargeType; // applicable / not_applicable


  /// =========================
  /// STEP 4: INSURANCE & OTHER
  /// =========================

  /// Goods Insurance
  String? insuranceType;
  dynamic insurancePercent;
  dynamic insuranceGst;

  /// Vehicle Insurance
  String? vehicleInsuranceType;
  dynamic vehicleInsurancePercent;
  dynamic vehicleInsuranceGst;

  /// Remarks
  String? goodsDeclaration;
  String? vehicleDeclaration;

  /// Other
  String? easyAccess;
  String? restriction;
  String? balconyRemarks;   // ✅ NEW
  String? specialNeeds;     // ✅ NEW


  /// =========================
  /// CONSTRUCTOR
  /// =========================

  QuotationFormModel({
    this.quotationNo,
    this.companyName,
    this.partyName,
    this.gstNo,
    this.phone,
    this.email,
    this.quotationDate,
    this.packingDate,
    this.deliveryDate,
    this.vehicleType,
    this.loadType,
    this.movingPath,

    this.shiftingDate,
    this.pickupPhone,
    this.pickupEmail,
    this.pickupPincode,
    this.deliveryPhone,
    this.deliveryEmail,
    this.deliveryPincode,
    this.pickupLiftAvailable,
    this.deliveryLiftAvailable,
    this.pickupStateId,
    this.pickupCityId,
    this.deliveryStateId,
    this.deliveryCityId,

    this.freightCharge,
    this.advancePaid,
    this.packingCharge,
    this.unpackingCharge,
    this.loadingCharge,
    this.unloadingCharge,
    this.packingMaterialCharge,
    this.stCharges,
    this.surchargeAmount,
    this.otherCharges,
    this.storageCharge,
    this.tptCharge,
    this.miscCharge,

    this.packingChargeType,
    this.unpackingChargeType,
    this.loadingChargeType,
    this.unloadingChargeType,
    this.packingMaterialChargeType,
    this.gstPercent,
    this.gstType,
    this.surchargeType,

    this.insuranceType,
    this.insurancePercent,
    this.insuranceGst,
    this.vehicleInsuranceType,
    this.vehicleInsurancePercent,
    this.vehicleInsuranceGst,
    this.goodsDeclaration,
    this.vehicleDeclaration,
    this.easyAccess,
    this.restriction,
    this.balconyRemarks,
    this.specialNeeds,

  });


  /// =========================
  /// TO JSON (FOR HIVE/API)
  /// =========================

  Map<String, dynamic> toJson() {
    return {
      "quotationNo": quotationNo,
      "companyName": companyName,
      "partyName": partyName,
      "gstNo": gstNo,
      "phone": phone,
      "email": email,
      "quotationDate": quotationDate,
      "packingDate": packingDate,
      "deliveryDate": deliveryDate,
      "vehicleType": vehicleType,
      "loadType": loadType,
      "movingPath": movingPath,

      "shiftingDate": shiftingDate,
      "pickupPhone": pickupPhone,
      "pickupEmail": pickupEmail,
      "pickupPincode": pickupPincode,
      "deliveryPhone": deliveryPhone,
      "deliveryEmail": deliveryEmail,
      "deliveryPincode": deliveryPincode,
      "pickupLiftAvailable": pickupLiftAvailable,
      "deliveryLiftAvailable": deliveryLiftAvailable,
      "pickupStateId": pickupStateId,
      "pickupCityId": pickupCityId,
      "deliveryStateId": deliveryStateId,
      "deliveryCityId": deliveryCityId,

      "freightCharge": freightCharge,
      "advancePaid": advancePaid,
      "packingCharge": packingCharge,
      "unpackingCharge": unpackingCharge,
      "loadingCharge": loadingCharge,
      "unloadingCharge": unloadingCharge,
      "packingMaterialCharge": packingMaterialCharge,
      "stCharges": stCharges,
      "otherCharges": otherCharges,
      "storageCharge": storageCharge,
      "tptCharge": tptCharge,
      "miscCharge": miscCharge,

      "packingChargeType": packingChargeType,
      "unpackingChargeType": unpackingChargeType,
      "loadingChargeType": loadingChargeType,
      "unloadingChargeType": unloadingChargeType,
      "packingMaterialChargeType": packingMaterialChargeType,
      "gstPercent": gstPercent,
      "gstType": gstType,
      "surchargeType": surchargeType,

      "insuranceType": insuranceType,
      "insurancePercent": insurancePercent,
      "insuranceGst": insuranceGst,
      "vehicleInsuranceType": vehicleInsuranceType,
      "vehicleInsurancePercent": vehicleInsurancePercent,
      "vehicleInsuranceGst": vehicleInsuranceGst,
      "goodsDeclaration": goodsDeclaration,
      "vehicleDeclaration": vehicleDeclaration,
      "easyAccess": easyAccess,
      "restriction": restriction,

      "balconyRemarks":balconyRemarks,
      "specialNeeds":specialNeeds,

    };
  }


  /// =========================
  /// FROM JSON (HIVE / API)
  /// =========================

  factory QuotationFormModel.fromJson(Map<String, dynamic> json) {
    return QuotationFormModel(
      quotationNo: json["quotationNo"],
      companyName: json["companyName"],
      partyName: json["partyName"],
      gstNo: json["gstNo"],
      phone: json["phone"],
      email: json["email"],
      quotationDate: json["quotationDate"],
      packingDate: json["packingDate"],
      deliveryDate: json["deliveryDate"],
      vehicleType: json["vehicleType"],
      loadType: json["loadType"],
      movingPath: json["movingPath"],

      shiftingDate: json["shiftingDate"],
      pickupPhone: json["pickupPhone"],
      pickupEmail: json["pickupEmail"],
      pickupPincode: json["pickupPincode"],
      deliveryPhone: json["deliveryPhone"],
      deliveryEmail: json["deliveryEmail"],
      deliveryPincode: json["deliveryPincode"],
      pickupLiftAvailable: json["pickupLiftAvailable"],
      deliveryLiftAvailable: json["deliveryLiftAvailable"],
      pickupStateId: json["pickupStateId"],
      pickupCityId: json["pickupCityId"],
      deliveryStateId: json["deliveryStateId"],
      deliveryCityId: json["deliveryCityId"],

      freightCharge: json["freightCharge"],
      advancePaid: json["advancePaid"],
      packingCharge: json["packingCharge"],
      unpackingCharge: json["unpackingCharge"],
      loadingCharge: json["loadingCharge"],
      unloadingCharge: json["unloadingCharge"],
      packingMaterialCharge: json["packingMaterialCharge"],
      stCharges: json["stCharges"],
      otherCharges: json["otherCharges"],
      storageCharge: json["storageCharge"],
      tptCharge: json["tptCharge"],
      miscCharge: json["miscCharge"],
      packingChargeType: json["packingChargeType"],
      unpackingChargeType: json["unpackingChargeType"],
      loadingChargeType: json["loadingChargeType"],
      unloadingChargeType: json["unloadingChargeType"],
      packingMaterialChargeType: json["packingMaterialChargeType"],
      gstPercent: json["gstPercent"],
      gstType: json["gstType"],
      surchargeType: json["surchargeType"],

      insuranceType: json["insuranceType"],
      insurancePercent: json["insurancePercent"],
      insuranceGst: json["insuranceGst"],
      vehicleInsuranceType: json["vehicleInsuranceType"],
      vehicleInsurancePercent: json["vehicleInsurancePercent"],
      vehicleInsuranceGst: json["vehicleInsuranceGst"],
      goodsDeclaration: json["goodsDeclaration"],
      vehicleDeclaration: json["vehicleDeclaration"],
      easyAccess: json["easyAccess"],
      restriction: json["restriction"],

      balconyRemarks: json["balconyRemarks"],
      specialNeeds: json["specialNeeds"],



    );
  }
}