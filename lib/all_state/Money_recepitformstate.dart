class MoneyReceiptFormState {
  final bool isLoading;
  final bool isEdit;
  final Map<String, dynamic>? data;

  const MoneyReceiptFormState({
    this.isLoading = false,
    this.isEdit = false,
    this.data,
  });

  MoneyReceiptFormState copyWith({
    bool? isLoading,
    bool? isEdit,
    Map<String, dynamic>? data,
  }) {
    return MoneyReceiptFormState(
      isLoading: isLoading ?? this.isLoading,
      isEdit: isEdit ?? this.isEdit,
      data: data ?? this.data,
    );
  }
}