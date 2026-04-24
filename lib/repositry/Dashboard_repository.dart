import 'package:pack_n_pay/api_services/api_end_points.dart';

import '../api_services/network_handler.dart';
import '../database/shared_preferences/shared_storage.dart';
import '../models/ActionList_model.dart';
import '../models/dashboard_model.dart';
import '../models/subscription_modal.dart';
import '../models/upcomming_ordermodel.dart';

class DashboardService {
  Future<DashboardModel> getDashboard() async {
    final companyId = await StorageService().getCompanyId();

    final response = await NetworkHandler().get(
      ApiEndPoints.getSummaray,
      queryParams: {
        "company_id": companyId ?? 1,
      },
    );

    final data = response.data;

    if (data['success']) {
      return DashboardModel.fromJson(data['data']);
    } else {
      throw Exception("Failed to load dashboard");
    }
  }
  Future<List<ActionItemModel>> getActions() async {
    final companyId = await StorageService().getCompanyId();

    final response = await NetworkHandler().get(
      ApiEndPoints.getActions,
      queryParams: {
        "company_id": companyId ?? 1,
      },
    );

    final data = response.data;

    if (data['success']) {
      return (data['data'] as List)
          .map((e) => ActionItemModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load actions");
    }
  }
  Future<List<UpcomingOrderModel>> getUpcomingOrders({
    int page = 1,
    int limit = 10,
  }) async {
    final companyId = await StorageService().getCompanyId();

    final response = await NetworkHandler().get(
      ApiEndPoints.getupcomingOrders,
      queryParams: {
        "company_id": companyId ?? 1,
        "page": page,
        "limit": limit,
      },
    );

    final data = response.data;

    if (data['success']) {
      final list = data['data']['data'] as List;

      return list
          .map((e) => UpcomingOrderModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load upcoming orders");
    }
  }
  Future<Map<String, int>> getCalendarData({
    required int year,
    required int month,
  }) async {
    final companyId = await StorageService().getCompanyId();

    final response = await NetworkHandler().get(
      ApiEndPoints.getcalender,
      queryParams: {
        "year": year,
        "month": month,
        "company_id": companyId ?? 1,
      },
    );

    final data = response.data;

    if (data['success']) {
      final events = data['data']['calendar_events'] as Map<String, dynamic>;

      return events.map((key, value) {
        return MapEntry(
          key,
          value['order_count'] ?? 0, // ✅ IMPORTANT FIX
        );
      });
    } else {
      throw Exception("Failed to load calendar");
    }
  }
  Future<SubscriptionModel> getSubscription() async {
    final response = await NetworkHandler().get(
      ApiEndPoints.subscription,
    );

    final data = response.data;

    if (data['success']) {
      return SubscriptionModel.fromJson(data['data']);
    } else {
      throw Exception("Failed to load subscription");
    }
  }
}