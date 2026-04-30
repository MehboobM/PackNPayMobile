import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pack_n_pay/api_services/service_constants.dart';

import '../database/shared_preferences/shared_storage.dart';
import 'api_end_points.dart';

class NetworkHandler {
  static final NetworkHandler _instance = NetworkHandler._internal();
  NetworkHandler._internal();
  factory NetworkHandler() => _instance;

  Future<Response> get(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).get(
        url, // ✅ only endpoint
        queryParameters: queryParams,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      print("get method exception is $e");
      rethrow;
    }
  }

  Future<Response> post(String url, dynamic body) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).post(
        url, // ✅ only endpoint
        data: body,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> delete(String url, dynamic body) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).delete(
        url, // ✅ only endpoint
        data: body,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> put(String url, dynamic body) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).put(
        url, // ✅ only endpoint
        data: body,
      );
    } on DioException {
      rethrow;
    }
  }
  Future<Response> patch(String url, dynamic body) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).patch(
        url,
        data: body,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> putMultipart(
      String url, {
        required Map<String, dynamic> body,
        Map<String, File>? files,
      }) async {
    try {
      final token = await StorageService().getToken();

      final formData = FormData.fromMap({
        ...body,
        if (files != null)
          ...files.map(
                (key, file) => MapEntry(
              key,
              MultipartFile.fromFileSync(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          ),
      });

      return await ServicesConstant.instanceDio(token).put(
        url, // ✅ only endpoint
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } on DioException catch (e) {
      print("PUT MULTIPART ERROR: ${e.response}");
      rethrow;
    } catch (e) {
      print("PUT MULTIPART EXCEPTION: $e");
      rethrow;
    }
  }
  Future<Response> postMultipart(
      String url, {
        required Map<String, dynamic> body,
        Map<String, File>? files,
      }) async {
    try {
      final token = await StorageService().getToken();

      final formData = FormData.fromMap({
        ...body,

        if (files != null)
          ...files.map(
                (key, file) => MapEntry(
              key,
              MultipartFile.fromFileSync(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          ),
      });

      return await ServicesConstant.instanceDio(token).post(
        url, // ✅ only endpoint
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } on DioException catch (e) {
      print("POST MULTIPART ERROR: ${e.response}");
      rethrow;
    } catch (e) {
      print("POST MULTIPART EXCEPTION: $e");
      rethrow;
    }
  }
}

/*class NetworkHandler {
  static final NetworkHandler _instance = NetworkHandler._internal();
  NetworkHandler._internal();
  factory NetworkHandler() => _instance;

  Future<Response> get(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).get(
        ApiEndPoints.baseurl + url,
        queryParameters: queryParams,
      );
    } on DioException {
      rethrow;
    }catch(e){
      print("get method exception is $e");
      rethrow;
    }
  }

  Future<Response> post(String url, dynamic body) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).post(
        ApiEndPoints.baseurl + url,
        data: body,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> delete(String url, dynamic body) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).delete(
        ApiEndPoints.baseurl + url,
        data: body,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> put(String url, dynamic body) async {
    try {
      final token = await StorageService().getToken();
      return await ServicesConstant.instanceDio(token).put(
        ApiEndPoints.baseurl + url,
        data: body,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> putMultipart(
      String url, {
        required Map<String, dynamic> body,
        Map<String, File>? files,
      }) async {
    try {
      final token = await StorageService().getToken();

      final formData = FormData.fromMap({
        ...body,
        if (files != null)
          ...files.map(
                (key, file) => MapEntry(
              key,
              MultipartFile.fromFileSync(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          ),
      });

      return await ServicesConstant.instanceDio(token).put(
        ApiEndPoints.baseurl + url,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } on DioException catch (e) {
      print("PUT MULTIPART ERROR: ${e.response}");
      rethrow;
    } catch (e) {
      print("PUT MULTIPART EXCEPTION: $e");
      rethrow;
    }
  }


}*/
