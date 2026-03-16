import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/Quotation/widget/Quotation_items.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../global_widget/custom_textfield.dart';
import '../../routes/route_names_const.dart';

class QuotationScreen extends StatefulWidget {
  const QuotationScreen({super.key});

  @override
  State<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<QuotationScreen> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xffF5F5F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,

        leading: const Icon(Icons.arrow_back, color:Colors.black),

        /// TITLE + BADGE
        title: Row(
          children: [
            Text(
              "Quotation",
              style: TextStyles.f16w600mGray9,
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.tab,//change
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "100",
                style: TextStyles.f10w500primary,
              ),
            ),
          ],
        ),

        actions: [

          /// PDF
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/pdf.svg",
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(width: 16),

          /// ADD QUOTATION
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(140, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, newQuotationRoute);
              },
              icon: const Icon(Icons.add, size: 18,color:AppColors.mWhite),
              label: Text(
                "Add Quotation",
                style: TextStyles.f12w400mWhite,
              ),
            ),
          )
        ],

        /// STATUS CHIPS

      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// SEARCH ROW
            Row(
              children: [

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

                /// FILTER
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.mGray3),
                  ),
                  child: const Icon(Icons.filter_list),
                ),

                const SizedBox(width: 10),

                /// CALENDAR
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.mGray3),
                  ),
                  child: const Icon(Icons.calendar_today),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// TABLE HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3582),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [

                  Expanded(
                    flex: 2,
                    child: Text(
                      "DETAILS",
                      style: TextStyles.f10w500mWhite
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                    child: Text(
                      "LOCATION & FREIGHT",
                      style: TextStyles.f10w500mWhite
                    ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "ACTION",
                        style: TextStyles.f10w500mWhite
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// LIST
            Expanded(
              child: ListView(
                children: const [

                  QuotationListItem(
                    orderNo: "#3066",
                    date: "JAN 9, 2026",
                    name: "RAKESH SINGH",
                    phone: "+91 0000000000",
                    from: "BENGALURU",
                    to: "DELHI",
                    amount: "₹2000/4000",
                    advance: "₹2000",
                    surveyId: "#2365",
                    lrId: "#2365",
                    orderId: "#2365",
                  ),

                  QuotationListItem(
                    orderNo: "#3066",
                    date: "JAN 9, 2026",
                    name: "RAKESH SINGH",
                    phone: "+91 0000000000",
                    from: "BENGALURU",
                    to: "DELHI",
                    amount: "₹2000/4000",
                    advance: "₹2000",
                    surveyId: "#2365",
                    lrId: "#2365",
                    orderId: "#2365",
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}