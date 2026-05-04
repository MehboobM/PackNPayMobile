
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final List<T> items; // ✅ changed
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final TextStyle? textStyle;

  const CustomDropdownField({
    Key? key,
     this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.hintStyle,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 🔹 Convert to DropdownMenuItem
    final dropdownItems = items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Text(
          item.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();

    return DropdownButtonFormField2<T>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      isDense: true,
      isExpanded: true,

      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle ??
                  GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.mBlack9,
                  ),
            ),
          );
        }).toList();
      },

      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          hintText ?? "Select",
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.mGray4, // 👈 grey hint
          ),
        ),
      ),

      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),

      items: dropdownItems, // ✅ use converted list
      style: textStyle,

      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.mGray4),
      ),

      /// ✅ FIX 3: PERFECT VERTICAL CENTER
      buttonStyleData: const ButtonStyleData(
        height: 48, // match container height
        padding: EdgeInsets.only(left: 7, right: 0),
      ),

      menuItemStyleData: const MenuItemStyleData(
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: 8),
      ),

      dropdownStyleData: DropdownStyleData(
        width: 130,
        maxHeight: 200,
        offset: const Offset(0, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mWhite,
        ),
      ),
    );
  }
}