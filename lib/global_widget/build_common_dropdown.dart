
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import '../utils/m_font_styles.dart';
import 'dropdown_reuse_textfield.dart';
import 'dropdown_widget.dart';
import 'form_label_widget.dart';


Widget buildCommonDropdown({
  required String title,
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
  bool isRequired = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      formLabel(title, isRequired: isRequired),
      const SizedBox(height: 6),
      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mGray3),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mWhite,
        ),
        child: CustomDropdownField<String>(
          value: value,
          hintText: "select",
          items: items,
          onChanged: onChanged,
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
    ],
  );
}