class ActionItemModel {
  final String id;
  final String type;
  final String remark;
  final String date;
  final String name;
  final String phone;
  final String from;
  final String to;

  ActionItemModel({
    required this.id,
    required this.type,
    required this.remark,
    required this.date,
    required this.name,
    required this.phone,
    required this.from,
    required this.to,
  });

  factory ActionItemModel.fromJson(Map<String, dynamic> json) {
    return ActionItemModel(
      id: json['uid'] ?? "",
      type: json['source_type'] ?? "N/A",
      remark: json['remark'] ?? "",
      date: json['trigger_on'] ?? "",
      name: json['customer_name'] ?? "Unknown",
      phone: json['phone'] ?? "-",
      from: json['moving_from'] ?? "-",
      to: json['moving_to'] ?? "-",
    );
  }
}