

const globalJson = {
  "_meta": {
    "project": "PackNPay Logistics",
    "description": "Centralized dropdown options for the entire PackNPay application",
    "version": "1.0.0",
    "generated_at": "2026-04-02",
    "note": "Keys match database column names/enum values. label is display text, value is stored value."
  },

  "floor": {
    "label": "Floor",
    "db_column": "floor",
    "options": [
      { "label": "Ground Floor", "value": "G" },
      { "label": "1st Floor", "value": "1" },
      { "label": "2nd Floor", "value": "2" },
      { "label": "3rd Floor", "value": "3" },
      { "label": "4th Floor", "value": "4" },
      { "label": "5th Floor", "value": "5" },
      { "label": "6th Floor", "value": "6" },
      { "label": "7th Floor", "value": "7" },
      { "label": "8th Floor", "value": "8" },
      { "label": "9th Floor", "value": "9" },
      { "label": "10th Floor", "value": "10" },
      { "label": "Above 10th Floor", "value": "10+" }
    ]
  },

  "lift_available": {
    "label": "Lift Available",
    "db_column": "lift_available",
    "db_enum": ["YES", "NO"],
    "options": [
      { "label": "Yes", "value": "YES" },
      { "label": "No", "value": "NO" }
    ]
  },

  "insurance_type": {
    "label": "Material Insurance Type",
    "db_column": "insurance_type",
    "options": [
      { "label": "Not Insured", "value": "not_insured" },
      { "label": "Insured", "value": "insured" },
      { "label": "Owner Risk", "value": "owner_risk" },
      { "label": "Carrier Risk", "value": "carrier_risk" },
      { "label": "Transit Insurance", "value": "transit_insurance" }
    ]
  },

  "insurance_charge_percent": {
    "label": "Insurance Charge (%)",
    "db_column": "insurance_charge_percent",
    "options": [
      { "label": "0%", "value": 0 },
      { "label": "1%", "value": 1 },
      { "label": "2%", "value": 2 },
      { "label": "3%", "value": 3 },
      { "label": "5%", "value": 5 },
    ],
  },



  "vehicle_insurance_type": {
    "label": "Vehicle Insurance Type",
    "db_column": "vehicle_insurance_type",
    "options": [
      { "label": "Not Insured", "value": "not_insured" },
      { "label": "Insured", "value": "insured" },
      { "label": "Owner Risk", "value": "owner_risk" },
      { "label": "Carrier Risk", "value": "carrier_risk" },
      { "label": "Comprehensive", "value": "comprehensive" }
    ]
  },

  "vehicle_insurance_charge_percent": {
    "label": "Vehicle Insurance Charge (%)",
    "db_column": "vehicle_insurance_charge_percent",
    "options": [
      { "label": "0%", "value": 0 },
      { "label": "1%", "value": 1 },
      { "label": "2%", "value": 2 },
      { "label": "3%", "value": 3 },
      { "label": "5%", "value": 5 },
    ],
  },

  "risk_type": {
    "label": "Risk Type",
    "db_column": "risk_type",
    "options": [
      { "label": "At Owner Risk", "value": "Owner Risk" },
      { "label": "At Carrier Risk", "value": "Carrier Risk" },
      { "label": "At Company Risk", "value": "Company Risk" }
    ]
  },

  "show_gst": {
    "label": "GST (Show or Hide on Quotation)",
    "db_column": "show_gst",
    "db_enum": ["YES", "NO"],
    "options": [
      { "label": "Yes", "value": "YES" },
      { "label": "No", "value": "NO" }
    ]
  },

  "gst_type": {
    "label": "GST Type",
    "db_column": "gst_type",
    "db_enum": ["CGST/SGST", "IGST"],
    "options": [
      { "label": "CGST/SGST", "value": "CGST/SGST" },
      { "label": "IGST", "value": "IGST" }
    ]
  },

  "gst_percent": {
    "label": "GST Percentage (%)",
    "db_column": "gst_percent",
    "options": [
      { "label": "0%", "value": 0 },
      { "label": "5%", "value": 5 },
      { "label": "12%", "value": 12 },
      { "label": "18%", "value": 18 },
      { "label": "28%", "value": 28 }
    ]
  },

  "lr_gst_percent": {
    "label": "GST % (LR)",
    "db_column": "gst_percent",
    "options": [
      { "label": "0%", "value": 0 },
      { "label": "5%", "value": 5 },
      { "label": "12%", "value": 12 },
      { "label": "18%", "value": 18 },
      { "label": "28%", "value": 28 }
    ]
  },

  "gst_paid_by": {
    "label": "GST Paid By",
    "db_column": "gst_paid_by",
    "options": [
      { "label": "Consignee", "value": "Consignee" },
      { "label": "Consignor", "value": "Consignor" },
      { "label": "Company", "value": "Company" }
    ]
  },

  "load_type": {
    "label": "Load Type",
    "db_column": "load_type",
    "options": [
      { "label": "Full Load (FTL)", "value": "FTL" },
      { "label": "Part Load (LTL)", "value": "LTL" },
      { "label": "Half Load", "value": "half_load" },
      { "label": "Single Item", "value": "single_item" }
    ]
  },

  "vehicle_type": {
    "label": "Vehicle Type",
    "db_column": "vehicle_type",
    "options": [
      { "label": "Tempo / Mini Truck", "value": "Tempo" },
      { "label": "14 ft Truck", "value": "14ft Truck" },
      { "label": "17 ft Truck", "value": "17ft Truck" },
      { "label": "20 ft Truck", "value": "20ft Truck" },
      { "label": "20 ft Container", "value": "20ft Container" },
      { "label": "32 ft Container", "value": "32ft Container" },
      { "label": "40 ft Container", "value": "40ft Container" },
      { "label": "Bike Transport", "value": "Bike Transport" },
      { "label": "Car Carrier", "value": "Car Carrier" }
    ]
  },

  "moving_path": {
    "label": "Moving Path",
    "db_column": "moving_path",
    "options": [
      { "label": "By Road", "value": "by_road" },
      { "label": "By Train", "value": "by_train" },
      { "label": "By Air", "value": "by_air" },
      { "label": "By Sea", "value": "by_sea" },
      { "label": "Road + Train", "value": "road_train" },
      { "label": "Road + Air", "value": "road_air" }
    ]
  },

  "payment_status": {
    "label": "Payment Status",
    "db_column": "payment_status",
    "options": [
      { "label": "Pending", "value": "PENDING" },
      { "label": "Partial", "value": "PARTIAL" },
      { "label": "Paid", "value": "PAID" },
      { "label": "Cancelled", "value": "CANCELLED" }
    ]
  },

  "charge_type": {
    "label": "Charge Type (Packing / Unpacking / Loading / Unloading / Packing Material)",
    "db_columns": [
      "packing_charge_type",
      "unpacking_charge_type",
      "loading_charge_type",
      "unloading_charge_type",
      "packing_material_charge_type"
    ],
    "options": [
      { "label": "Included in Freight", "value": "included" },
      { "label": "Extra Charge", "value": "extra" },
      { "label": "Not Applicable", "value": "not_applicable" }
    ]
  },

  "packing_charge_type": {
    "label": "Packing Charge Type",
    "db_column": "packing_charge_type",
    "options": [
      { "label": "Included in Freight", "value": "included" },
      { "label": "Extra Charge", "value": "extra" },
      { "label": "Not Applicable", "value": "not_applicable" }
    ]
  },

  "unpacking_charge_type": {
    "label": "Unpacking Charge Type",
    "db_column": "unpacking_charge_type",
    "options": [
      { "label": "Included in Freight", "value": "included" },
      { "label": "Extra Charge", "value": "extra" },
      { "label": "Not Applicable", "value": "not_applicable" }
    ]
  },

  "loading_charge_type": {
    "label": "Loading Charge Type",
    "db_column": "loading_charge_type",
    "options": [
      { "label": "Included in Freight", "value": "included" },
      { "label": "Extra Charge", "value": "extra" },
      { "label": "Not Applicable", "value": "not_applicable" }
    ]
  },

  "unloading_charge_type": {
    "label": "Unloading Charge Type",
    "db_column": "unloading_charge_type",
    "options": [
      { "label": "Included in Freight", "value": "included" },
      { "label": "Extra Charge", "value": "extra" },
      { "label": "Not Applicable", "value": "not_applicable" }
    ]
  },

  "packing_material_charge_type": {
    "label": "Packing Material Charge Type",
    "db_column": "packing_material_charge_type",
    "options": [
      { "label": "Included in Freight", "value": "included" },
      { "label": "Extra Charge", "value": "extra" },
      { "label": "Not Applicable", "value": "not_applicable" }
    ]
  },

  "surcharge_type": {
    "label": "Surcharge Type",
    "db_column": "surcharge_type",
    "options": [
      { "label": "Not Applicable", "value": "not_applicable" },
      { "label": "Included in Freight", "value": "included" },
      { "label": "Extra Charge", "value": "extra" }
    ]
  },

  "payment_mode": {
    "label": "Payment Mode",
    "db_column": "payment_mode",
    "tables": ["money_receipts", "quotation_payments"],
    "db_enum_money_receipts": ["Cash", "Cheque", "Online", "UPI", "NEFT", "RTGS"],
    "db_enum_quotation_payments": ["CASH", "CHEQUE", "ONLINE", "UPI", "NEFT", "RTGS"],
    "options": [
      { "label": "Cash", "value": "Cash" },
      { "label": "Cheque", "value": "Cheque" },
      { "label": "Online", "value": "Online" },
      { "label": "UPI", "value": "UPI" },
      { "label": "NEFT", "value": "NEFT" },
      { "label": "RTGS", "value": "RTGS" }
    ]
  },

  "receipt_against": {
    "label": "Receipt Against",
    "db_column": "receipt_against",
    "db_enum": ["Quotation", "LR", "Invoice"],
    "options": [
      { "label": "Quotation", "value": "Quotation" },
      { "label": "LR / Bilty", "value": "LR" },
      { "label": "Invoice", "value": "Invoice" }
    ]
  },

  "payment_type": {
    "label": "Payment Type",
    "db_column": "payment_type",
    "db_enum": ["Full", "Part", "Advance"],
    "options": [
      { "label": "Full Payment", "value": "Full" },
      { "label": "Part Payment", "value": "Part" },
      { "label": "Advance", "value": "Advance" }
    ]
  },

  "order_status": {
    "label": "Order Status",
    "db_column": "order_status",
    "db_enum": ["ORDER_CONFIRMED", "LR_BILTY", "MONEY_RECEIPT", "SETTLED"],
    "options": [
      { "label": "Order Confirmed", "value": "ORDER_CONFIRMED" },
      { "label": "LR / Bilty", "value": "LR_BILTY" },
      { "label": "Money Receipt", "value": "MONEY_RECEIPT" },
      { "label": "Settled", "value": "SETTLED" }
    ]
  },

  "shipment_status": {
    "label": "Shipment Status",
    "db_column": "shipment_status",
    "db_enum": ["SHIFTING_STARTED", "PICKUP_COMPLETED", "SHIFTING_COMPLETED", "SETTLED"],
    "options": [
      { "label": "Shifting Started", "value": "SHIFTING_STARTED" },
      { "label": "Pickup Completed", "value": "PICKUP_COMPLETED" },
      { "label": "Shifting Completed", "value": "SHIFTING_COMPLETED" },
      { "label": "Settled", "value": "SETTLED" }
    ]
  },

  "easy_access": {
    "label": "Easy Access",
    "db_column": "easy_access",
    "options": [
      { "label": "Yes", "value": "yes" },
      { "label": "No", "value": "no" },
      { "label": "Partially", "value": "partial" }
    ]
  },

  "loading_restrictions": {
    "label": "Loading Restrictions",
    "db_column": "loading_restrictions",
    "options": [
      { "label": "None", "value": "none" },
      { "label": "Time Restricted", "value": "time_restricted" },
      { "label": "No Heavy Vehicle", "value": "no_heavy_vehicle" },
      { "label": "Narrow Lane", "value": "narrow_lane" },
      { "label": "Permit Required", "value": "permit_required" }
    ]
  },

  "unloading_restrictions": {
    "label": "Unloading Restrictions",
    "db_column": "unloading_restrictions",
    "options": [
      { "label": "None", "value": "none" },
      { "label": "Time Restricted", "value": "time_restricted" },
      { "label": "No Heavy Vehicle", "value": "no_heavy_vehicle" },
      { "label": "Narrow Lane", "value": "narrow_lane" },
      { "label": "Permit Required", "value": "permit_required" }
    ]
  },

  "weight_unit": {
    "label": "Weight Unit",
    "db_column": "actual_weight / charged_weight unit",
    "options": [
      { "label": "KG", "value": "KG" },
      { "label": "Ton", "value": "TON" },
      { "label": "LBS", "value": "LBS" }
    ]
  },

  "demurrage_charge_type": {
    "label": "Demurrage Charge Type",
    "db_column": "charge_type",
    "options": [
      { "label": "Per Day", "value": "per_day" },
      { "label": "Per Hour", "value": "per_hour" },
      { "label": "Fixed", "value": "fixed" }
    ]
  },

  "demurrage_applicable_rule": {
    "label": "Demurrage Charge Applicable",
    "db_column": "applicable_rule",
    "options": [
      { "label": "More than 1 Day", "value": "more_than_1_day" },
      { "label": "More than 2 Days", "value": "more_than_2_days" },
      { "label": "More than 3 Days", "value": "more_than_3_days" },
      { "label": "More than 5 Days", "value": "more_than_5_days" },
      { "label": "More than 7 Days", "value": "more_than_7_days" },
      { "label": "More than 10 Days", "value": "more_than_10_days" }
    ]
  },

  "user_role": {
    "label": "User Role",
    "db_column": "role",
    "db_enum": ["SuperAdmin", "Admin", "Staff", "Manager", "Supervisor", "Labour", "Vendor"],
    "options": [
      { "label": "Super Admin", "value": "SuperAdmin" },
      { "label": "Admin", "value": "Admin" },
      { "label": "Manager", "value": "Manager" },
      { "label": "Supervisor", "value": "Supervisor" },
      { "label": "Staff", "value": "Staff" },
      { "label": "Labour", "value": "Labour" },
      { "label": "Vendor", "value": "Vendor" }
    ]
  },

  "record_status": {
    "label": "Record Status",
    "db_column": "status",
    "db_enum": ["ACTIVE", "INACTIVE", "DELETED"],
    "options": [
      { "label": "Active", "value": "ACTIVE" },
      { "label": "Inactive", "value": "INACTIVE" },
      { "label": "Deleted", "value": "DELETED" }
    ]
  },

  "media_type": {
    "label": "Media Type",
    "db_column": "media_type",
    "db_enum": ["PACKING", "UNPACKING"],
    "options": [
      { "label": "Packing", "value": "PACKING" },
      { "label": "Unpacking", "value": "UNPACKING" }
    ]
  },

  "address_type": {
    "label": "Address Type",
    "options": [
      { "label": "Pickup", "value": "PICKUP" },
      { "label": "Delivery", "value": "DELIVERY" }
    ]
  },

  "lr_address_type": {
    "label": "LR Address Type",
    "db_column": "type",
    "db_enum": ["FROM", "TO"],
    "options": [
      { "label": "From (Consignor)", "value": "FROM" },
      { "label": "To (Consignee)", "value": "TO" }
    ]
  },

  "country": {
    "label": "Country",
    "db_column": "country",
    "options": [
      { "label": "India", "value": "India" }
    ]
  },

  "toast_position": {
    "label": "Toast Notification Position",
    "db_column": "toast_position",
    "options": [
      { "label": "Top Right", "value": "top-right" },
      { "label": "Top Left", "value": "top-left" },
      { "label": "Top Center", "value": "top-center" },
      { "label": "Bottom Right", "value": "bottom-right" },
      { "label": "Bottom Left", "value": "bottom-left" },
      { "label": "Bottom Center", "value": "bottom-center" }
    ]
  }
};