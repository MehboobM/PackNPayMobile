

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
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Color? backgroundColor;
  final IconData? materialIcon;
  final double? iconSize;
  final bool? isEnable;

  /// NEW
  final double borderRadius;

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
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.backgroundColor,
    this.iconSize,
    this.borderRadius = 5,// default
    this.materialIcon,
    this.isEnable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      enabled:isEnable ,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction ?? TextInputAction.next,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: textStyle ??
          GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ??
            GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.mGray5,
            ),

        prefixIcon: prefixIcon != null
            ? Padding(
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: SvgPicture.asset(
            prefixIcon!,
            height: 18,
            width: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.mGray5,
              BlendMode.srcIn,
            ),
          ),
        )
            : null,

        suffixIcon: materialIcon != null
            ? Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Icon(
            materialIcon,
            size: iconSize ?? 20,
            color: AppColors.mGray4,
          ),
        )
            : null,

        prefixIconConstraints: const BoxConstraints(
          minWidth: 30,
          minHeight: 30,
        ),

        filled: true,
        fillColor: backgroundColor ?? AppColors.mWhite,

        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColors.mGray3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColors.mGray3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
