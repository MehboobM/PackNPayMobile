import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/Quotation/widget/Quotation_form.dart';
import 'package:pack_n_pay/screens/Quotation/widget/quotation_stepper.dart';
import '../../global_widget/custom_button.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';

class NewQuotationScreen extends StatelessWidget {
  const NewQuotationScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
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
          child: QuotationStepper(currentStep: 1),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// FORM AREA
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: QuotationDetailsForm(),
              ),
            ),
          ),

          /// STICKY BOTTOM BUTTONS
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

                /// BACK BUTTON
                Expanded(
                  child: CustomButton(
                    text: "Back",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    borderRadius: 12,
                    elevation: 0,
                    borderColor: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 12),

                /// SAVE & NEXT
                Expanded(
                  child: CustomButton(
                    text: "Save & Next",
                    icon: Icons.keyboard_double_arrow_right,
                    iconRight: true,
                    onPressed: () {},
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