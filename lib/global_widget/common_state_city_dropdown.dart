
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  bool isRequired = false,
  int flex = 1,
  required Widget addButton,
}) {
  final selectedItem = items.any((e) => e.value == value)
      ? items.firstWhere((e) => e.value == value)
      : null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          formLabel(title, isRequired: isRequired),
          const SizedBox(width: 8),
          addButton,
        ],
      ),

      const SizedBox(height: 6),

      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mGray3),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mWhite,
        ),

        child: DropdownSearch<DropdownItem>(
          selectedItem: selectedItem,
          items: items,
          onChanged: onChanged,

          itemAsString: (item) => item.label,

          /// ✅ FIX 1: SELECTED VALUE CENTER LEFT
          dropdownBuilder: (context, selectedItem) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                selectedItem?.label ?? "Select",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: selectedItem == null
                      ? AppColors.mGray4
                      : AppColors.mBlack9,
                ),
              ),
            );
          },

          /// ✅ FIX 2: DROPDOWN LIST + SEARCH
          popupProps: PopupProps.menu(
            menuProps: const MenuProps(
              backgroundColor: Colors.white,
            ),
            showSearchBox: true,

            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search City",
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.mGray4,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),

            itemBuilder: (context, item, isSelected) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                child: Text(
                  item.label,
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              );
            },
          ),

          /// ✅ FIX 3: REMOVE TOP ALIGN ISSUE
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12, // 🔥 MAIN FIX FOR CENTER
              ),
            ),
          ),
        ),
      ),
    ],
  );
}


// child: DropdownButtonFormField2<DropdownItem>(
//   value: selectedItem,
//   onChanged: onChanged,
//   isDense: true,
//   isExpanded: true,
//
//   /// ✅ FIX 1: SAME CENTER ALIGN FOR SELECTED
//   selectedItemBuilder: (context) {
//     return items.map((item) {
//       return Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           item.label,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: GoogleFonts.inter(
//             fontSize: 12,
//             color: AppColors.mBlack9,
//           ),
//         ),
//       );
//     }).toList();
//   },
//
//   /// ✅ FIX 2: CUSTOM HINT (CENTER + GREY)
//   hint: Align(
//     alignment: Alignment.centerLeft,
//     child: Text(
//       "Select",
//       style: GoogleFonts.inter(
//         fontSize: 12,
//         color: AppColors.mGray4, // 👈 grey hint
//       ),
//     ),
//   ),
//
//
//   decoration: const InputDecoration(
//     border: InputBorder.none,
//     isDense: true,
//     contentPadding: EdgeInsets.zero,
//   ),
//
//   items: dropdownItems,
//
//   style: GoogleFonts.inter(
//     fontSize: 12,
//     color: AppColors.mBlack9,
//   ),
//
//   iconStyleData: const IconStyleData(
//     icon: Icon(
//       Icons.keyboard_arrow_down,
//       size: 18,
//       color: AppColors.mGray4,
//     ),
//   ),
//
//   /// ✅ FIX 3: PERFECT VERTICAL CENTER
//   buttonStyleData: const ButtonStyleData(
//     height: 48, // match container height
//     padding: EdgeInsets.only(left: 7, right: 0),
//   ),
//
//   menuItemStyleData: const MenuItemStyleData(
//     height: 32,
//     padding: EdgeInsets.symmetric(horizontal: 8),
//   ),
//
//   dropdownStyleData: DropdownStyleData(
//     width: 130,
//     maxHeight: 200,
//     offset: const Offset(0, 8),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12),
//       color: AppColors.mWhite,
//     ),
//   ),
// ),