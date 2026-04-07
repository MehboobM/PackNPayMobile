


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global_data/dropdown_data.dart';

final dropdownProvider =
StateNotifierProvider<DropdownNotifier, Map<String, dynamic>>(
      (ref) => DropdownNotifier(),
);

class DropdownNotifier extends StateNotifier<Map<String, dynamic>> {
  DropdownNotifier() : super(globalJson);

  /// 🔹 Get full dropdown by key
  Map<String, dynamic>? getDropdown(String key) {
    return state[key];
  }

  /// 🔹 Get only options list
  List<dynamic> getOptions(String key) {
    return state[key]?['options'] ?? [];
  }

  /// 🔹 Get label list (for UI)
  List<String> getLabels(String key) {
    final options = getOptions(key);
    return options.map<String>((e) => e['label'].toString()).toList();
  }

  /// 🔹 Get value list (for API)
  List<dynamic> getValues(String key) {
    final options = getOptions(key);
    return options.map((e) => e['value']).toList();
  }


  /// 🔹 Convert value -> label
  String? getLabelByValue(String key, dynamic value) {
    final options = getOptions(key);

    final match = options.cast<Map<String, dynamic>>().firstWhere(
          (e) => e['value'] == value,
      orElse: () => {}, // ✅ FIX
    );

    return match.isEmpty ? null : match['label'];
  }

  /// 🔹 Convert label -> value
  dynamic getValueByLabel(String key, String label) {
    final options = getOptions(key);

    final match = options.cast<Map<String, dynamic>>().firstWhere(
          (e) => e['label'] == label,
      orElse: () => {}, // ✅ FIX
    );

    return match.isEmpty ? null : match['value'];
  }

}