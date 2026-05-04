class ProfileModel {
  final int id;
  final String uid;
  final String? username;
  final String name;
  final String? email;
  final String mobile;
  final String? state;
  final String? city;
  final String? pincode;
  final String? address;
  final String? profileImage;
  final String role;
  final String status;
  final String? dob;
  final String createdAt;

  ProfileModel({
    required this.id,
    required this.uid,
    this.username,
    required this.name,
    this.email,
    required this.mobile,
    this.state,
    this.city,
    this.pincode,
    this.address,
    this.profileImage,
    required this.role,
    required this.status,
    this.dob,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      uid: json['uid'] ?? "",
      username: json['username'],
      name: json['name'] ?? "",
      email: json['email'],
      mobile: json['mobile'] ?? "",
      state: json['state'],
      city: json['city'],
      pincode: json['pincode'],
      address: json['address'],
      profileImage: json['profile_image'],
      role: json['role'] ?? "",
      status: json['status'] ?? "",
      dob: json['dob'],
      createdAt: json['created_at'] ?? "",
    );
  }
}