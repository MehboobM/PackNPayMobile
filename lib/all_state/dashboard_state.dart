import '../models/ActionList_model.dart';
import '../models/dashboard_model.dart';
import '../models/subscription_modal.dart';
import '../models/upcomming_ordermodel.dart'; // ✅ ADD THIS

class DashboardState {
  final bool isLoading;
  final bool isInitialLoading;
  final String? error;

  final DashboardModel? dashboard;
  final List<ActionItemModel> actions;
  final List<UpcomingOrderModel> upcomingOrders;

  final SubscriptionModel? subscription; // ✅ ADD THIS

  const DashboardState({
    this.isLoading = false,
    this.isInitialLoading = false,
    this.error,
    this.dashboard,
    this.actions = const [],
    this.upcomingOrders = const [],
    this.subscription, // ✅ ADD
  });

  DashboardState copyWith({
    bool? isLoading,
    bool? isInitialLoading,
    String? error,
    DashboardModel? dashboard,
    List<ActionItemModel>? actions,
    List<UpcomingOrderModel>? upcomingOrders,
    SubscriptionModel? subscription, // ✅ ADD
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      error: error,
      dashboard: dashboard ?? this.dashboard,
      actions: actions ?? this.actions,
      upcomingOrders: upcomingOrders ?? this.upcomingOrders,
      subscription: subscription ?? this.subscription, // ✅ ADD
    );
  }
}