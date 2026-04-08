import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../utils/app_colors.dart';
import '../utils/m_font_styles.dart';

class DropdownWithField extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final TextEditingController controller;
  final String hintText;

  const DropdownWithField({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.f12w500Gray7),
        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mGray3),
            color: Colors.white,
          ),

          child: Row(
            children: [

              /// 🔽 DROPDOWN BUTTON 2
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  value: value,

                  /// 🔹 Button Style
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.zero,
                    height: 40,
                  ),

                  /// 🔹 Icon
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                    iconSize: 18,
                  ),

                  /// 🔹 TEXT STYLE (SELECTED VALUE)
                  style: TextStyles.f12w400Gray9,

                  /// 🔹 DROPDOWN MENU STYLE
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: Colors.white, // ✅ white dropdown
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    offset: const Offset(0, 4), // ✅ opens below
                  ),

                  /// 🔹 ITEMS STYLE
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),

                  items: items
                      .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyles.f12w400Gray9, // ✅ item style
                    ),
                  ))
                      .toList(),

                  onChanged: onChanged,
                ),
              ),

              const SizedBox(width: 10),

              /// 🔹 TEXT FIELD
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyles.f12w500Gray7, // ✅ input text style
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyles.f12w400Gray5, // ✅ hint style
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}