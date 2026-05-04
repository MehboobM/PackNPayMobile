
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dropdown_item.dart';
import '../utils/app_colors.dart';
import '../utils/m_font_styles.dart';
import 'form_label_widget.dart';

Widget commonStateCityDropdowns({
  required String title,
  required String? value,
  required List<DropdownItem> items,
  required ValueChanged<DropdownItem?> onChanged,
   bool isRequired=false,
  int flex = 1,
}) {
  final selectedItem = items.where((e) => e.value == value).isNotEmpty
      ? items.firstWhere((e) => e.value == value)
      : null;

  final dropdownItems = items.map((item) {
    return DropdownMenuItem<DropdownItem>(
      value: item,
      child: Text(
        item.label,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      formLabel(title, isRequired: isRequired), // ✅ use here
      const SizedBox(height: 6),

      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mGray3),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mWhite,
        ),

        child: DropdownButtonFormField2<DropdownItem>(
          value: selectedItem,
          onChanged: onChanged,
          isDense: true,
          isExpanded: true,

          /// ✅ FIX 1: SAME CENTER ALIGN FOR SELECTED
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.mBlack9,
                  ),
                ),
              );
            }).toList();
          },

          /// ✅ FIX 2: CUSTOM HINT (CENTER + GREY)
          hint: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select",
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

          items: dropdownItems,

          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.mBlack9,
          ),

          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: AppColors.mGray4,
            ),
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
        ),
      ),
    ],
  );
}
