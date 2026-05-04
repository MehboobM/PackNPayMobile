
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import '../utils/m_font_styles.dart';
import 'dropdown_reuse_textfield.dart';
import 'dropdown_widget.dart';
import 'form_label_widget.dart';

Widget buildChargeField({
  required String title,
  required String? selectedValue,
  required List<String> items,
  required Function(String?) onChanged,
  required TextEditingController controller,
  Function(String?)? onTextChanged,
  bool isRequired = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      formLabel(title, isRequired: isRequired), // ✅ use here
      const SizedBox(height: 6),
      Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mGray3),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mWhite,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 40,
              child: CustomDropdownField<String>(
                value: selectedValue,
                hintText: "Included",
                items: items,//includeExcludeItems,
                onChanged: (value) {
                  onChanged(value);
                  print("object>>>>$selectedValue");
                  if (selectedValue != 'Included in Freight' || selectedValue !='Extra Charge'|| selectedValue != 'Applicable' ) {
                    controller.clear();
                  }
                },
                textStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.mBlack9,
                ),
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.mBlack9,
                ),
              ),
            ),
            Expanded(
              flex: 60,
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ReusableTextField(
                  enabled: (selectedValue =='Extra Charge'|| selectedValue == 'Applicable'),
                  controller: controller,
                  hintText: "₹",
                  onTextChanged: onTextChanged,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}