

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final String? prefixIcon;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction ?? TextInputAction.next,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,

      style: textStyle ?? GoogleFonts.interTight(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? GoogleFonts.interTight(
          fontSize: 16,
          color: Colors.grey[400],
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
          padding: const EdgeInsets.only(left: 12, right: 6), // control spacing
          child: SvgPicture.asset(
            prefixIcon!,
            height: 18,
            width: 18,
            colorFilter: const ColorFilter.mode(AppColors.mGray5, BlendMode.srcIn),
          ),
        )
            : null,

        prefixIconConstraints: const BoxConstraints(
          minWidth: 30,   // 🔥 reduces default 48 width
          minHeight: 30,
        ),
        filled: true,
        fillColor: AppColors.mWhite,
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColors.mGray3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColors.mGray3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
