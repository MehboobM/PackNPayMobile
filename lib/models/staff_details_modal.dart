class UserDetailsModel {
  final int id;
  final String uid;
  final String? name;
  final String? role;
  final String? email;
  final String? mobile;
  final String? joiningDate;
  final String? address;
  final String status;

  final int quotationCount;
  final int surveyCount;
  final int orderCount;
  final int lrCount;
  final int totalDaysWorked;

  final Map<String, List<dynamic>> attendanceMap;

  UserDetailsModel({
    required this.id,
    required this.uid,
    this.name,
    this.role,
    this.email,
    this.mobile,
    this.joiningDate,
    this.address,
    required this.status,
    required this.quotationCount,
    required this.surveyCount,
    required this.orderCount,
    required this.lrCount,
    required this.totalDaysWorked,
    required this.attendanceMap,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
      mobile: json['mobile'],
      joiningDate: json['joining_date'],
      address: json['address'],
      status: json['status'] ?? "INACTIVE",

      quotationCount: json['quotation_count'] ?? 0,
      surveyCount: json['survey_count'] ?? 0,
      orderCount: json['order_count'] ?? 0,
      lrCount: json['lr_count'] ?? 0,
      totalDaysWorked: json['total_days_worked'] ?? 0,

      attendanceMap: Map<String, List<dynamic>>.from(
        json['attendance_map'] ?? {},
      ),
    );
  }
}