class OrderItemModel {
  final String orderNo;
  final String? sourceType; // ✅ make nullable
  final String date;
  final String name;
  final String phone;
  final String from;
  final String to;
  final String? uid;

  OrderItemModel({
    required this.orderNo,
    this.sourceType, // ✅ NOT required now
    required this.date,
    required this.name,
    required this.phone,
    required this.from,
    required this.to,
    this.uid,
  });
}