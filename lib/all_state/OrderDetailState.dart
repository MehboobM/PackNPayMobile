

import 'package:pack_n_pay/models/order_detail_model.dart';

class OrderDetailState {
  final bool isPageLoading;
  final OrderDetailModel? orderData;

  OrderDetailState({
    this.isPageLoading = false,
    this.orderData,
  });

  OrderDetailState copyWith({
    bool? isPageLoading,
    OrderDetailModel? orderData,
  }) {
    return OrderDetailState(
      isPageLoading: isPageLoading ?? this.isPageLoading,
      orderData: orderData ?? this.orderData,
    );
  }
}