



import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';

class AuthRepository {
  final NetworkHandler network;

  AuthRepository(this.network);


  Future<Map<String, dynamic>> generateOtp(String mobile) async {
    final response = await network.post(
      ApiEndPoints.sendOtp,
      {
        "mobile": mobile,   // ✅ send in body
      },
    );
    return response.data;
  }

  // VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    final response = await network.post(
      ApiEndPoints.verifyOtp,
      {
        "mobile": mobile,
        "otp": otp
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("OTP verification failed");
    }
  }


  Future<Map<String, dynamic>> register({
    required String name,
    required String mobile,
    required String email,
    required String otp,
  }) async {
    final response = await network.post(
      ApiEndPoints.register,
        {
          "name": name,
          "mobile": mobile,
          "email": email,
          "otp" : otp
        },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("OTP verification failed");
    }
  }

}
