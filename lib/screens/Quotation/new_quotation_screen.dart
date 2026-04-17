import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/Quotation/widget/Quotation_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/insurance_and_other_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/moving_details_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/payment_detail_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/payment_summry_dialog.dart';
import 'package:pack_n_pay/screens/Quotation/widget/quotation_stepper.dart';
import '../../database/hive_database/hive_quation_form.dart';
import '../../global_widget/custom_button.dart';
import '../../notifier/quatation_notifier.dart';
import '../../notifier/quotation_form_notifier.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';

class NewQuotationScreen extends ConsumerStatefulWidget {
   final String? keyType;
   final String? uid;
   NewQuotationScreen({super.key, required this.keyType,this.uid});

  @override
  ConsumerState<NewQuotationScreen> createState() => _NewQuotationScreenState();
}

class _NewQuotationScreenState extends ConsumerState<NewQuotationScreen> {
  int currentStep = 0;
  void nextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget buildStepBody() {
    switch (currentStep) {
    /// STEP 0
      case 0:
        return  QuotationDetailsForm();
    /// STEP 1
      case 1:
        return MovingDetailsForm();
    /// STEP 2
      case 2:
        return PaymentDetailForm();
    /// STEP 2
      case 3:
        return InsuranceAndOtherForm();
      default:
        return const SizedBox();
    }
  }

  void openPaymentSummary(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 👈 keyboard height
          ),
          child: const PaymentSummaryDialog(),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: true,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: previousStep,
        ),

        title: Text(
          "New Quotation",
          style: TextStyles.f16w600mGray9,
        ),

        actions: [
          if(currentStep == 2)
           Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(120, 34),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                openPaymentSummary(context);
              },
              icon: const Icon(Icons.calculate_outlined, size: 18, color: AppColors.mWhite),
              label: Text("Calculate", style: TextStyles.f12w400mWhite),
            ),
          )
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: QuotationStepper(
            currentStep: currentStep,
            onStepTapped: (index) {
              final notifier = ref.read(quotationFormProvider.notifier);
              /// 🔒 Prevent skipping steps forward
              if (index > currentStep) {
                final error = notifier.validateStep(currentStep);
                if (error != null) {
                  ToastHelper.showError(message: error);
                  return;
                }
              }
              setState(() {
                currentStep = index;
              });
            },
          ),
        ),
      ),

      body: Column(
        children: [

          Container(height: 10,color: Color(0xFFDBDBDB)),

          /// STEP CONTENT
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: buildStepBody(),
              ),
            ),
          ),

          /// STICKY BUTTONS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE5E5E5)),
              ),
            ),
            child: Row(
              children: [

                /// BACK
                Expanded(
                  child: CustomButton(
                    text: "Back",
                    onPressed: previousStep,
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    borderRadius: 12,
                    elevation: 0,
                    borderColor: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 12),

                /// NEXT
                Expanded(
                  child: CustomButton(
                    text: currentStep == 3 ? "Submit" : "Save & Next",
                    icon: Icons.keyboard_double_arrow_right,
                    iconRight: true,
                    onPressed: handleSaveQuotation,
                    backgroundColor: AppColors.primary,
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleSaveQuotation() async {
    final notifier = ref.read(quotationFormProvider.notifier);
    final error = notifier.validateStep(currentStep);

    /// ❌ STOP IF ERROR
    if (error != null) {
      ToastHelper.showError(message: error);
      return;
    }

    final data = ref.read(quotationFormProvider);

    try {
      /// 🔄 LOADER
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CupertinoActivityIndicator(),
        ),
      );

      /// ✅ SAVE DRAFT ONLY FOR CREATE
      if (widget.keyType == "create_quatation") {
        ref.read(quotationFormProvider.notifier).updatePaymentSummary();
        await HiveService.save(data);
      }

      /// ✅ FINAL STEP
      if (currentStep == 3) {
        bool success = false;

        /// 🔥 EDIT FLOW
        if (widget.keyType == "edit_click") {
          success = await ref.read(quotationProvider.notifier).updateQuotation(widget.uid ?? "", data);
        }

        /// 🔥 CREATE FLOW
        else {
          final res = await ref.read(quotationProvider.notifier).createQuotation(data);

          success = res['success'] == true;

          if (success) {
            ToastHelper.showSuccess(
              message: "Quotation Created: ${res['quotation_no']}",
            );
          }
        }

        if (mounted) Navigator.pop(context);

        /// ✅ COMMON SUCCESS HANDLING
        if (success) {
          if (widget.keyType == "edit_click") {
            ToastHelper.showSuccess(message: "Quotation updated successfully");
          }

          await HiveService.clear();
          ref.read(quotationFormProvider.notifier).clear();

          if (mounted) Navigator.pop(context, true);
        } else {
          ToastHelper.showError(
            message: widget.keyType == "edit_click"
                ? "Update failed"
                : "Create failed",
          );
        }
      } else {
        if (mounted) Navigator.pop(context);

        /// ✅ NEXT STEP
        nextStep();
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);

      ToastHelper.showError(
        message: widget.keyType == "edit_click"
            ? "Failed to update quotation"
            : "Failed to create quotation",
      );
    }
  }


}




