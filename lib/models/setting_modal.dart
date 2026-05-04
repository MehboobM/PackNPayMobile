class SettingsModel {
  // 🔹 Watermark Fields
  final int wmQuotation;
  final int wmSurveyList;
  final int wmPackingList;
  final int wmLrBilty;
  final int wmCarCondition;
  final int wmBill;
  final int wmMoneyReceipt;
  final int wmPaymentVoucher;
  final int wmTwsForm;
  final int wmFovScfForm;
  final int wmNocLetter;
  final int wmLetterhead;

  // 🔹 Quotation Fields
  final int qtShowWatermark;
  final String? qtTheme;
  final String? qtTermsAndConditions;

  // 🔹 LR Bilty Fields
  final int lrShowWatermark;
  final int lrCommercialDesign;
  final int lrLandscapePdf;
  final String? lrTermsAndConditions;

  // 🔹 Letter Head Fields
  final int lhShowWatermark;
  final String? lhTheme;

  const SettingsModel({
    required this.wmQuotation,
    required this.wmSurveyList,
    required this.wmPackingList,
    required this.wmLrBilty,
    required this.wmCarCondition,
    required this.wmBill,
    required this.wmMoneyReceipt,
    required this.wmPaymentVoucher,
    required this.wmTwsForm,
    required this.wmFovScfForm,
    required this.wmNocLetter,
    required this.wmLetterhead,
    required this.qtShowWatermark,
    this.qtTheme,
    this.qtTermsAndConditions,
    required this.lrShowWatermark,
    required this.lrCommercialDesign,
    required this.lrLandscapePdf,
    this.lrTermsAndConditions,
    required this.lhShowWatermark,
    this.lhTheme,
  });

  /// 🔹 Factory Constructor
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      wmQuotation: _parseInt(json['wm_quotation']),
      wmSurveyList: _parseInt(json['wm_survey_list']),
      wmPackingList: _parseInt(json['wm_packing_list']),
      wmLrBilty: _parseInt(json['wm_lr_bilty']),
      wmCarCondition: _parseInt(json['wm_car_condition']),
      wmBill: _parseInt(json['wm_bill']),
      wmMoneyReceipt: _parseInt(json['wm_money_receipt']),
      wmPaymentVoucher: _parseInt(json['wm_payment_voucher']),
      wmTwsForm: _parseInt(json['wm_tws_form']),
      wmFovScfForm: _parseInt(json['wm_fov_scf_form']),
      wmNocLetter: _parseInt(json['wm_noc_letter']),
      wmLetterhead: _parseInt(json['wm_letterhead']),

      qtShowWatermark: _parseInt(json['qt_show_watermark']),
      qtTheme: json['qt_theme'],
      qtTermsAndConditions: json['qt_terms_and_conditions'],

      lrShowWatermark: _parseInt(json['lr_show_watermark']),
      lrCommercialDesign: _parseInt(json['lr_commercial_design']),
      lrLandscapePdf: _parseInt(json['lr_landscape_pdf']),
      lrTermsAndConditions: json['lr_terms_and_conditions'],

      lhShowWatermark: _parseInt(json['lh_show_watermark']),
      lhTheme: json['lh_theme'],
    );
  }

  /// 🔹 Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      // Watermark
      "wm_quotation": wmQuotation,
      "wm_survey_list": wmSurveyList,
      "wm_packing_list": wmPackingList,
      "wm_lr_bilty": wmLrBilty,
      "wm_car_condition": wmCarCondition,
      "wm_bill": wmBill,
      "wm_money_receipt": wmMoneyReceipt,
      "wm_payment_voucher": wmPaymentVoucher,
      "wm_tws_form": wmTwsForm,
      "wm_fov_scf_form": wmFovScfForm,
      "wm_noc_letter": wmNocLetter,
      "wm_letterhead": wmLetterhead,

      // Quotation
      "qt_show_watermark": qtShowWatermark,
      "qt_theme": qtTheme,
      "qt_terms_and_conditions": qtTermsAndConditions,

      // LR Bilty
      "lr_show_watermark": lrShowWatermark,
      "lr_commercial_design": lrCommercialDesign,
      "lr_landscape_pdf": lrLandscapePdf,
      "lr_terms_and_conditions": lrTermsAndConditions,

      // Letter Head
      "lh_show_watermark": lhShowWatermark,
      "lh_theme": lhTheme,
    };
  }

  /// 🔹 Payload for Watermark PUT API
  Map<String, dynamic> toWatermarkJson() {
    return {
      "wm_quotation": wmQuotation,
      "wm_survey_list": wmSurveyList,
      "wm_packing_list": wmPackingList,
      "wm_lr_bilty": wmLrBilty,
      "wm_car_condition": wmCarCondition,
      "wm_bill": wmBill,
      "wm_money_receipt": wmMoneyReceipt,
      "wm_payment_voucher": wmPaymentVoucher,
      "wm_tws_form": wmTwsForm,
      "wm_fov_scf_form": wmFovScfForm,
      "wm_noc_letter": wmNocLetter,
      "wm_letterhead": wmLetterhead,
    };
  }

  /// 🔹 Payload for Letter Head PUT API
  Map<String, dynamic> toLetterHeadJson({
    int? showWatermark,
    String? theme,
  }) {
    final Map<String, dynamic> data = {};

    if (showWatermark != null) {
      data["lh_show_watermark"] = showWatermark;
    }
    if (theme != null) {
      data["lh_theme"] = theme;
    }

    return data;
  }

  /// 🔹 Payload for Quotation PUT API
  Map<String, dynamic> toQuotationJson({
    int? showWatermark,
    String? theme,
    String? terms,
  }) {
    final Map<String, dynamic> data = {};

    if (showWatermark != null) {
      data["qt_show_watermark"] = showWatermark;
    }
    if (theme != null) {
      data["qt_theme"] = theme;
    }
    if (terms != null) {
      data["qt_terms_and_conditions"] = terms;
    }

    return data;
  }

  /// 🔹 Payload for LR Bilty PUT API
  Map<String, dynamic> toLRBiltyJson({
    int? showWatermark,
    int? commercialDesign,
    int? landscapePdf,
    String? terms,
  }) {
    final Map<String, dynamic> data = {};

    if (showWatermark != null) {
      data["lr_show_watermark"] = showWatermark;
    }
    if (commercialDesign != null) {
      data["lr_commercial_design"] = commercialDesign;
    }
    if (landscapePdf != null) {
      data["lr_landscape_pdf"] = landscapePdf;
    }
    if (terms != null) {
      data["lr_terms_and_conditions"] = terms;
    }

    return data;
  }

  /// 🔹 CopyWith Method
  SettingsModel copyWith({
    int? wmQuotation,
    int? wmSurveyList,
    int? wmPackingList,
    int? wmLrBilty,
    int? wmCarCondition,
    int? wmBill,
    int? wmMoneyReceipt,
    int? wmPaymentVoucher,
    int? wmTwsForm,
    int? wmFovScfForm,
    int? wmNocLetter,
    int? wmLetterhead,
    int? qtShowWatermark,
    String? qtTheme,
    String? qtTermsAndConditions,
    int? lrShowWatermark,
    int? lrCommercialDesign,
    int? lrLandscapePdf,
    String? lrTermsAndConditions,
    int? lhShowWatermark,
    String? lhTheme,
  }) {
    return SettingsModel(
      wmQuotation: wmQuotation ?? this.wmQuotation,
      wmSurveyList: wmSurveyList ?? this.wmSurveyList,
      wmPackingList: wmPackingList ?? this.wmPackingList,
      wmLrBilty: wmLrBilty ?? this.wmLrBilty,
      wmCarCondition: wmCarCondition ?? this.wmCarCondition,
      wmBill: wmBill ?? this.wmBill,
      wmMoneyReceipt: wmMoneyReceipt ?? this.wmMoneyReceipt,
      wmPaymentVoucher:
      wmPaymentVoucher ?? this.wmPaymentVoucher,
      wmTwsForm: wmTwsForm ?? this.wmTwsForm,
      wmFovScfForm: wmFovScfForm ?? this.wmFovScfForm,
      wmNocLetter: wmNocLetter ?? this.wmNocLetter,
      wmLetterhead: wmLetterhead ?? this.wmLetterhead,
      qtShowWatermark:
      qtShowWatermark ?? this.qtShowWatermark,
      qtTheme: qtTheme ?? this.qtTheme,
      qtTermsAndConditions:
      qtTermsAndConditions ?? this.qtTermsAndConditions,
      lrShowWatermark:
      lrShowWatermark ?? this.lrShowWatermark,
      lrCommercialDesign:
      lrCommercialDesign ?? this.lrCommercialDesign,
      lrLandscapePdf:
      lrLandscapePdf ?? this.lrLandscapePdf,
      lrTermsAndConditions:
      lrTermsAndConditions ?? this.lrTermsAndConditions,
      lhShowWatermark:
      lhShowWatermark ?? this.lhShowWatermark,
      lhTheme: lhTheme ?? this.lhTheme,
    );
  }

  /// 🔹 Helper Method to Safely Parse Integers
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}