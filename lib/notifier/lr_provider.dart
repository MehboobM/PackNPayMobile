import 'package:flutter_riverpod/flutter_riverpod.dart';

final lrFormDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});
void updateFormData(WidgetRef ref, Map<String, dynamic> data) {
  final existing = ref.read(lrFormDataProvider);
  ref.read(lrFormDataProvider.notifier).state = {
    ...existing,
    ...data,
  };
}