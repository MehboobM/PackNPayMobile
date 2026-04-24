

import 'dart:developer';

import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/city_data.dart';
import '../models/quatation_list_data.dart';
import '../models/state_data.dart';



class QuatationRepository {
  final NetworkHandler network;

  QuatationRepository(this.network);

  Future<QuotationListData> fetchQuatation({
    int page = 1,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final Map<String, dynamic> params = {
        "page": page,
        "limit": 10,
      };

      if (fromDate != null && toDate != null) {
        params["from_date"] = fromDate;
        params["to_date"] = toDate;
      }

      final response = await network.get(
        ApiEndPoints.quatationApi,
        queryParams: params,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return QuotationListData.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ FIXED STATE API
  Future<StateData> fetchStates() async {
    try {
      final response = await network.get(ApiEndPoints.stateApi);

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return StateData.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch states");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ FIXED CITY API
  Future<CityData> fetchCities(int stateId) async {
    try {
      final response = await network.get(
        ApiEndPoints.cityApi,
        queryParams: {"state_id": stateId},
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return CityData.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch cities");
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<dynamic> createQuotation(Map<String, dynamic> body) async {
    try {
      final response = await network.post(
        ApiEndPoints.createQuotationApi, body,
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        return response.data;
      } else {
        throw Exception("Failed to create quotation");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteQuotation(String quotationNo) async {
    try {
      final response = await network.delete("${ApiEndPoints.deleteQuotationApi}/$quotationNo",{});

      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchQuotationByUid(String uid) async {
    try {
      final response = await network.get(
        "${ApiEndPoints.getQuotationApi}?uid=$uid",
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception("Failed to fetch quotation");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateQuotation(String uid, Map<String, dynamic> body,String? keyType) async {
    try {
      final response;
      if(keyType== "edit_click_from_survey") {
         response = await network.post("${ApiEndPoints.createQuotationApi}/$uid", body,);
      }else{
         response = await network.put("${ApiEndPoints.updateQuotationApi}/$uid", body,);
      }

      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      }
      else if(keyType== "edit_click_from_survey" && response.statusCode == 201){
        return true;
      }
      else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}