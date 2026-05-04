class MoneyReceiptModel {
  final String uid;
  final String receiptNo;
  final String date;
  final String name;
  final String phone;
  final String from;
  final String to;
  final String amount;

  MoneyReceiptModel({
    required this.uid,
    required this.receiptNo,
    required this.date,
    required this.name,
    required this.phone,
    required this.from,
    required this.to,
    required this.amount,
  });

  factory MoneyReceiptModel.fromJson(Map<String, dynamic> json) {
    return MoneyReceiptModel(
      uid: json['uid'] ?? "",
      receiptNo: json['receipt_no'] ?? "",
      date: json['receipt_date'] ?? "",
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      from: json['move_from'] ?? "",
      to: json['move_to'] ?? "",
      amount: json['receipt_amount'] ?? "",
    );
  }
}