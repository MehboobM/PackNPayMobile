import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_state/dashboard_state.dart';
import '../models/ActionList_model.dart';
import '../models/dashboard_model.dart';
import '../models/subscription_modal.dart';
import '../models/upcomming_ordermodel.dart';
import '../repositry/Dashboard_repository.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardService repository;

  DashboardNotifier(this.repository)
      : super(const DashboardState()) {
    fetchAll();
  }

  /// 🔹 Load Dashboard + Actions + Orders + Subscription
  Future<void> fetchAll() async {
    state = state.copyWith(
      isLoading: true,
      isInitialLoading: true,
      error: null,
    );

    DashboardModel? dashboardData;
    List<ActionItemModel> actionsData = [];
    List<UpcomingOrderModel> upcomingData = [];
    SubscriptionModel? subscriptionData;

    /// 🔹 Dashboard
    try {
      dashboardData = await repository.getDashboard();
    } catch (e) {
      print("❌ Dashboard API failed");
    }

    /// 🔹 Actions
    try {
      actionsData = await repository.getActions();
    } catch (e) {
      print("❌ Actions API failed");
    }

    /// 🔹 Upcoming Orders
    try {
      upcomingData = await repository.getUpcomingOrders();
    } catch (e) {
      print("❌ Upcoming Orders API failed");
    }

    /// 🔹 Subscription
    try {
      subscriptionData = await repository.getSubscription();
    } catch (e) {
      print("❌ Subscription API failed");
    }

    /// ✅ Always update UI (no global failure)
    state = state.copyWith(
      isLoading: false,
      isInitialLoading: false,
      dashboard: dashboardData,
      actions: actionsData,
      upcomingOrders: upcomingData,
      subscription: subscriptionData,
    );
  }

  /// 🔹 Refresh only dashboard
  Future<void> refreshDashboard() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final dashboardData = await repository.getDashboard();

      state = state.copyWith(
        isLoading: false,
        dashboard: dashboardData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to refresh dashboard",
      );
    }
  }

  /// 🔹 Refresh only actions
  Future<void> refreshActions() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final actionsData = await repository.getActions();

      state = state.copyWith(
        isLoading: false,
        actions: actionsData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to refresh actions",
      );
    }
  }
}

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(
    DashboardService(),
  ),
);