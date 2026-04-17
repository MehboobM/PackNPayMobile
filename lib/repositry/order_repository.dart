



import 'package:pack_n_pay/models/order_model.dart';

import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';

class OrderRepository {
  final NetworkHandler network;

  OrderRepository(this.network);

  Future<OrderData> fetchOrderList({
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
        ApiEndPoints.orderList,
        queryParams: params,
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return OrderData.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchSurveyById(String surveyId) async {
    try {
      final response = await network.get(
        "${ApiEndPoints.prefillFormApi}/$surveyId",
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']; // ✅ return only data
      } else {
        throw Exception("Failed to fetch");
      }
    } catch (e) {
      rethrow;
    }
  }

}
