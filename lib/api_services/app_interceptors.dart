import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
/*
class AppInterceptors extends Interceptor {
  final String? token;
  AppInterceptors(this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.sendTimeout = const Duration(seconds: 15);
    options.connectTimeout = const Duration(seconds: 60);
    options.followRedirects = true;

    /// Accept header is OK
    options.headers[Headers.acceptHeader] = "application/json";

    /// 🔥 DO NOT force content-type
    /// Dio will set:
    /// - application/json for normal requests
    /// - multipart/form-data for FormData
    options.headers.remove(Headers.contentTypeHeader);

    if (token != null && token!.isNotEmpty) {
      options.headers['auth-token'] = token!;
    }

    /// 🔍 Print FormData properly
    final data = options.data;
    if (data is FormData) {
      debugPrint('--- FormData fields ---');
      for (final field in data.fields) {
        debugPrint('${field.key}: ${field.value}');
      }

      debugPrint('--- FormData files ---');
      for (final file in data.files) {
        debugPrint(
          '${file.key}: '
              '${file.value.filename}',
        );
      }
    } else {
      debugPrint('Request body: $data');
    }

    super.onRequest(options, handler);
  }
}
*/

class AppInterceptors extends Interceptor {
  final String? token;

  AppInterceptors(this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    /// ✅ Proper timeout (balanced UX)
    options.connectTimeout = const Duration(seconds: 10);
    options.sendTimeout = const Duration(seconds: 10);
    options.receiveTimeout = const Duration(seconds: 10);

    /// ✅ Redirect behavior
    options.followRedirects = true;

    /// ✅ Default headers (only if not already present)
    options.headers.putIfAbsent(
        Headers.acceptHeader, () => "application/json");
    options.headers.putIfAbsent(
        Headers.contentTypeHeader, () => "application/json");

    /// ✅ Authorization header
    if (token != null && token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  /// ✅ Handle errors globally (VERY IMPORTANT)
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      print("⏰ Connection Timeout");
    } else if (err.type == DioExceptionType.receiveTimeout) {
      print("📥 Receive Timeout");
    } else if (err.type == DioExceptionType.sendTimeout) {
      print("📤 Send Timeout");
    } else if (err.type == DioExceptionType.connectionError) {
      print("❌ No Internet / Server Down");
    } else if (err.response?.statusCode == 401) {
      print("🔐 Unauthorized - Token expired");
      // 👉 Optional: logout user
    }

    super.onError(err, handler);
  }
}

// class AppInterceptors extends Interceptor {
//   String? token;
//   AppInterceptors(this.token);
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     /// Create Time out for sending
//   //  options.sendTimeout = 15 * 1000;
//     /// Create Time out for Connect
//    // options.connectTimeout = 10 * 1000;
//
//
//     /// Create Time out for sending
//     options.sendTimeout = const Duration(milliseconds: 15 * 1000);
//
//     /// Create Time out for Connect
//     options.connectTimeout = const Duration(milliseconds: 60 * 1000);
//
//     /// Redirects true
//     options.followRedirects = true;
//     /// Add Header Accepted
//     options.headers.addAll({
//       Headers.acceptHeader: "application/json",
//       Headers.contentTypeHeader: "application/json"
//     });
//     if(token !=null && token!.isNotEmpty){
//       options.headers['Authorization'] = 'Bearer $token';
//      // options.headers['auth-token'] = '$token';
//     }
//
//     return super.onRequest(options,handler);
//   }
// }