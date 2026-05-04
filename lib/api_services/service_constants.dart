import 'package:dio/dio.dart';
import 'api_end_points.dart';
import 'app_interceptors.dart';

class ServicesConstant {
  static Dio instanceDio(String? token) {

    print("get token >>>>>>>>>>>>>>>>>>>>>>>>$token");
    Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoints.baseurl, // ✅ ADD THIS
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      ),
    );

    dio.interceptors
      ..add(AppInterceptors(token))
      ..add(LogInterceptor(responseBody: true, requestBody: true));

    return dio;
  }
}

// class ServicesConstant {
//
//   static Dio instanceDio(String? token) {
//     Dio dio = Dio();
//     dio.interceptors..add(AppInterceptors(token))
//     ..add(LogInterceptor(responseBody: true, requestBody: true));
//
//     return dio;
//   }
// }