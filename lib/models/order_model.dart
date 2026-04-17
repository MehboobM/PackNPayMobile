
import 'package:pack_n_pay/models/counts_model.dart';
import 'package:pack_n_pay/models/pagination.dart';

class OrderData {
  bool? success;
  List<OrderDataList>? orderList;
  Pagination? pagination;
  CountsModel? counts;

  OrderData({this.success, this.orderList, this.pagination, this.counts});

  OrderData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      orderList = <OrderDataList>[];
      json['data'].forEach((v) {
        orderList!.add(new OrderDataList.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    counts = json['counts'] != null ? new CountsModel.fromJson(json['counts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.orderList != null) {
      data['data'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.counts != null) {
      data['counts'] = this.counts!.toJson();
    }
    return data;
  }
}

class OrderDataList {
  String? uid;
  String? orderNo;
  String? orderStatus;
  String? shipmentStatus;
  String? vehicleNo;
  String? orderDate;
  String? deliveryDate;
  String? quotationNo;
  String? customerName;
  String? phone;
  String? movingFrom;
  String? movingTo;
  String? totalAmount;

  OrderDataList(
      {this.uid,
        this.orderNo,
        this.orderStatus,
        this.shipmentStatus,
        this.vehicleNo,
        this.orderDate,
        this.deliveryDate,
        this.quotationNo,
        this.customerName,
        this.phone,
        this.movingFrom,
        this.movingTo,
        this.totalAmount});

  OrderDataList.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    orderNo = json['order_no'];
    orderStatus = json['order_status'];
    shipmentStatus = json['shipment_status'];
    vehicleNo = json['vehicle_no'];
    orderDate = json['order_date'];
    deliveryDate = json['delivery_date'];
    quotationNo = json['quotation_no'];
    customerName = json['customer_name'];
    phone = json['phone'];
    movingFrom = json['moving_from'];
    movingTo = json['moving_to'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['order_no'] = this.orderNo;
    data['order_status'] = this.orderStatus;
    data['shipment_status'] = this.shipmentStatus;

    data['vehicle_no'] = this.vehicleNo;
    data['order_date'] = this.orderDate;
    data['delivery_date'] = this.deliveryDate;
    data['quotation_no'] = this.quotationNo;
    data['customer_name'] = this.customerName;
    data['phone'] = this.phone;
    data['moving_from'] = this.movingFrom;
    data['moving_to'] = this.movingTo;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}


