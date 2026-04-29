class SubscriptionHistoryModel {
  final String uid;
  final String planName;
  final double amount;
  final String startDate;
  final String endDate;
  final String status;
  final int maxSupervisors;
  final int maxManagers;

  SubscriptionHistoryModel({
    required this.uid,
    required this.planName,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.maxSupervisors,
    required this.maxManagers,
  });

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryModel(
      uid: json['uid'] ?? "",
      planName: json['plan_name'] ?? "",
      amount: (json['amount'] ?? 0).toDouble(),
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      status: json['status'] ?? "",
      maxSupervisors: json['max_supervisors'] ?? 0,
      maxManagers: json['max_managers'] ?? 0,
    );
  }
}