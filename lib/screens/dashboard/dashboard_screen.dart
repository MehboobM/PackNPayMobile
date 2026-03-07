

import 'package:flutter/material.dart';
import 'package:pack_n_pay/screens/dashboard/widget/RedCard.dart';
import 'package:pack_n_pay/screens/dashboard/widget/calender_widget.dart';
import 'package:pack_n_pay/screens/dashboard/widget/custom_nav_bar.dart';
import 'package:pack_n_pay/screens/dashboard/widget/order_list.dart';
import 'package:pack_n_pay/screens/dashboard/widget/section_card.dart';
import 'package:pack_n_pay/screens/dashboard/widget/staffWise_profit.dart';
import 'package:pack_n_pay/screens/dashboard/widget/subscription_card.dart';
import 'package:pack_n_pay/screens/dashboard/widget/top_section.dart';

import '../../models/order_item.dart';
import 'Menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// THIS GOES INTO STATUS BAR AREA
            const TopSection(),

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
            Column(
              children: [

                /// ORDERS
                StatsSection(
                  title: "Orders",
                  total: "2,420",
                  items: [
                    StatItem("Pending", "₹2000", color: Colors.red),
                    StatItem("Shifting Started", "20"),
                    StatItem("Pickup Completed", "20"),
                    StatItem("Shifting Completed", "20"),
                     StatItem("Settled", "20"),
                     StatItem("Cancelled", "20"),
                  ],
                ),

                /// SURVEY LIST
                StatsSection(
                  title: "Survey List",
                  total: "2,420",
                  crossAxisCount: 2,
                  items: [
                    StatItem("Pending", "₹2000", color: Colors.red),
                     StatItem("Converted Quotations", "20"),
                  ],
                ),

                /// QUOTATION
                StatsSection(
                  title: "Quotation",
                  total: "2,420",
                  items: [
                    StatItem("Pending", "₹2000", color: Colors.red),
                    StatItem("Conv. Orders", "20"),
                    StatItem("Cancelled", "20"),
                  ],
                ),
                StatsSection(
                  title: "Profit/Loss",
                  total: "2,420",
                  crossAxisCount: 2,
                  items: [
                    StatItem("Revenue", "₹2000"),
                    StatItem("Expenses", "-₹2000",color: Colors.red),
                  ],
                ),

                const StaffProfitSection(),
                const SizedBox(height: 16),
                OrdersListSection(
                  title: "Upcoming Orders",
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
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuScreen()),
              );
            } else {
              setState(() {
                selectedIndex = index;
              });
            }
          }
      ),
    );
  }
}