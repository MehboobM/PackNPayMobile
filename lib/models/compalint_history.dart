class SupportTicketModel {
  final int id;
  final String uid;
  final int userId;
  final String userType;
  final String issueType;
  final String message;
  final String status;
  final String createdAt;
  final String? updatedAt;

  SupportTicketModel({
    required this.id,
    required this.uid,
    required this.userId,
    required this.userType,
    required this.issueType,
    required this.message,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? '',
      userId: json['user_id'] ?? 0,
      userType: json['user_type'] ?? '',
      issueType: json['issue_type'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
    );
  }
}