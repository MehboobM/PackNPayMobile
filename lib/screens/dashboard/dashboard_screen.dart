
import 'package:flutter/material.dart';
import 'package:pack_n_pay/screens/dashboard/widget/RedCard.dart';
import 'package:pack_n_pay/screens/dashboard/widget/calender_widget.dart';
import 'package:pack_n_pay/screens/dashboard/widget/custom_nav_bar.dart';
import 'package:pack_n_pay/screens/dashboard/widget/order_list.dart';
import 'package:pack_n_pay/screens/dashboard/widget/section_card.dart';
import 'package:pack_n_pay/screens/dashboard/widget/staffWise_profit.dart';
import 'package:pack_n_pay/screens/dashboard/widget/subscription_card.dart';
import 'package:pack_n_pay/screens/dashboard/widget/top_section.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

import '../../global_widget/confirmation_dialog.dart';
import '../../models/order_item.dart';
import '../survey/survey_list_screen.dart';
import 'Menu_screen.dart'; // 👈 ADD THIS

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedIndex = 0;

  /// SCREEN SWITCHER
  Widget _getScreen() {

    switch (selectedIndex) {

      case 0:
        return _homeDashboard();

      case 1:
        return  SurveyListScreen(isHideLeading: false,);


      case 2:
        return const MenuScreen();

      default:
        return _homeDashboard();
    }
  }

  /// HOME DASHBOARD UI
  Widget _homeDashboard() {

    return Column(
      children: [

        /// FIXED TOP SECTION
        const TopSection(),

        /// SCROLLABLE CONTENT
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 10),

                const AutoScrollBanner(),

                const SizedBox(height: 16),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SubscriptionCard(),
                ),

                const SizedBox(height: 16),

                const CalendarWidget(),

                const SizedBox(height: 16),

                /// ORDERS
                StatsSection(
                  title: "orders",
                  total: "2,420",
                  items: [
                    StatItem("Pending", "₹2000", color: AppColors.primarySecond),
                    StatItem("Shifting Started", "20"),
                    StatItem("Pickup Completed", "20"),
                    StatItem("Shifting Completed", "20"),
                    StatItem("Settled", "20"),
                    StatItem("Cancelled", "20"),
                  ],
                ),

                /// SURVEY
                StatsSection(
                  title: "Survey List",
                  total: "2,420",
                  crossAxisCount: 2,
                  items: [
                    StatItem("Pending", "₹2000", color: AppColors.primarySecond),
                    StatItem("Converted Quotations", "20"),
                  ],
                ),

                /// QUOTATION
                StatsSection(
                  title: "Quotation",
                  total: "2,420",
                  items: [
                    StatItem("Pending", "₹2000", color: AppColors.primarySecond),
                    StatItem("Conv. orders", "20"),
                    StatItem("Cancelled", "20"),
                  ],
                ),

                /// PROFIT
                StatsSection(
                  title: "Profit/Loss",
                  total: "2,420",
                  crossAxisCount: 2,
                  items: [
                    StatItem("Revenue", "₹2000"),
                    StatItem("Expenses", "-₹2000", color: AppColors.primarySecond),
                  ],
                ),

                const StaffProfitSection(),
                const SizedBox(height: 16),

                /// UPCOMING ORDERS
                OrdersListSection(
                  title: "Upcoming orders",
                  items: [
                    OrderItemModel(
                      orderNo: "#3066",
                      date: "JAN 9, 2026",
                      name: "RAKESH SINGH",
                      phone: "+91 0000000000",
                      from: "BENGALURU",
                      to: "DELHI",
                    ),
                    OrderItemModel(
                      orderNo: "#3066",
                      date: "JAN 9, 2026",
                      name: "RAKESH SINGH",
                      phone: "+91 0000000000",
                      from: "BENGALURU",
                      to: "DELHI",
                    ),
                  ],
                ),

                /// ACTION LIST
                OrdersListSection(
                  title: "Action lists",
                  isUpcoming: false,
                  items: [
                    OrderItemModel(
                      orderNo: "Quotation",
                      date: "JAN 9, 2026",
                      name: "RAKESH SINGH",
                      phone: "+91 0000000000",
                      from: "BENGALURU",
                      to: "DELHI",
                    ),
                    OrderItemModel(
                      orderNo: "Quotation",
                      date: "JAN 9, 2026",
                      name: "RAKESH SINGH",
                      phone: "+91 0000000000",
                      from: "BENGALURU",
                      to: "DELHI",
                    ),
                    OrderItemModel(
                      orderNo: "Quotation",
                      date: "JAN 9, 2026",
                      name: "RAKESH SINGH",
                      phone: "+91 0000000000",
                      from: "BENGALURU",
                      to: "DELHI",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        /// 👇 SHOW CONFIRM DIALOG
        final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CommonConfirmDialog(
              iconData: Icons.close,
              title: "Exit App",
              description: "Are you sure you want to close the application?",
              yesText: "Exit",
              onNo: () {
                Navigator.pop(context, false); // ❌ don't exit
              },
              onYes: () {
                Navigator.pop(context, true); // ✅ exit
              },
            );
          },
        );

        return shouldExit ?? false;
      },
      child: Scaffold(

        backgroundColor: const Color(0xffF7F7F7),

        body: _getScreen(), // 👈 SWITCH SCREENS HERE

        bottomNavigationBar: CustomBottomNav(
          selectedIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}