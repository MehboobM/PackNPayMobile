class UpcomingOrderModel {
  final String uid; // ✅ ADD THIS
  final String orderNo;
  final String customerName;
  final String phone;
  final String movingFrom;
  final String movingTo;
  final String packingDate;
  final String deliveryDate;

  UpcomingOrderModel({
    required this.uid, // ✅ ADD
    required this.orderNo,
    required this.customerName,
    required this.phone,
    required this.movingFrom,
    required this.movingTo,
    required this.packingDate,
    required this.deliveryDate,
  });

  factory UpcomingOrderModel.fromJson(Map<String, dynamic> json) {
    return UpcomingOrderModel(
      uid: json['uid'] ?? "", // ✅ ADD THIS LINE
      orderNo: json['order_no'] ?? '',
      customerName: json['customer_name'] ?? '',
      phone: json['phone'] ?? '',
      movingFrom: json['moving_from'] ?? '',
      movingTo: json['moving_to'] ?? '',
      packingDate: json['packing_date'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
    );
  }
}