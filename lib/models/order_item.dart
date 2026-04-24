

class OrderItemModel {
  final String orderNo;
  final String date;
  final String name;
  final String phone;
  final String from;
  final String to;
  final String? uid; // ✅ ADD THIS

  OrderItemModel({
    required this.orderNo,
    required this.date,
    required this.name,
    required this.phone,
    required this.from,
    required this.to,
    this.uid,
  });
}