import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../../global_widget/custom_button.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {

  bool sortOpen = true;
  bool staffOpen = true;
  bool statusOpen = true;

  int sortValue = 1;
  int staffValue = 0;
  int statusValue = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Text("Filters",
                  style: TextStyles.f14w600Primary.copyWith(
                    color: AppColors.mGray9
                  ),
              ),
              Text("Reset", style: TextStyles.f11w500primary)
            ],
          ),
          Divider(color: Colors.grey.shade200,),

          const SizedBox(height: 10),

          /// SORT BY
          _sectionHeader(
            "Sort by",
            sortOpen,
                () => setState(() => sortOpen = !sortOpen),
          ),

          if (sortOpen) ...[
            _radioTile("By Owner", 1, sortValue, (v) {
              setState(() => sortValue = v);
            }),
            _radioTile("By Survey link", 2, sortValue, (v) {
              setState(() => sortValue = v);
            }),
          ],

          Divider(color: Colors.grey.shade200,),

          /// STAFF
          _sectionHeader(
            "Staff",
            staffOpen,
                () => setState(() => staffOpen = !staffOpen),
          ),

          if (staffOpen) ...[
            _radioTile("All", 0, staffValue, (v) {
              setState(() => staffValue = v);
            }),
            _radioTile("Staff wise", 1, staffValue, (v) {
              setState(() => staffValue = v);
            }),
          ],

          // Divider(color: Colors.grey.shade200,),
          //
          // /// STATUS
          // _sectionHeader(
          //   "Status",
          //   statusOpen,
          //       () => setState(() => statusOpen = !statusOpen),
          // ),
          //
          // if (statusOpen) ...[
          //   _radioTile("Pending", 1, statusValue, (v) {
          //     setState(() => statusValue = v);
          //   }),
          //   _radioTile("Submitted", 2, statusValue, (v) {
          //     setState(() => statusValue = v);
          //   }),
          //   _radioTile("Unassigned", 3, statusValue, (v) {
          //     setState(() => statusValue = v);
          //   }),
          // ],
          //
          // const SizedBox(height: 20),
          //
          // /// APPLY BUTTON
          // CustomButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   text: "Apply",
          //   height: 50,
          //   borderRadius: 10,
          //   backgroundColor: const Color(0xFF2A3582),
          // ),
        ],
      ),
    );
  }

  /// SECTION HEADER WITH ARROW
  Widget _sectionHeader(String title, bool open, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyles.f14w600Primary.copyWith(
                    color: AppColors.mGray9
                ),
              ),
            ),

            /// fixed width so radio aligns under this
            SizedBox(
              width: 40,
              child: Icon(
                open
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// RADIO TILE WITH RADIO ON RIGHT SIDE
  Widget _radioTile(
      String text,
      int value,
      int groupValue,
      Function(int) onChanged, {
        TextStyle? textStyle,
      }) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyles.f14w500mGray7,
              ),
            ),

            /// same width as header arrow
            SizedBox(
              width: 40,
              child: Radio(
                value: value,
                groupValue: groupValue,
                onChanged: (v) => onChanged(v!),
                activeColor: AppColors.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}