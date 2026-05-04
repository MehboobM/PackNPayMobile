class QuotationFormModel {
  /// STEP 1: QUOTATION DETAILS
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
  String? vehicleType;
  String? loadType;
  String? movingPath;

  /// STEP 2: MOVING DETAILS
  String? shiftingDate;

  String? pickupPhone;
  String? pickupEmail;
  String? pickupPincode;

  String? deliveryPhone;
  String? deliveryEmail;
  String? deliveryPincode;

  /// Dropdowns
  String? pickupLiftAvailable;
  String? deliveryLiftAvailable;

  /// State & City
  String? pickupStateId;
  String? pickupStateCode;
  String? pickupCityId;
  String? pickupCityName;
  String? movingFrom;
  String? movingTo;

  String? deliveryStateId;
  String? deliveryStateCode;
  String? deliveryCityId;
  String? deliveryCityName;

  /// STEP 3: PAYMENT DETAILS
  String? freightCharge;
  String? advancePaid;
  String? summaryDiscount;

  String? packingCharge;
  String? unpackingCharge;
  String? loadingCharge;
  String? unloadingCharge;
  String? packingMaterialCharge;

  String? stCharges;
  String? surchargeAmount;

  String? otherCharges;
  String? storageCharge;
  String? tptCharge;
  String? miscCharge;

  String? packingChargeType;
  String? unpackingChargeType;
  String? loadingChargeType;
  String? unloadingChargeType;
  String? packingMaterialChargeType;

  String? paymentStatus;
  String? totalAmount;

  dynamic gstPercent;
  String? gstType;
  String? surchargeType;

  /// STEP 4: INSURANCE & OTHER
  String? insuranceType;
  dynamic insurancePercent;
  dynamic insuranceGst;

  String? vehicleInsuranceType;
  dynamic vehicleInsurancePercent;
  dynamic vehicleInsuranceGst;

  String? goodsDeclaration;
  String? vehicleDeclaration;

  String? easyAccess;
  String? restriction;
  String? balconyRemarks;
  String? specialNeeds;

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
    this.pickupStateCode,
    this.pickupCityId,
    this.pickupCityName,
    this.deliveryStateId,
    this.deliveryStateCode,
    this.deliveryCityId,
    this.deliveryCityName,
    this.movingFrom,
    this.movingTo,
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
    this.paymentStatus,
    this.totalAmount,
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

  Map<String, dynamic> toJson() {
    return {
      "quotationNo": quotationNo?.toString(),
      "companyName": companyName?.toString(),
      "partyName": partyName?.toString(),
      "gstNo": gstNo?.toString(),
      "phone": phone?.toString(),
      "email": email?.toString(),
      "quotationDate": quotationDate?.toString(),
      "packingDate": packingDate?.toString(),
      "deliveryDate": deliveryDate?.toString(),
      "vehicleType": vehicleType?.toString(),
      "loadType": loadType?.toString(),
      "movingPath": movingPath?.toString(),
      "shiftingDate": shiftingDate?.toString(),
      "pickupPhone": pickupPhone?.toString(),
      "pickupEmail": pickupEmail?.toString(),
      "pickupPincode": pickupPincode?.toString(),
      "deliveryPhone": deliveryPhone?.toString(),
      "deliveryEmail": deliveryEmail?.toString(),
      "deliveryPincode": deliveryPincode?.toString(),
      "pickupLiftAvailable": pickupLiftAvailable?.toString(),
      "deliveryLiftAvailable": deliveryLiftAvailable?.toString(),
      // CRITICAL: Ensure IDs are Strings
      "pickupStateId": pickupStateId?.toString(),
      "pickupStateCode": pickupStateCode?.toString(),
      "pickupCityId": pickupCityId?.toString(),
      "pickupCityName": pickupCityName?.toString(),
      "deliveryStateId": deliveryStateId?.toString(),
      "deliveryStateCode": deliveryStateCode?.toString(),
      "deliveryCityId": deliveryCityId?.toString(),
      "deliveryCityName": deliveryCityName?.toString(),
      "movingFrom": movingFrom?.toString(),
      "movingTo": movingTo?.toString(),
      // CRITICAL: Ensure Charges are Strings
      "freightCharge": freightCharge?.toString(),
      "advancePaid": advancePaid?.toString(),
      "summaryDiscount": summaryDiscount?.toString(),
      "packingCharge": packingCharge?.toString(),
      "unpackingCharge": unpackingCharge?.toString(),
      "loadingCharge": loadingCharge?.toString(),
      "unloadingCharge": unloadingCharge?.toString(),
      "packingMaterialCharge": packingMaterialCharge?.toString(),
      "stCharges": stCharges?.toString(),
      "otherCharges": otherCharges?.toString(),
      "storageCharge": storageCharge?.toString(),
      "tptCharge": tptCharge?.toString(),
      "miscCharge": miscCharge?.toString(),
      "packingChargeType": packingChargeType?.toString(),
      "paymentStatus": paymentStatus?.toString(),
      "totalAmount": totalAmount?.toString(),
      "unpackingChargeType": unpackingChargeType?.toString(),
      "loadingChargeType": loadingChargeType?.toString(),
      "unloadingChargeType": unloadingChargeType?.toString(),
      "packingMaterialChargeType": packingMaterialChargeType?.toString(),
      "gstPercent": gstPercent?.toString(),
      "gstType": gstType?.toString(),
      "surchargeType": surchargeType?.toString(),
      "surchargeAmount": surchargeAmount?.toString(),
      "insuranceType": insuranceType?.toString(),
      "insurancePercent": insurancePercent?.toString(),
      "insuranceGst": insuranceGst?.toString(),
      "vehicleInsuranceType": vehicleInsuranceType?.toString(),
      "vehicleInsurancePercent": vehicleInsurancePercent?.toString(),
      "vehicleInsuranceGst": vehicleInsuranceGst?.toString(),
      "goodsDeclaration": goodsDeclaration?.toString(),
      "vehicleDeclaration": vehicleDeclaration?.toString(),
      "easyAccess": easyAccess?.toString(),
      "restriction": restriction?.toString(),
      "balconyRemarks": balconyRemarks?.toString(),
      "specialNeeds": specialNeeds?.toString(),
    };
  }

  factory QuotationFormModel.fromJson(Map<String, dynamic> json) {
    return QuotationFormModel(
      quotationNo: json["quotationNo"]?.toString(),
      companyName: json["companyName"]?.toString(),
      partyName: json["partyName"]?.toString(),
      gstNo: json["gstNo"]?.toString(),
      phone: json["phone"]?.toString(),
      email: json["email"]?.toString(),
      quotationDate: json["quotationDate"]?.toString(),
      packingDate: json["packingDate"]?.toString(),
      deliveryDate: json["deliveryDate"]?.toString(),
      vehicleType: json["vehicleType"]?.toString(),
      loadType: json["loadType"]?.toString(),
      movingPath: json["movingPath"]?.toString(),
      shiftingDate: json["shiftingDate"]?.toString(),
      pickupPhone: json["pickupPhone"]?.toString(),
      pickupEmail: json["pickupEmail"]?.toString(),
      pickupPincode: json["pickupPincode"]?.toString(),
      deliveryPhone: json["deliveryPhone"]?.toString(),
      deliveryEmail: json["deliveryEmail"]?.toString(),
      deliveryPincode: json["deliveryPincode"]?.toString(),
      pickupLiftAvailable: json["pickupLiftAvailable"]?.toString(),
      deliveryLiftAvailable: json["deliveryLiftAvailable"]?.toString(),
      pickupStateId: json["pickupStateId"]?.toString(),
      pickupStateCode: json["pickupStateCode"]?.toString(),
      pickupCityId: json["pickupCityId"]?.toString(),
      pickupCityName: json["pickupCityName"]?.toString(),
      deliveryStateId: json["deliveryStateId"]?.toString(),
      deliveryStateCode: json["deliveryStateCode"]?.toString(),
      deliveryCityId: json["deliveryCityId"]?.toString(),
      deliveryCityName: json["deliveryCityName"]?.toString(),
      movingFrom: json["movingFrom"]?.toString(),
      movingTo: json["movingTo"]?.toString(),
      freightCharge: json["freightCharge"]?.toString(),
      advancePaid: json["advancePaid"]?.toString(),
      packingCharge: json["packingCharge"]?.toString(),
      unpackingCharge: json["unpackingCharge"]?.toString(),
      loadingCharge: json["loadingCharge"]?.toString(),
      unloadingCharge: json["unloadingCharge"]?.toString(),
      packingMaterialCharge: json["packingMaterialCharge"]?.toString(),
      stCharges: json["stCharges"]?.toString(),
      otherCharges: json["otherCharges"]?.toString(),
      storageCharge: json["storageCharge"]?.toString(),
      tptCharge: json["tptCharge"]?.toString(),
      miscCharge: json["miscCharge"]?.toString(),
      packingChargeType: json["packingChargeType"]?.toString(),
      paymentStatus: json["paymentStatus"]?.toString(),
      totalAmount: json["totalAmount"]?.toString(),
      unpackingChargeType: json["unpackingChargeType"]?.toString(),
      loadingChargeType: json["loadingChargeType"]?.toString(),
      unloadingChargeType: json["unloadingChargeType"]?.toString(),
      packingMaterialChargeType: json["packingMaterialChargeType"]?.toString(),
      gstPercent: json["gstPercent"],
      gstType: json["gstType"]?.toString(),
      surchargeType: json["surchargeType"]?.toString(),
      surchargeAmount: json["surchargeAmount"]?.toString(),
      insuranceType: json["insuranceType"]?.toString(),
      insurancePercent: json["insurancePercent"],
      insuranceGst: json["insuranceGst"],
      vehicleInsuranceType: json["vehicleInsuranceType"]?.toString(),
      vehicleInsurancePercent: json["vehicleInsurancePercent"],
      vehicleInsuranceGst: json["vehicleInsuranceGst"],
      goodsDeclaration: json["goodsDeclaration"]?.toString(),
      vehicleDeclaration: json["vehicleDeclaration"]?.toString(),
      easyAccess: json["easyAccess"]?.toString(),
      restriction: json["restriction"]?.toString(),
      balconyRemarks: json["balconyRemarks"]?.toString(),
      specialNeeds: json["specialNeeds"]?.toString(),
    );
  }
}