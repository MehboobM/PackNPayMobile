
class OrderDetailModel {
  bool? success;
  DetailData? data;

  OrderDetailModel({this.success, this.data});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new DetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
//json['existing_order_no'] ?? json['order_no'];
class DetailData {
  int? id;
  String? quotationId;
  String? quotationNo;
  int? companyId;
  String? existingOrderUid;
  String? existingOrderNo;
  String? customerName;
  String? phone;
  String? email;
  String? companyOrPartyName;
  String? partyName;
  String? gstNo;
  String? movingFrom;
  String? movingTo;
  String? quotationDate;
  String? packingDate;
  String? deliveryDate;
  String? loadType;
  String? vehicleType;
  String? movingPath;
  String? remarks;
  String? freightCharge;
  String? packingCharge;
  String? unpackingCharge;
  String? loadingCharge;
  String? unloadingCharge;
  String? packingMaterialCharge;
  String? advancePaid;
  String? storageCharge;
  String? carBikeTpt;
  String? miscCharge;
  String? otherCharges;
  String? stCharge;
  String? surcharge;
  String? gstAmount;
  String? gstPercent;
  String? gstType;
  String? totalAmount;
  String? balanceAmount;
  String? insuranceType;
  String? insuranceCharge;
  String? insuranceGst;
  String? declarationOfGoods;
  String? vehicleInsuranceType;
  String? vehicleInsuranceCharge;
  String? vehicleInsuranceGst;
  String? declarationOfVehicle;

  String? vehicleNo;
  String? driverName;
  String? driverPhone;
  String? driverLicense;
  String? shipmenStatus;//"shipment_status"

  String? easyAccess;
  String? balconyItems;
  String? loadingRestrictions;
  String? unloadingRestrictions;
  String? specialNeeds;
  List<StatusLogs>? statusLogs;
  List<StatusTimeline>? statusTimeline;

  QuotationAddresses? quotationAddresses;
  String? surveyUid;
  List<SurveyItems>? surveyItems;
  List<CustomItems>? customItems;
  Media? media;
  LinkedQuotation? linkedQuotation;
  List<Expenses>? expenses;
  PaymentSummary? paymentSummary;
  List<Staff>? staff;
  List<Staff>? labour;

  DetailData(
      {
        this.id,
        this.quotationId,
        this.quotationNo,
        this.companyId,
        this.existingOrderUid,
        this.existingOrderNo,
        this.customerName,
        this.phone,
        this.email,
        this.companyOrPartyName,
        this.partyName,
        this.gstNo,
        this.movingFrom,
        this.movingTo,
        this.quotationDate,
        this.packingDate,
        this.deliveryDate,
        this.loadType,
        this.vehicleType,
        this.movingPath,
        this.remarks,
        this.freightCharge,
        this.packingCharge,
        this.unpackingCharge,
        this.loadingCharge,
        this.unloadingCharge,
        this.packingMaterialCharge,
        this.advancePaid,
        this.storageCharge,
        this.carBikeTpt,
        this.miscCharge,
        this.otherCharges,
        this.stCharge,
        this.surcharge,
        this.gstAmount,
        this.gstPercent,
        this.gstType,
        this.totalAmount,
        this.balanceAmount,
        this.insuranceType,
        this.insuranceCharge,
        this.insuranceGst,
        this.declarationOfGoods,
        this.vehicleInsuranceType,
        this.vehicleInsuranceCharge,
        this.vehicleInsuranceGst,
        this.declarationOfVehicle,

        this.vehicleNo,
        this.driverName,
        this.driverPhone,
        this.driverLicense,
        this.shipmenStatus,

        this.easyAccess,
        this.balconyItems,
        this.loadingRestrictions,
        this.unloadingRestrictions,
        this.specialNeeds,
        this.statusLogs,
        this.statusTimeline,
        this.quotationAddresses,
        this.surveyUid,
        this.surveyItems,
        this.customItems,
        this.media,
        this.linkedQuotation,
        this.expenses,
        this.paymentSummary,
        this.staff,
        this.labour,
      });

 // "uid": "TVL-OR-0008",
  DetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    quotationNo = json['quotation_no'];
    companyId = json['company_id'];
    existingOrderUid = json['existing_order_uid'] ?? json['uid'];

    existingOrderNo = json['existing_order_no'] ?? json['order_no'];

    customerName = json['customer_name'];
    phone = json['phone'];
    email = json['email'];
    companyOrPartyName = json['company_or_party_name'];
    partyName = json['party_name'];
    gstNo = json['gst_no'];
    movingFrom = json['moving_from'];
    movingTo = json['moving_to'];
    quotationDate = json['quotation_date'];
    packingDate = json['packing_date'];
    deliveryDate = json['delivery_date'];
    loadType = json['load_type'];
    vehicleType = json['vehicle_type'];
    movingPath = json['moving_path'];
    remarks = json['remarks'];
    freightCharge = json['freight_charge'];
    packingCharge = json['packing_charge'];
    unpackingCharge = json['unpacking_charge'];
    loadingCharge = json['loading_charge'];
    unloadingCharge = json['unloading_charge'];
    packingMaterialCharge = json['packing_material_charge'];
    advancePaid = json['advance_paid'];
    storageCharge = json['storage_charge'];
    carBikeTpt = json['car_bike_tpt'];
    miscCharge = json['misc_charge'];
    otherCharges = json['other_charges'];
    stCharge = json['st_charge'];
    surcharge = json['surcharge'];
    gstAmount = json['gst_amount'];
    gstPercent = json['gst_percent'];
    gstType = json['gst_type'];
    totalAmount = json['total_amount'];
    balanceAmount = json['balance_amount'];
    insuranceType = json['insurance_type'];
    insuranceCharge = json['insurance_charge'];
    insuranceGst = json['insurance_gst'];
    declarationOfGoods = json['declaration_of_goods'];
    vehicleInsuranceType = json['vehicle_insurance_type'];
    vehicleInsuranceCharge = json['vehicle_insurance_charge'];
    vehicleInsuranceGst = json['vehicle_insurance_gst'];
    declarationOfVehicle = json['declaration_of_vehicle'];

    vehicleNo = json['vehicle_no'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    driverLicense = json['driver_license'];
    shipmenStatus = json['shipment_status'];

    easyAccess = json['easy_access'];
    balconyItems = json['balcony_items'];
    loadingRestrictions = json['loading_restrictions'];
    unloadingRestrictions = json['unloading_restrictions'];
    specialNeeds = json['special_needs'];
    if (json['status_logs'] != null) {
      statusLogs = <StatusLogs>[];
      json['status_logs'].forEach((v) {
        statusLogs!.add(new StatusLogs.fromJson(v));
      });
    }

    if (json['status_timeline'] != null) {
      statusTimeline = <StatusTimeline>[];
      json['status_timeline'].forEach((v) {
        statusTimeline!.add(new StatusTimeline.fromJson(v));
      });
    }

    quotationAddresses = json['quotation_addresses'] != null
        ? new QuotationAddresses.fromJson(json['quotation_addresses'])
        : null;
    surveyUid = json['survey_uid'];

    if (json['survey_items'] != null) {
      surveyItems = <SurveyItems>[];
      json['survey_items'].forEach((v) {
        surveyItems!.add(new SurveyItems.fromJson(v));
      });
    }
    if (json['custom_items'] != null) {
      customItems = <CustomItems>[];
      json['custom_items'].forEach((v) {
        customItems!.add(new CustomItems.fromJson(v));
      });
    }

    media = json['media'] != null ? new Media.fromJson(json['media']) : null;

    linkedQuotation = json['linked_quotation'] != null
        ? new LinkedQuotation.fromJson(json['linked_quotation'])
        : null;

    if (json['expenses'] != null) {
      expenses = <Expenses>[];
      json['expenses'].forEach((v) {
        expenses!.add(new Expenses.fromJson(v));
      });
    }

    paymentSummary = json['payment_summary'] != null
        ? new PaymentSummary.fromJson(json['payment_summary'])
        : null;

    if (json['staff'] != null) {
      staff = <Staff>[];
      json['staff'].forEach((v) {
        staff!.add(Staff.fromJson(v));
      });
    }

    if (json['labour'] != null) {
      labour = <Staff>[]; // ✅ FIX
      json['labour'].forEach((v) {
        labour!.add(Staff.fromJson(v)); // ✅ FIX
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['quotation_no'] = this.quotationNo;
    data['company_id'] = this.companyId;
    data['existing_order_uid'] = this.existingOrderUid;
    data['existing_order_no'] = this.existingOrderNo;
    data['customer_name'] = this.customerName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['company_or_party_name'] = this.companyOrPartyName;
    data['party_name'] = this.partyName;
    data['gst_no'] = this.gstNo;
    data['moving_from'] = this.movingFrom;
    data['moving_to'] = this.movingTo;
    data['quotation_date'] = this.quotationDate;
    data['packing_date'] = this.packingDate;
    data['delivery_date'] = this.deliveryDate;
    data['load_type'] = this.loadType;
    data['vehicle_type'] = this.vehicleType;
    data['moving_path'] = this.movingPath;
    data['remarks'] = this.remarks;
    data['freight_charge'] = this.freightCharge;
    data['packing_charge'] = this.packingCharge;
    data['unpacking_charge'] = this.unpackingCharge;
    data['loading_charge'] = this.loadingCharge;
    data['unloading_charge'] = this.unloadingCharge;
    data['packing_material_charge'] = this.packingMaterialCharge;
    data['advance_paid'] = this.advancePaid;
    data['storage_charge'] = this.storageCharge;
    data['car_bike_tpt'] = this.carBikeTpt;
    data['misc_charge'] = this.miscCharge;
    data['other_charges'] = this.otherCharges;
    data['st_charge'] = this.stCharge;
    data['surcharge'] = this.surcharge;
    data['gst_amount'] = this.gstAmount;
    data['gst_percent'] = this.gstPercent;
    data['gst_type'] = this.gstType;
    data['total_amount'] = this.totalAmount;
    data['balance_amount'] = this.balanceAmount;
    data['insurance_type'] = this.insuranceType;
    data['insurance_charge'] = this.insuranceCharge;
    data['insurance_gst'] = this.insuranceGst;
    data['declaration_of_goods'] = this.declarationOfGoods;
    data['vehicle_insurance_type'] = this.vehicleInsuranceType;
    data['vehicle_insurance_charge'] = this.vehicleInsuranceCharge;
    data['vehicle_insurance_gst'] = this.vehicleInsuranceGst;
    data['declaration_of_vehicle'] = this.declarationOfVehicle;

    data['vehicle_no'] = this.vehicleNo;
    data['driver_name'] = this.driverName;
    data['driver_phone'] = this.driverPhone;
    data['driver_license'] = this.driverLicense;
    data['shipment_status'] = this.shipmenStatus;
    data['easy_access'] = this.easyAccess;
    data['balcony_items'] = this.balconyItems;
    data['loading_restrictions'] = this.loadingRestrictions;
    data['unloading_restrictions'] = this.unloadingRestrictions;
    data['special_needs'] = this.specialNeeds;
    if (this.statusLogs != null) {
      data['status_logs'] = this.statusLogs!.map((v) => v.toJson()).toList();
    }

    if (this.statusTimeline != null) {
      data['status_timeline'] =
          this.statusTimeline!.map((v) => v.toJson()).toList();
    }
    if (this.quotationAddresses != null) {
      data['quotation_addresses'] = this.quotationAddresses!.toJson();
    }
    data['survey_uid'] = this.surveyUid;
    if (this.surveyItems != null) {
      data['survey_items'] = this.surveyItems!.map((v) => v.toJson()).toList();
    }
    if (this.customItems != null) {
      data['custom_items'] = this.customItems!.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    if (this.linkedQuotation != null) {
      data['linked_quotation'] = this.linkedQuotation!.toJson();
    }

    if (this.expenses != null) {
      data['expenses'] = this.expenses!.map((v) => v.toJson()).toList();
    }

    if (this.paymentSummary != null) {
      data['payment_summary'] = this.paymentSummary!.toJson();
    }

    if (this.staff != null) {
      data['staff'] = this.staff!.map((v) => v.toJson()).toList();
    }
    if (this.labour != null) {
      data['labour'] = this.labour!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Staff {
  int? userId;
  String? roleLabel;
  String? name;
  String? mobile;
  String? role;

  Staff({this.userId, this.roleLabel, this.name, this.mobile, this.role});

  Staff.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleLabel = json['role_label'];
    name = json['name'];
    mobile = json['mobile'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['role_label'] = this.roleLabel;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
    return data;
  }
}

//status log
class StatusLogs {
  int? id;
  int? orderId;
  String? statusType;
  String? status;
  int? changedBy;
  String? changedAt;

  StatusLogs(
      {this.id,
        this.orderId,
        this.statusType,
        this.status,
        this.changedBy,
        this.changedAt});

  StatusLogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    statusType = json['status_type'];
    status = json['status'];
    changedBy = json['changed_by'];
    changedAt = json['changed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['status_type'] = this.statusType;
    data['status'] = this.status;
    data['changed_by'] = this.changedBy;
    data['changed_at'] = this.changedAt;
    return data;
  }
}
class QuotationAddresses {
  Pickup? pickup;
  Pickup? delivery;

  QuotationAddresses({this.pickup, this.delivery});

  QuotationAddresses.fromJson(Map<String, dynamic> json) {
    pickup =
    json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    delivery =
    json['delivery'] != null ? new Pickup.fromJson(json['delivery']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.delivery != null) {
      data['delivery'] = this.delivery!.toJson();
    }
    return data;
  }
}

class Pickup {
  int? id;
  int? quotationId;
  String? type;
  String? email;
  String? phone;
  String? alternatePhone;
  String? state;
  String? city;
  String? pincode;
  String? floor;
  String? liftAvailable;
  String? address;
  String? movingDate;
  String? createdAt;
  int? createdBy;
  String? updatedAt;
  String? updatedBy;
  String? deletedAt;
  String? deletedBy;
  int? isActive;
  String? status;
  String? stateName;
  String? cityName;

  Pickup(
      {this.id,
        this.quotationId,
        this.type,
        this.email,
        this.phone,
        this.alternatePhone,
        this.state,
        this.city,
        this.pincode,
        this.floor,
        this.liftAvailable,
        this.address,
        this.movingDate,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy,
        this.deletedAt,
        this.deletedBy,
        this.isActive,
        this.status,
        this.stateName,
        this.cityName});

  Pickup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    type = json['type'];
    email = json['email'];
    phone = json['phone'];
    alternatePhone = json['alternate_phone'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    floor = json['floor'];
    liftAvailable = json['lift_available'];
    address = json['address'];
    movingDate = json['moving_date'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    deletedBy = json['deleted_by'];
    isActive = json['is_active'];
    status = json['status'];
    stateName = json['state_name'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['type'] = this.type;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['alternate_phone'] = this.alternatePhone;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['floor'] = this.floor;
    data['lift_available'] = this.liftAvailable;
    data['address'] = this.address;
    data['moving_date'] = this.movingDate;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['deleted_at'] = this.deletedAt;
    data['deleted_by'] = this.deletedBy;
    data['is_active'] = this.isActive;
    data['status'] = this.status;
    data['state_name'] = this.stateName;
    data['city_name'] = this.cityName;
    return data;
  }
}

class LinkedQuotation {
  String? quotationUid;
  String? quotationNo;
  String? quotationDate;

  LinkedQuotation({this.quotationUid, this.quotationNo, this.quotationDate});

  LinkedQuotation.fromJson(Map<String, dynamic> json) {
    quotationUid = json['quotation_uid'];
    quotationNo = json['quotation_no'];
    quotationDate = json['quotation_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quotation_uid'] = this.quotationUid;
    data['quotation_no'] = this.quotationNo;
    data['quotation_date'] = this.quotationDate;
    return data;
  }
}

class SurveyItems {
  int? id;
  int? itemId;
  int? quantity;
  String? cft;
  int? installation;
  int? uninstallation;
  Null? remarks;
  String? itemName;
  int? shiftingCharge;
  int? installationCharge;
  int? uninstallationCharge;
  String? categoryName;

  SurveyItems(
      {this.id,
        this.itemId,
        this.quantity,
        this.cft,
        this.installation,
        this.uninstallation,
        this.remarks,
        this.itemName,
        this.shiftingCharge,
        this.installationCharge,
        this.uninstallationCharge,
        this.categoryName});

  SurveyItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    quantity = json['quantity'];
    cft = json['cft'];
    installation = json['installation'];
    uninstallation = json['uninstallation'];
    remarks = json['remarks'];
    itemName = json['item_name'];
    shiftingCharge = json['shifting_charge'];
    installationCharge = json['installation_charge'];
    uninstallationCharge = json['uninstallation_charge'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['quantity'] = this.quantity;
    data['cft'] = this.cft;
    data['installation'] = this.installation;
    data['uninstallation'] = this.uninstallation;
    data['remarks'] = this.remarks;
    data['item_name'] = this.itemName;
    data['shifting_charge'] = this.shiftingCharge;
    data['installation_charge'] = this.installationCharge;
    data['uninstallation_charge'] = this.uninstallationCharge;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class CustomItems {
  int? id;
  String? itemName;
  int? quantity;

  CustomItems({this.id, this.itemName, this.quantity});

  CustomItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_name'] = this.itemName;
    data['quantity'] = this.quantity;
    return data;
  }
}


class Media {
  List<PackingUnpacking>? packing;
  List<PackingUnpacking>? unpacking;

  Media({this.packing, this.unpacking});

  Media.fromJson(Map<String, dynamic> json) {
    if (json['packing'] != null) {
      packing = <PackingUnpacking>[];
      json['packing'].forEach((v) {
        packing!.add(new PackingUnpacking.fromJson(v));
      });
    }
    if (json['unpacking'] != null) {
      unpacking = <PackingUnpacking>[];
      json['unpacking'].forEach((v) {
        unpacking!.add(new PackingUnpacking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.packing != null) {
      data['packing'] = this.packing!.map((v) => v.toJson()).toList();
    }
    if (this.unpacking != null) {
      data['unpacking'] = this.unpacking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PackingUnpacking {
  int? id;
  String? mediaType;
  String? filePath;

  PackingUnpacking({this.id, this.mediaType, this.filePath});

  PackingUnpacking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaType = json['media_type'];
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['media_type'] = this.mediaType;
    data['file_path'] = this.filePath;
    return data;
  }
}

class Expenses {
  int? id;
  int? categoryId;
  String? amount;
  String? categoryName;

  Expenses({this.id, this.categoryId, this.amount, this.categoryName});

  Expenses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    amount = json['amount'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['amount'] = this.amount;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class PaymentSummary {
  int? baseFare;
  int? taxesAndSurcharges;
  int? advancePayment;
  int? expenses;
  int? totalAmountToPay;

  PaymentSummary(
      {this.baseFare,
        this.taxesAndSurcharges,
        this.advancePayment,
        this.expenses,
        this.totalAmountToPay});

  PaymentSummary.fromJson(Map<String, dynamic> json) {
    baseFare = json['base_fare'];
    taxesAndSurcharges = json['taxes_and_surcharges'];
    advancePayment = json['advance_payment'];
    expenses = json['expenses'];
    totalAmountToPay = json['total_amount_to_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_fare'] = this.baseFare;
    data['taxes_and_surcharges'] = this.taxesAndSurcharges;
    data['advance_payment'] = this.advancePayment;
    data['expenses'] = this.expenses;
    data['total_amount_to_pay'] = this.totalAmountToPay;
    return data;
  }
}


class StatusTimeline {
  String? key;
  String? label;
  bool? done;

  StatusTimeline({this.key, this.label, this.done});

  StatusTimeline.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['label'] = this.label;
    data['done'] = this.done;
    return data;
  }
}