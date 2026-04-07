

import 'package:hive/hive.dart';

import '../../models/quatation_form_model.dart';

class HiveService {
  static final box = Hive.box('quotationBox');

  /// SAVE
  static Future<void> save(QuotationFormModel data) async {
    await box.put('form', data.toJson());
  }

  /// GET
  static QuotationFormModel? get() {
    final json = box.get('form');
    if (json == null) return null;

    return QuotationFormModel.fromJson(Map<String, dynamic>.from(json));
  }

  /// CLEAR
  static Future<void> clear() async {
    await box.delete('form');
  }
}