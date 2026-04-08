
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/screens/dashboard/widget/Drop_down_items.dart';

import '../../routes/route_names_const.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mWhite,

      appBar: AppBar(
        automaticallyImplyLeading: false, // hides back button
        shadowColor: Colors.black38, // stronger shadow
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.mWhite,
        title: Text(
          "Menus",
          style: TextStyles.f16w600Black8,
        ),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              "assets/icons/P_support.svg",
              width: 22,
              height: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              "assets/icons/Settings.svg",
              width: 22,
              height: 22,
            ),
          ),
        ],
      ),

      body: Container(
        color: const Color(0xffF3F3F3),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              /// MENU LIST
              Expanded(
                child: ListView(
                  children: [
                    const MenuSectionHeader(title: "Main"),
                    const MenuDropdown(
                      title: "Home",
                      icon: "assets/images/home_icon.svg",
                      children: [],
                    ),

                    const MenuDropdown(
                      title: "Survey List",
                      icon: "assets/icons/Survey.svg",
                      children: [
                        MenuItem(
                            title: "Survey list",
                            icon: "assets/icons/bar.svg"),
                        MenuItem(
                            title: "Add new survey",
                            icon: "assets/icons/Plus.svg"),
                        MenuItem(
                            title: "Share survey link",
                            icon: "assets/icons/file.svg"),
                        MenuItem(
                            title: "Generic survey link",
                            icon: "assets/icons/generic.svg"),
                      ],
                    ),

                    MenuDropdown(
                      title: "Quotation",
                      icon: "assets/icons/generic.svg",
                      children: [
                        MenuItem(
                          title: "Quotation",
                          icon: "assets/icons/bar.svg",
                          onTap: () {
                            Navigator.pushNamed(context, quotationScreenRoute);
                          },
                        ),
                        // MenuItem(
                        //   title: "New Quotation",
                        //   icon: "assets/icons/bar.svg",
                        //   onTap: () {
                        //   //  Navigator.pushNamed(context, newQuotationScreenRoute);
                        //   },
                        // ),

                      ],
                    ),


                    MenuDropdown(
                      title: "orders",
                      icon: "assets/icons/Box.svg",
                      children: [],
                    ),

                    const MenuDropdown(
                      title: "LR Bilty",
                      icon: "assets/icons/Bilty.svg",
                      children: [],
                    ),

                    MenuDropdown(
                      title: "Money Receipt",
                      icon: "assets/icons/Receipt.svg",
                      children: [
                        MenuItem(
                          title: "Money List",
                          icon: "assets/icons/bar.svg",
                          onTap: () {
                            Navigator.pushNamed(context, moneyListScreenRoute);
                          },
                        ),
                        MenuItem(
                          title: "New Receipt",
                          icon: "assets/icons/Plus.svg",
                          onTap: () {
                            Navigator.pushNamed(context, newReceiptScreenRoute);
                          },
                        ),
                      ],
                    ),

                    const MenuDropdown(
                      title: "Staffs",
                      icon: "assets/icons/users.svg",
                      children: [],
                    ),

                    MenuDropdown(
                      title: "Expanse Management",
                      icon: "assets/icons/expense.svg",
                      children: [],
                    ),
                    const MenuSectionHeader(title: "Others"),
                    const MenuDropdown(
                      title: "Letter Head",
                      icon: "assets/icons/Letterhead.svg",
                      children: [],
                    ),
                    const MenuDropdown(
                      title: "Subscription",
                      icon: "assets/icons/subs.svg",
                      children: [],
                    ),
                    const MenuDropdown(
                      title: "Business Details",
                      icon: "assets/icons/buisness.svg",
                      children: [],
                    ),

                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}