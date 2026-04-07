

import 'package:pack_n_pay/models/pagination.dart';

class SurveyData {
  bool? success;
  List<SurveyList>? data;
  Pagination? pagination;

  SurveyData({this.success, this.data, this.pagination});

  SurveyData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <SurveyList>[];
      json['data'].forEach((v) {
        data!.add(new SurveyList.fromJson(v));
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

class SurveyList {
  String? id;
  String? uid;
  String? date;
  String? customer;
  String? phone;
  String? location;
  int? items;
  String? flag;
  String? quotation;
  String? status;

  SurveyList(
      {this.id,
        this.uid,
        this.date,
        this.customer,
        this.phone,
        this.location,
        this.items,
        this.flag,
        this.quotation,
        this.status});

  SurveyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    date = json['date'];
    customer = json['customer'];
    phone = json['phone'];
    location = json['location'];
    items = json['items'];
    flag = json['flag'];
    quotation = json['quotation'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['date'] = this.date;
    data['customer'] = this.customer;
    data['phone'] = this.phone;
    data['location'] = this.location;
    data['items'] = this.items;
    data['flag'] = this.flag;
    data['quotation'] = this.quotation;
    data['status'] = this.status;
    return data;
  }
}


