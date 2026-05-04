class LorryReceiptModel {
  final String uid;
  final String lrNo;
  final String lrDate;
  final String vehicleNo;
  final String movingFrom;
  final String movingTo;
  final String totalAmount;
  final String status;
  final String customerName;
  final String phone;
  final String quotationNo;

  LorryReceiptModel({
    required this.uid,
    required this.lrNo,
    required this.lrDate,
    required this.vehicleNo,
    required this.movingFrom,
    required this.movingTo,
    required this.totalAmount,
    required this.status,
    required this.customerName,
    required this.phone,
    required this.quotationNo,
  });

  factory LorryReceiptModel.fromJson(Map<String, dynamic> json) {
    return LorryReceiptModel(
      uid: json['uid'] ?? '',
      lrNo: json['lr_no'] ?? '',
      lrDate: json['lr_date'] ?? '',
      vehicleNo: json['vehicle_no'] ?? '',
      movingFrom: json['moving_from'] ?? '',
      movingTo: json['moving_to'] ?? '',
      totalAmount: json['total_amount'] ?? '0',
      status: json['status'] ?? '',
      customerName: json['customer_name'] ?? '',
      phone: json['phone'] ?? '',
      quotationNo: json['quotation_no'] ?? '',
    );
  }
}