class UserModel {
  final int id;
  final String uid;
  final String? username;
  final String? name;
  final String? role;
  final String? email;
  final String? mobile;
  final String? alternateMobile;
  final String? loginCode;
  final String? joiningDate;
  final String? address;
  final String? advanceSalary;
  final String? baseSalary;
  final String? profileImage;
  final String status;

  // ✅ ADD THESE
  final int surveyCount;
  final int quotationCount;
  final int orderCount;
  final int lrCount;

  UserModel({
    required this.id,
    required this.uid,
    this.username,
    this.name,
    this.role,
    this.email,
    this.mobile,
    this.alternateMobile,
    this.loginCode,
    this.joiningDate,
    this.address,
    this.advanceSalary,
    this.baseSalary,
    this.profileImage,
    required this.status,

    // ✅ ADD IN CONSTRUCTOR
    this.surveyCount = 0,
    this.quotationCount = 0,
    this.orderCount = 0,
    this.lrCount = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      uid: json['uid'],
      username: json['username'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
      mobile: json['mobile'],
      alternateMobile: json['alternate_mobile'],
      loginCode: json['login_code'],
      joiningDate: json['joining_date'],
      address: json['address'],
      advanceSalary: json['advance_salary']?.toString(),
      baseSalary: json['base_salary']?.toString(),
      profileImage: json['profile_image'],
      status: json['status'] ?? "INACTIVE",

      // ✅ MAP API DATA
      surveyCount: json['survey_count'] ?? 0,
      quotationCount: json['quotation_count'] ?? 0,
      orderCount: json['order_count'] ?? 0,
      lrCount: json['lr_count'] ?? 0,
    );
  }

  UserModel copyWith({
    int? id,
    String? uid,
    String? username,
    String? name,
    String? role,
    String? email,
    String? mobile,
    String? alternateMobile,
    String? loginCode,
    String? joiningDate,
    String? address,
    String? advanceSalary,
    String? baseSalary,
    String? profileImage,
    String? status,

    // ✅ ADD THESE
    int? surveyCount,
    int? quotationCount,
    int? orderCount,
    int? lrCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      alternateMobile: alternateMobile ?? this.alternateMobile,
      loginCode: loginCode ?? this.loginCode,
      joiningDate: joiningDate ?? this.joiningDate,
      address: address ?? this.address,
      advanceSalary: advanceSalary ?? this.advanceSalary,
      baseSalary: baseSalary ?? this.baseSalary,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,

      // ✅ KEEP OLD IF NULL
      surveyCount: surveyCount ?? this.surveyCount,
      quotationCount: quotationCount ?? this.quotationCount,
      orderCount: orderCount ?? this.orderCount,
      lrCount: lrCount ?? this.lrCount,
    );
  }
}