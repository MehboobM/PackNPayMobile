import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pack_n_pay/screens/survey/widget/filter_bottom_sheet.dart';
import 'package:pack_n_pay/screens/survey/widget/survey_items.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../routes/route_names_const.dart';

class SurveyListScreen extends StatefulWidget {
  const SurveyListScreen({super.key});

  @override
  State<SurveyListScreen> createState() => _SurveyListScreenState();
}
class _SurveyListScreenState extends State<SurveyListScreen> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,

        leading: const Icon(Icons.arrow_back, color: Colors.black),

        title:  Text(
          "Survey list",
          style: TextStyles.f16w600mGray9
        ),

        actions: [
          SvgPicture.asset(
            "assets/icons/pdf.svg",
            width: 22,
            height: 22,
            color: const Color(0xFF2A3582),
          ),

          const SizedBox(width: 16),

          SvgPicture.asset(
            "assets/icons/share.svg",
            width: 22,
            height: 22,
            color: const Color(0xFF2A3582),
          ),

          const SizedBox(width: 16),

          CustomButton(
            onPressed: () {
              Navigator.pushNamed(context, newSurveyRoute);
            },
            width: 100,
            height: 36,
            borderRadius: 6,
            backgroundColor: AppColors.primary,
            icon: Icons.add,
            text: "Add Survey",
            textStyle: TextStyles.f12w400mWhite.copyWith(
              fontWeight: FontWeight.w500
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          ),

          const SizedBox(width: 12),
        ],

        /// THIS PUTS CHIPS INSIDE THE APPBAR WHITE AREA
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusChip(
                    text: "All: 100",
                    isActive: selectedIndex == 0,
                    onTap: () {
                      setState(() => selectedIndex = 0);
                    },
                  ),
                  _StatusChip(
                    text: "Pending: 70",
                    isActive: selectedIndex == 1,
                    onTap: () {
                      setState(() => selectedIndex = 1);
                    },
                  ),
                  _StatusChip(
                    text: "InProgress: 10",
                    isActive: selectedIndex == 2,
                    onTap: () {
                      setState(() => selectedIndex = 2);
                    },
                  ),
                ],
              )
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [




          /// SEARCH + FILTER + CALENDAR
          Row(
            children: [

              /// SEARCH FIELD
              Expanded(
                child: CustomTextField(
                  controller: TextEditingController(),
                  hintText: "Search",
                  prefixIcon: "assets/icons/search.svg",
                  hintStyle: TextStyles.f12w400Gray5,
                  textStyle: const TextStyle(fontSize: 14),
                  borderRadius: 12,
                ),
              ),

              const SizedBox(width: 10),

              /// FILTER BUTTON
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const FilterBottomSheet(),
                  );
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.mGray3,
                      width: 1,
                    ),
                  ),
                  child: const Icon(Icons.filter_list),
                ),
              ),

              const SizedBox(width: 10),

              /// CALENDAR BUTTON
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xffE9ECF7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_today),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// HEADER CONTAINER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xffE9ECF7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: const Color(0xFF2A3582),),
                const SizedBox(width: 10),

                 Text(
                  "Jan 16, 2026 - Jan 16, 2026",
                  style: TextStyles.f11w600mWhite.copyWith(
                    color: AppColors.primary,
                  ),
                ),

                const Spacer(),

                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: const Color(0xFF2A3582)),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Column(
            children: [

              SurveyListHeader(),

              SurveyListItem(
                status: "Pending",
                orderNo: "#3066",
                date: "JAN 9, 2026",
                name: "RAKESH SINGH",
                phone: "+91 0000000000",
                from: "BENGALURU",
                to: "DELHI",
                itemNo: "12",
                actionText: "Quotation",
              ),

              SurveyListItem(
                status: "Submitted",
                orderNo: "#3066",
                date: "JAN 9, 2026",
                name: "RAKESH SINGH",
                phone: "+91 0000000000",
                from: "BENGALURU",
                to: "DELHI",
                itemNo: "12",
                actionText: "Quotation",
              ),
              SurveyListItem(
                status: "Pending",
                orderNo: "#3066",
                date: "JAN 9, 2026",
                name: "RAKESH SINGH",
                phone: "+91 0000000000",
                from: "BENGALURU",
                to: "DELHI",
                itemNo: "12",
                actionText: "Quotation",
              ),
              SurveyListItem(
                status: "Submitted",
                orderNo: "#3066",
                date: "JAN 9, 2026",
                name: "RAKESH SINGH",
                phone: "+91 0000000000",
                from: "BENGALURU",
                to: "DELHI",
                itemNo: "12",
                actionText: "Quotation",
              ),
              SurveyListItem(
                status: "Pending",
                orderNo: "#3066",
                date: "JAN 9, 2026",
                name: "RAKESH SINGH",
                phone: "+91 0000000000",
                from: "BENGALURU",
                to: "DELHI",
                itemNo: "12",
                actionText: "Quotation",
              ),

            ],
          )
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusChip({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFE2E6FF) // active
              : const Color(0xFFF5F5F7), // inactive
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyles.f10w500primary
        ),
      ),
    );
  }
}