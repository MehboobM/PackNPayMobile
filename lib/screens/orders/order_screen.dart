import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/orders/widgets/order_list.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';
import '../../global_widget/custom_textfield.dart';
import '../Quotation/widget/Quotation_items.dart';
import '../survey/widget/status_chip.dart';
import '../survey/widget/survey_items.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodysecondry,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,

        leading: const Icon(Icons.arrow_back, color: Colors.black),

        title: Text(
          "Orders",
          style: TextStyles.f16w600mGray9,
        ),

        actions: [

          /// PDF ICON
          SvgPicture.asset(
            "assets/icons/pdf.svg",
            width: 22,
            height: 22,
            color: AppColors.primary,
          ),

          const SizedBox(width: 12),

          /// EXPORT TEXT
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Export",
                style: TextStyles.f12w400mWhite.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],

        /// STATUS CHIPS
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16, bottom: 10),

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

                  StatusChip(
                    text: "All:100",
                    isActive: selectedIndex == 0,
                    onTap: () => setState(() => selectedIndex = 0),
                  ),

                  StatusChip(
                    text: "Pending",
                    isActive: selectedIndex == 1,
                    onTap: () => setState(() => selectedIndex = 1),
                  ),


                  StatusChip(
                    text: "Completed",
                    isActive: selectedIndex == 2,
                    onTap: () => setState(() => selectedIndex = 2),
                  ),

                  StatusChip(
                    text: "Cancelled",
                    isActive: selectedIndex == 3,
                    onTap: () => setState(() => selectedIndex = 3),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [

          /// SEARCH + FILTER + CALENDAR
          Row(
            children: [

              /// SEARCH
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
                  border: Border.all(
                    color: AppColors.mGray3,
                    width: 1,
                  ),
                ),
                child: const Icon(Icons.filter_list),
              ),

              const SizedBox(width: 10),

              /// CALENDAR
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.tab,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_today),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// DATE HEADER CONTAINER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.tab,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              children: [

                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Color(0xFF2A3582),
                ),

                const SizedBox(width: 10),

                Text(
                  "Jan 16, 2026 - Jan 16, 2026",
                  style: TextStyles.f11w600mWhite.copyWith(
                    color: AppColors.primary,
                  ),
                ),

                const Spacer(),

                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF2A3582),
                  ),
                  onPressed: () {},
                ),
              ],
            ),

          ),
          const SizedBox(height: 6),

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



          OrderListItem(
                  orderNo: "#3066",
                  date: "JAN 9, 2026",
                  name: "RAKESH SINGH",
                  phone: "+91 0000000000",
                  from: "BENGALURU",
                  to: "DELHI",
                  amount: "₹2000/4000",
                  advance: "₹2000",
                  surveyId: "#2365",
                  lrId: "#2365", status: 'pending',

                ),
          OrderListItem(
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
            status: 'INPROGRESS',

          ),
        ],
      ),
    );
  }
}
