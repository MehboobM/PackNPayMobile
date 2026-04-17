class CreateLorryReceiptRequest {
  final String orderId; // ✅ New Field
  final String quotationId;
  final String surveyId;
  final String lrNo;
  final String lrDate;
  final String riskType;
  final String vehicleNo;
  final String movingFrom;
  final String movingTo;
  final String driverName;
  final String driverPhone;
  final String driverLicense;
  final double goodsValue;
  final String invoiceDate;
  final String invoiceNo;
  final String ewayBillNo;
  final String ewayBillDate;
  final String ewayExpiryDate;
  final String? ewayExtendDate;
  final double totalAmount;
  final Map<String, dynamic> consignorFrom;
  final Map<String, dynamic> consignorTo;
  final Map<String, dynamic> package;
  final Map<String, dynamic> payment;
  final Map<String, dynamic> insurance;
  final Map<String, dynamic> demurrage;

  CreateLorryReceiptRequest({
    required this.orderId, // ✅ Added
    required this.quotationId,
    required this.surveyId,
    required this.lrNo,
    required this.lrDate,
    required this.riskType,
    required this.vehicleNo,
    required this.movingFrom,
    required this.movingTo,
    required this.driverName,
    required this.driverPhone,
    required this.driverLicense,
    required this.goodsValue,
    required this.invoiceDate,
    required this.invoiceNo,
    required this.ewayBillNo,
    required this.ewayBillDate,
    required this.ewayExpiryDate,
    this.ewayExtendDate,
    required this.totalAmount,
    required this.consignorFrom,
    required this.consignorTo,
    required this.package,
    required this.payment,
    required this.insurance,
    required this.demurrage,
  });

  factory CreateLorryReceiptRequest.fromJson(Map<String, dynamic> json) {
    return CreateLorryReceiptRequest(
      orderId: json["order_id"] ?? "",
      quotationId: json["quotation_id"] ?? "",
      surveyId: json["survey_id"] ?? "",
      lrNo: json["lr_no"] ?? "",
      lrDate: json["lr_date"] ?? "",
      riskType: json["risk_type"] ?? "",
      vehicleNo: json["vehicle_no"] ?? "",
      movingFrom: json["moving_from"] ?? "",
      movingTo: json["moving_to"] ?? "",
      driverName: json["driver_name"] ?? "",
      driverPhone: json["driver_phone"] ?? "",
      driverLicense: json["driver_license"] ?? "",
      goodsValue: (json["goods_value"] ?? 0).toDouble(),
      invoiceDate: json["invoice_date"] ?? "",
      invoiceNo: json["invoice_no"] ?? "",
      ewayBillNo: json["eway_bill_no"] ?? "",
      ewayBillDate: json["eway_bill_date"] ?? "",
      ewayExpiryDate: json["eway_expiry_date"] ?? "",
      ewayExtendDate: json["eway_extend_date"],
      totalAmount: (json["total_amount"] ?? 0).toDouble(),
      consignorFrom:
      Map<String, dynamic>.from(json["consignor_from"] ?? {}),
      consignorTo:
      Map<String, dynamic>.from(json["consignor_to"] ?? {}),
      package: Map<String, dynamic>.from(json["package"] ?? {}),
      payment: Map<String, dynamic>.from(json["payment"] ?? {}),
      insurance: Map<String, dynamic>.from(json["insurance"] ?? {}),
      demurrage: Map<String, dynamic>.from(json["demurrage"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "order_id": orderId, // ✅ Added
      "quotation_id": quotationId,
      "survey_id": surveyId,
      "lr_no": lrNo,
      "lr_date": lrDate,
      "risk_type": riskType,
      "vehicle_no": vehicleNo,
      "moving_from": movingFrom,
      "moving_to": movingTo,
      "driver_name": driverName,
      "driver_phone": driverPhone,
      "driver_license": driverLicense,
      "goods_value": goodsValue,
      "invoice_date": invoiceDate,
      "invoice_no": invoiceNo,
      "eway_bill_no": ewayBillNo,
      "eway_bill_date": ewayBillDate,
      "eway_expiry_date": ewayExpiryDate,
      "eway_extend_date": ewayExtendDate,
      "total_amount": totalAmount,
      "consignor_from": consignorFrom,
      "consignor_to": consignorTo,
      "package": package,
      "payment": payment,
      "insurance": insurance,
      "demurrage": demurrage,
    };
  }
}