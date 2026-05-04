
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
        data!.add(SurveyList.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
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

  SurveyList({
    this.id,
    this.uid,
    this.date,
    this.customer,
    this.phone,
    this.location,
    this.items,
    this.flag,
    this.quotation,
    this.status,
  });

  SurveyList.fromJson(Map<String, dynamic> json) {
    // Safely convert to String in case the API returns numbers
    id = json['id']?.toString();
    uid = json['uid']?.toString();
    date = json['date']?.toString();
    customer = json['customer']?.toString();
    phone = json['phone']?.toString();
    location = json['location']?.toString();
    
    // Safely parse int for items
    if (json['items'] is int) {
      items = json['items'];
    } else if (json['items'] != null) {
      items = int.tryParse(json['items'].toString());
    }
    
    flag = json['flag']?.toString();
    quotation = json['quotation']?.toString();
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['date'] = date;
    data['customer'] = customer;
    data['phone'] = phone;
    data['location'] = location;
    data['items'] = items;
    data['flag'] = flag;
    data['quotation'] = quotation;
    data['status'] = status;
    return data;
  }
}
