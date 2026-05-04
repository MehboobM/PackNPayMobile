class DashboardModel {
  final Orders orders;
  final Surveys surveys;
  final Quotations quotations;
  final ProfitLoss profitLoss;

  DashboardModel({
    required this.orders,
    required this.surveys,
    required this.quotations,
    required this.profitLoss,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      orders: Orders.fromJson(json['orders']),
      surveys: Surveys.fromJson(json['surveys']),
      quotations: Quotations.fromJson(json['quotations']),
      profitLoss: ProfitLoss.fromJson(json['profit_loss']),
    );
  }
}

class Orders {
  final int total, pending, shiftingStarted, pickupCompleted, shiftingCompleted, settled, cancelled;

  Orders({
    required this.total,
    required this.pending,
    required this.shiftingStarted,
    required this.pickupCompleted,
    required this.shiftingCompleted,
    required this.settled,
    required this.cancelled,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      total: json['total'],
      pending: json['pending'],
      shiftingStarted: json['shifting_started'],
      pickupCompleted: json['pickup_completed'],
      shiftingCompleted: json['shifting_completed'],
      settled: json['settled'],
      cancelled: json['cancelled'],
    );
  }
}

class Surveys {
  final int total, pending, convertedQuotations;

  Surveys({
    required this.total,
    required this.pending,
    required this.convertedQuotations,
  });

  factory Surveys.fromJson(Map<String, dynamic> json) {
    return Surveys(
      total: json['total'],
      pending: json['pending'],
      convertedQuotations: json['converted_quotations'],
    );
  }
}

class Quotations {
  final int total, pending, convertedOrders, cancelled;

  Quotations({
    required this.total,
    required this.pending,
    required this.convertedOrders,
    required this.cancelled,
  });

  factory Quotations.fromJson(Map<String, dynamic> json) {
    return Quotations(
      total: json['total'],
      pending: json['pending'],
      convertedOrders: json['converted_orders'],
      cancelled: json['cancelled'],
    );
  }
}

class ProfitLoss {
  final int revenue, expenses, net;

  ProfitLoss({
    required this.revenue,
    required this.expenses,
    required this.net,
  });

  factory ProfitLoss.fromJson(Map<String, dynamic> json) {
    return ProfitLoss(
      revenue: json['revenue'],
      expenses: json['expenses'],
      net: json['net'],
    );
  }

  /// ✅ ADD THIS
  String get netText => net < 0 ? "-₹${net.abs()}" : "₹$net";

  /// ✅ OPTIONAL (very useful)
  bool get isLoss => net < 0;
}