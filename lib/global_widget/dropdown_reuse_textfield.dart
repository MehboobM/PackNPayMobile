

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import '../utils/m_font_styles.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Function(String?)? onTextChanged;

   ReusableTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.textStyle,
    this.hintStyle,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      style: textStyle ??
          GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      onChanged: onTextChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ??
            GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.mGray5,
            ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
      ),
    );
  }
}