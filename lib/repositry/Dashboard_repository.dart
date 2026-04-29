import 'package:pack_n_pay/api_services/api_end_points.dart';

import '../api_services/network_handler.dart';
import '../database/shared_preferences/shared_storage.dart';
import '../models/ActionList_model.dart';
import '../models/dashboard_model.dart';
import '../models/subscription_modal.dart';
import '../models/upcomming_ordermodel.dart';
import '../notification/local_notification_service.dart';

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
  // Future<List<ActionItemModel>> getActions() async {
  //   final companyId = await StorageService().getCompanyId();
  //
  //   final response = await NetworkHandler().get(
  //     ApiEndPoints.getActions,
  //     queryParams: {
  //       "company_id": companyId ?? 1,
  //     },
  //   );
  //
  //   final data = response.data;
  //
  //   if (data['success']) {
  //     return (data['data'] as List)
  //         .map((e) => ActionItemModel.fromJson(e))
  //         .toList();
  //   } else {
  //     throw Exception("Failed to load actions");
  //   }
  // }

  Future<List<ActionItemModel>> getActions() async {
    final companyId = await StorageService().getCompanyId();

    final response = await NetworkHandler().get(
      ApiEndPoints.getActions,
      queryParams: {"company_id": companyId ?? 1},
    );

    final data = response.data;

    if (data['success']) {
      final list = (data['data'] as List)
          .map((e) => ActionItemModel.fromJson(e))
          .toList();

      /// ✅ SAFE DATE PARSER
      DateTime safeParse(String? d) {
        return DateTime.tryParse(d ?? "") ?? DateTime.now();
      }

      final now = DateTime.now();

      /// ✅ ONLY FUTURE FOLLOW-UPS
      final filteredList = list.where((item) {
        return safeParse(item.date).isAfter(now);
      }).toList();

      /// ✅ SORT BY DATE
      filteredList.sort(
            (a, b) => safeParse(a.date).compareTo(safeParse(b.date)),
      );

      /// ✅ TAKE TOP 2
      final topTwo = filteredList.take(2).toList();

      /// ✅ FORMAT TIME
      String twoDigit(int n) => n.toString().padLeft(2, '0');

      /// ✅ SEND NOTIFICATIONS
      for (int i = 0; i < topTwo.length; i++) {
        final item = topTwo[i];

        final date = safeParse(item.date);

        final formattedDate =
            "${date.day}/${date.month}/${date.year} "
            "${twoDigit(date.hour)}:${twoDigit(date.minute)}";

        final location =
            "${item.from.isNotEmpty ? item.from : '-'} → ${item.to.isNotEmpty ? item.to : '-'}";

        await LocalNotificationService.showNotification(
          id: int.tryParse(item.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? i,
          title: "Follow-up (${item.type})",
          body: "$location\n$formattedDate",
        );
      }

      return list;
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