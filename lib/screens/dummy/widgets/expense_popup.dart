import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class ExpensesPopup extends ConsumerStatefulWidget {
  const ExpensesPopup({super.key});

  @override
  ConsumerState<ExpensesPopup> createState() => _ExpensesPopupState();
}

class _ExpensesPopupState extends ConsumerState<ExpensesPopup> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> expenses = [
    {"title": "Fuel & Vehicle Expenses", "controller": TextEditingController()},
    {"title": "Labor & Wages", "controller": TextEditingController()},
    {"title": "Packing Materials", "controller": TextEditingController()},
    {"title": "Packing Materials", "controller": TextEditingController()},
  ];

  bool isSummaryExpanded = true;

  double get totalExpenses {
    double sum = 0;
    for (var item in expenses) {
      sum += double.tryParse(item["controller"].text) ?? 0;
    }
    return sum;
  }

  @override
  void dispose() {
    searchController.dispose();
    for (var item in expenses) {
      item["controller"].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16), // Reduced top padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Expenses", style: TextStyles.f14w600Gray9),
                    IconButton(
                      icon: const Icon(Icons.close,color: Colors.grey,size: 18,),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                /// Search Field
                CustomTextField(
                  controller: searchController,
                  hintText: "search & add expense",
                  borderRadius: 8,
                  hintStyle: TextStyles.f12w400Gray5,
                  onChanged: (value) => setModalState(() {}),
                ),

                const SizedBox(height: 8),

                /// Primary Divider with Arrows
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_right,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_left,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                /// Expense List
                ...List.generate(expenses.length, (index) {
                  final item = expenses[index];

                  if (searchController.text.isNotEmpty &&
                      !item["title"].toLowerCase().contains(
                          searchController.text.toLowerCase())) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Text("${index + 1}.",
                            style: TextStyles.f12w500Gray7),
                        const SizedBox(width: 6),

                        /// Title
                        Text(item["title"],
                            style: TextStyles.f12w500Gray7),

                        /// Connecting Line
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(width: 8),

                        /// Amount Field
                        SizedBox(
                          width: 70,
                          height: 32,
                          child: TextField(
                            controller: item["controller"],
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setModalState(() {}),
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: "₹0",
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                /// Divider Above Summary
          const Divider(height: 2, thickness: 1),

                /// Expense Summary Header with Gradient
          Padding(
          padding: EdgeInsets.zero, // Removes unwanted outer spacing
          child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          /// Gradient Title
          Expanded(
          child: Container(
          padding: const EdgeInsets.symmetric(
          vertical: 6, // Reduced height
          horizontal: 6,
          ),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: const LinearGradient(
          colors: [
          Color(0xFF026BC9),
          Colors.white,
          ],
          stops: [0.0, 0.9],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          ),
          ),
          child:  Text(
          "EXPENSE SUMMARY",
          style: TextStyles.f10w500mWhite
          ),
          ),
          ),

          /// Orange Accent Line
          Container(
          width: 90,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          color: Colors.orange,
          ),

          /// Expand / Collapse Icon
          IconButton(
          icon: Icon(
          isSummaryExpanded
          ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
          size: 18,
          ),
          padding: EdgeInsets.zero, // Removes default padding
          constraints: const BoxConstraints(), // Removes extra space
          splashRadius: 18,
          visualDensity: VisualDensity.compact,
          onPressed: () {
          setModalState(() {
          isSummaryExpanded = !isSummaryExpanded;
          });
          },
          ),
          ],
          ),
          ),

                /// Summary Content
                if (isSummaryExpanded) ...[
                  _summaryRow("Base Fare", 5000),
                  _summaryRow("Taxes and Surcharges", 1000),
                  _summaryRow("Advance Payment", -2000),
                  _summaryRow("Expenses", -totalExpenses),
                  const SizedBox(height: 2),
                  const Divider(height: 4, thickness: 1),
                  _summaryRow(
                    "Total Amount to pay",
                    5000 + 1000 - 2000 - totalExpenses,
                    isTotal: true,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(String title, double amount,
      {bool isTotal = false}) {
    final isNegative = amount < 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isTotal ? 10 : 11,
                fontWeight:
                isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            "${isNegative ? "- " : ""}₹ ${amount.abs().toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: isTotal ? 13 : 12,
              fontWeight:
              isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? AppColors.primary
                  : isNegative
                  ? Colors.deepOrange
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}