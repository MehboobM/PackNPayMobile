

import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisiblePaymentField {
  final bool isFreightVisible;
  final bool isAdvanceVisible;
  final bool isPackingVisible;
  final bool isUnpackingVisible;
  final bool isLoadingVisible;

  const VisiblePaymentField({
    this.isFreightVisible = true,
    this.isAdvanceVisible = true,
    this.isPackingVisible = true,
    this.isUnpackingVisible = true,
    this.isLoadingVisible = true,
  });

  /// 🔥 optional: copyWith for easy updates
  VisiblePaymentField copyWith({
    bool? isFreightVisible,
    bool? isAdvanceVisible,
    bool? isPackingVisible,
    bool? isUnpackingVisible,
    bool? isLoadingVisible,
  }) {
    return VisiblePaymentField(
      isFreightVisible: isFreightVisible ?? this.isFreightVisible,
      isAdvanceVisible: isAdvanceVisible ?? this.isAdvanceVisible,
      isPackingVisible: isPackingVisible ?? this.isPackingVisible,
      isUnpackingVisible:
      isUnpackingVisible ?? this.isUnpackingVisible,
      isLoadingVisible: isLoadingVisible ?? this.isLoadingVisible,
    );
  }
}

final paymentVisibilityProvider = StateProvider<VisiblePaymentField>((ref) {return const VisiblePaymentField();});