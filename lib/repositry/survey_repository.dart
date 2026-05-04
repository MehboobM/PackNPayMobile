





import '../api_services/api_end_points.dart';
import '../api_services/network_handler.dart';
import '../models/survey_list_data.dart';

class SurveyRepository {
  final NetworkHandler network;

  SurveyRepository(this.network);

  Future<SurveyData> fetchSurveyList({
    int page = 1,
    String? fromDate,
    String? toDate,
    String? status, // ✅ ADD
    String? sort,
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
      /// ✅ STATUS FILTER
      if (status != null && status.isNotEmpty) {
        params["status"] = status;
      }
      /// ✅ SORT FILTER
      if (sort != null && sort.isNotEmpty) {
        params["sort_by"] = "created_at";
        params["sort_order"] = sort; // new / old
      }

      final response = await network.get(
        ApiEndPoints.surveylistApi,
        queryParams: params,
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return SurveyData.fromJson(response.data);
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

  Future<String?> generateSurveyLink() async {
    try {
      final url = ApiEndPoints.generateEncoded;

      print("👉 API URL: $url");

      final response = await network.post(url,{});

      print("👉 STATUS CODE: ${response.statusCode}");
      print("👉 RESPONSE DATA: ${response.data}");

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final encoded = response.data['encoded'];
        print("✅ ENCODED: $encoded");
        return encoded;
      } else {
        print("❌ API FAILED: ${response.data}");
        throw Exception("Failed to generate link");
      }
    } catch (e, stack) {
      print("🔥 EXCEPTION: $e");
      print("📍 STACK: $stack");
      return null;
    }
  }

}
