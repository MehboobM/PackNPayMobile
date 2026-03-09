
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/screens/dashboard/widget/Drop_down_items.dart';

import '../../utils/m_font_styles.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),

      appBar: AppBar(
        automaticallyImplyLeading: false, // hides back button
        title: Text(
          "Menus",
          style: TextStyles.f16w600Black8,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
                  children: const [
                    MenuSectionHeader(title: "Main"),
                    MenuDropdown(
                      title: "Home",
                      icon: "assets/images/home_icon.svg",
                      children: [],
                    ),

                    MenuDropdown(
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
                      children: [],
                    ),

                    MenuDropdown(
                      title: "Orders",
                      icon: "assets/icons/Box.svg",
                      children: [],
                    ),

                    MenuDropdown(
                      title: "LR Bilty",
                      icon: "assets/icons/Bilty.svg",
                      children: [],
                    ),

                    MenuDropdown(
                      title: "Money Receipt",
                      icon: "assets/icons/Receipt.svg",
                      children: [],
                    ),

                    MenuDropdown(
                      title: "Staffs",
                      icon: "assets/icons/users.svg",
                      children: [],
                    ),

                    MenuDropdown(
                      title: "Expanse Management",
                      icon: "assets/icons/expense.svg",
                      children: [],
                    ),
                    MenuSectionHeader(title: "Others"),
                    MenuDropdown(
                      title: "Letter Head",
                      icon: "assets/icons/Letterhead.svg",
                      children: [],
                    ),
                    MenuDropdown(
                      title: "Subscription",
                      icon: "assets/icons/subs.svg",
                      children: [],
                    ),
                    MenuDropdown(
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