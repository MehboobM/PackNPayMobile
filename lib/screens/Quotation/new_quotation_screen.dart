import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/Quotation/widget/Quotation_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/insurance_and_other_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/moving_details_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/payment_detail_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/quotation_stepper.dart';
import '../../database/hive_database/hive_quation_form.dart';
import '../../global_widget/custom_button.dart';
import '../../notifier/quotation_form_notifier.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';

class NewQuotationScreen extends ConsumerStatefulWidget {
  const NewQuotationScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/pdf.svg",
              width: 22,
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/generic.svg",
              width: 22,
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: SvgPicture.asset(
              "assets/icons/expense.svg",
              width: 22,
              color: AppColors.primary,
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: QuotationStepper(
            currentStep: currentStep,
            onStepTapped: (index) {
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
                    text: currentStep == 3 ? "Save" : "Save & Next",
                    icon: Icons.keyboard_double_arrow_right,
                    iconRight: true,
                    // onPressed: (){
                    //   final data = ref.read(quotationFormProvider);
                    //
                    //   if (currentStep == 3) {
                    //     /// FINAL SAVE
                    //     print("FINAL DATA 👉 ${data.toJson()}");
                    //
                    //     ref.read(quotationFormProvider.notifier).clear();
                    //   } else {
                    //     nextStep();
                    //   }
                    // },
                    onPressed: () async {
                      final data = ref.read(quotationFormProvider);

                      /// ✅ SAVE TO HIVE
                      await HiveService.save(data);

                      if (currentStep == 3) {
                        print("FINAL DATA 👉 ${data.toJson()}");

                        /// ✅ CLEAR AFTER FINAL SAVE
                        await HiveService.clear();
                        ref.read(quotationFormProvider.notifier).clear();

                      } else {
                        nextStep();
                      }
                    },
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
}




