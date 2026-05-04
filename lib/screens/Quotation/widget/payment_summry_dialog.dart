

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_widget/custom_button.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/quotation_form_notifier.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';
import 'insurance_and_other_form.dart';

class PaymentSummaryDialog extends ConsumerStatefulWidget {
  const PaymentSummaryDialog({super.key});

  @override
  ConsumerState<PaymentSummaryDialog> createState() =>
      _PaymentSummaryDialogState();
}

class _PaymentSummaryDialogState extends ConsumerState<PaymentSummaryDialog> {

  late TextEditingController discountController;

  late TextEditingController advanceController;

  @override
  void initState() {
    super.initState();
    final data = ref.read(quotationFormProvider);
    discountController = TextEditingController(text: data.summaryDiscount ?? "");
    advanceController =
        TextEditingController(text: data.advancePaid ?? "");
  }

  String? selectedStatus = null;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(quotationFormProvider.notifier);
    final calc = notifier.calculateSummary();


    final dropdown = ref.read(dropdownProvider.notifier);

    final statusItem = dropdown.getLabels("payment_status");
    final selectedStatusLabel = dropdown.getLabelByValue("payment_status", selectedStatus);


    Widget row(String title, double value, {bool isTotal = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: isTotal
                  ? TextStyles.f16w600Black8
                  : TextStyles.f12w600mBlack,
            ),
            Text(
              "₹ ${value.toStringAsFixed(0)}",
              style: isTotal
                  ? TextStyles.f16w600Black8.copyWith(
                color: AppColors.primary,
              )
                  : TextStyles.f14w600mGray9,
            ),
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.mWhite,

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Summary",
                      style: TextStyles.f18w600Black8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
        
              /// 🔥 ADVANCE INPUT
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Advanced Payment",
                    style: TextStyles.f12w600mBlack),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: advanceController,
                      hintText: "Enter advance amount",
                      keyboardType: TextInputType.number,
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                    ),
                  ),
                  const SizedBox(width: 10),
        
                  /// APPLY BUTTON
                  CustomButton(
                    width: 80,
                    height: 44,
                    text: "Add",
                    iconRight: true,
                    onPressed: () {
                      ref.read(quotationFormProvider.notifier).updateAdvance(advanceController.text);
        
                      setState(() {}); // refresh calculation
                    },
                    backgroundColor: AppColors.primarySecond, // orange like figma
                    borderRadius: 12,
                  )
                ],
              ),
        
              Divider(color: AppColors.mGray3),
        
              /// VALUES
              row("Base Fare", calc["baseFare"]!),
              row("Taxes & Charges", calc["taxes"]!),
              row("Advance Paid", calc["advance"]!),
        
              const SizedBox(height: 6),
        
              Row(
                children: [
                  reusableDropdown(
                    title: "Payment status",
                    textStle:TextStyles.f12w600mBlack,
                    isRequired: false,
                    value: selectedStatusLabel,
                    items: statusItem,
                    onChanged: (label) {
                      final val = dropdown.getValueByLabel("payment_status", label ?? "");
        
                      setState(() {
                        selectedStatus = val;
                      });
        
                      /// ✅ ADD THIS
                      ref.read(quotationFormProvider.notifier).state.paymentStatus = val;
                    },
                  ),
                ],
              ),
        
              /// 🔥 DISCOUNT INPUT
              const SizedBox(height: 10),
        
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Apply Discount",
                    style: TextStyles.f12w600mBlack),
              ),
        
              const SizedBox(height: 4),
        
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: discountController,
                      hintText: "Enter Name",
                      onChanged: (val){
                        ref.read(quotationFormProvider.notifier).updateCompany(val);
                      },
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    width: 80,
                    height: 44,
                    text: "Apply",
                    iconRight: true,
                    onPressed: () {
                      notifier.updateDiscount(discountController.text);
                      setState(() {});
                    },
                    backgroundColor: AppColors.primarySecond,
                    borderRadius: 12,
                  )
                ],
              ),
        
              const SizedBox(height: 10),
        
              row("Discount", calc["discount"]!),
        
              Divider(color: AppColors.mGray3),
        
              row("Total Amount to pay", calc["total"]!, isTotal: true),
        
              const SizedBox(height: 16),
        
              /// DONE BUTTON
              SizedBox(
                width: double.infinity,
                child:
                CustomButton(
                  text: "Done",
                  iconRight: true,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  backgroundColor: AppColors.primary,
                  borderRadius: 12,
                )
        
              )
            ],
          ),
        ),
      ),
    );
  }
}