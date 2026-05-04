import 'package:pack_n_pay/models/pagination.dart';

class QuotationListData {
  bool? success;
  List<QuotationList>? data;
  Pagination? pagination;

  QuotationListData({this.success, this.data, this.pagination});

  QuotationListData.fromJson(Map<String, dynamic> json) {
    // success is a bool, so we keep it as is
    success = json['success'];
    if (json['data'] != null) {
      data = <QuotationList>[];
      json['data'].forEach((v) {
        data!.add(new QuotationList.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class QuotationList {
  String? uid;
  String? quotationNo;
  String? customerName;
  String? phone;
  String? movingFrom;
  String? movingTo;
  String? quotationDate;
  String? totalAmount;
  String? advancePaid;
  String? balanceAmount;
  String? paymentStatus;
  String? totalPaid;
  String? surveyNo;
  String? lrNo;
  String? orderNo;

  QuotationList({
    this.uid,
    this.quotationNo,
    this.customerName,
    this.phone,
    this.movingFrom,
    this.movingTo,
    this.quotationDate,
    this.totalAmount,
    this.advancePaid,
    this.balanceAmount,
    this.paymentStatus,
    this.totalPaid,
    this.surveyNo,
    this.lrNo,
    this.orderNo,
  });

  /// SAFE FROM JSON: Converts all potential numbers to Strings
  QuotationList.fromJson(Map<String, dynamic> json) {
    uid = json['uid']?.toString();
    quotationNo = json['quotation_no']?.toString();
    customerName = json['customer_name']?.toString();
    phone = json['phone']?.toString();
    movingFrom = json['moving_from']?.toString();
    movingTo = json['moving_to']?.toString();
    quotationDate = json['quotation_date']?.toString();
    totalAmount = json['total_amount']?.toString();
    advancePaid = json['advance_paid']?.toString();
    balanceAmount = json['balance_amount']?.toString();
    paymentStatus = json['payment_status']?.toString();
    totalPaid = json['total_paid']?.toString();
    surveyNo = json['survey_no']?.toString();
    lrNo = json['lr_no']?.toString();
    orderNo = json['order_no']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['quotation_no'] = this.quotationNo;
    data['customer_name'] = this.customerName;
    data['phone'] = this.phone;
    data['moving_from'] = this.movingFrom;
    data['moving_to'] = this.movingTo;
    data['quotation_date'] = this.quotationDate;
    data['total_amount'] = this.totalAmount;
    data['advance_paid'] = this.advancePaid;
    data['balance_amount'] = this.balanceAmount;
    data['payment_status'] = this.paymentStatus;
    data['total_paid'] = this.totalPaid;
    data['survey_no'] = this.surveyNo;
    data['lr_no'] = this.lrNo;
    data['order_no'] = this.orderNo;
    return data;
  }
}