class SubscriptionModel {
  final String uid;
  final String name;
  final String startDate;
  final String endDate;
  final String status;
  final int daysLeft;

  SubscriptionModel({
    required this.uid,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.daysLeft,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      uid: json['uid'] ?? "",
      name: json['name'] ?? "-",
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      status: json['status'] ?? "",
      daysLeft: json['days_left'] ?? 0,
    );
  }
}