
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/screens/dashboard/widget/Drop_down_items.dart';

import '../../database/hive_database/hive_quation_form.dart';
import '../../notifier/quatation_notifier.dart';
import '../../notifier/quotation_form_notifier.dart';
import '../../routes/route_names_const.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../dummy/dummy_screen.dart';
import '../Quotation/widget/common_dialog.dart';

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
          /// 🔹 Help & Support Icon
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, helpSupportScreenRoute);
              },
              child: SvgPicture.asset(
                "assets/icons/P_support.svg",
                width: 22,
                height: 22,
              ),
            ),
          ),

          /// 🔹 Settings Icon
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, settingsScreenRoute);
              },
              child: SvgPicture.asset(
                "assets/icons/Settings.svg",
                width: 22,
                height: 22,
              ),
            ),
          ),
        ],
      ),

      body: Consumer(
          builder: (context, ref, child) {
          return Container(
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
                        MenuDropdown(
                          title: "Survey",
                          icon: "assets/icons/Survey.svg",
                          children: [
                            MenuItem(
                              title: "Survey list",
                              icon: "assets/icons/bar.svg",
                              onTap: () {
                                Navigator.pushNamed(context, surveyScreenRoute);
                              },


                            ),
                            MenuItem(
                              title: "Add new survey",
                              icon: "assets/icons/Plus.svg",
                              onTap: () {
                                Navigator.pushNamed(context, surveyLinkRoute);
                              },

                            ),
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
                              title: "Quotation List",
                              icon: "assets/icons/bar.svg",
                              onTap: () {
                                Navigator.pushNamed(context, quotationScreenRoute);
                              },
                            ),
                            MenuItem(
                              title: "Add new quotation",
                              icon: "assets/icons/Plus.svg",
                              onTap:  () async {
                                final oldData = HiveService.get();

                                if (oldData != null) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      return CommonResumeDialog(
                                        onContinue: () async {
                                          Navigator.pop(context);

                                          ref.read(quotationFormProvider.notifier).state = oldData;

                                          final result = await Navigator.pushNamed(
                                            context,
                                            newQuotationRoute,
                                            arguments: {"keyType": "create_quatation"},
                                          );

                                          /// 🔥 REFRESH AFTER BACK
                                          // if (result == true) {
                                          //   ref.read(quotationProvider.notifier).fetchQuotationList();
                                          // }
                                        },
                                        onNew: () async {
                                          await HiveService.clear();

                                          ref.read(quotationFormProvider.notifier).clear();

                                          Navigator.pop(context);
                                          final result = await Navigator.pushNamed(
                                            context,
                                            newQuotationRoute,
                                            arguments: {"keyType": "create_quatation"},
                                          );

                                          /// 🔥 REFRESH AFTER BACK
                                          if (result == true) {
                                            ref.read(quotationProvider.notifier).fetchQuotationList();
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  ref.read(quotationFormProvider.notifier).clear();
                                  final result = await Navigator.pushNamed(
                                    context,
                                    newQuotationRoute,
                                    arguments: {"keyType": "create_quatation"},
                                  );

                                  /// 🔥 REFRESH AFTER BACK
                                  // if (result == true) {
                                  //   ref.read(quotationProvider.notifier).fetchQuotationList();
                                  // }
                                }
                                //this api refrsesh when i came back from this screen newQuotationRoute
                                // ref.read(quotationProvider.notifier).fetchQuotationList();
                              },
                            ),

                          ],
                        ),


                        MenuDropdown(
                          title: "Orders",
                          icon: "assets/icons/Box.svg",
                          children: [
                            MenuItem(
                              title: "Orders List",
                              icon: "assets/icons/bar.svg",
                              onTap: () {
                                Navigator.pushNamed(context, ordersScreenRoute);
                              },
                            ),

                          ],
                        ),

                        MenuDropdown(
                          title: "LR Bilty",
                          icon: "assets/icons/Bilty.svg",
                          children: [
                            MenuItem(
                              title: "Lorry Receipts",
                              icon: "assets/icons/bar.svg", // Replace with a suitable icon if available
                              onTap: () {
                                Navigator.pushNamed(context, lorryReceiptListScreenRoute);
                              },
                            ),

                          ],
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
                          ],
                        ),

                        MenuDropdown(
                          title: "Staffs",
                          icon: "assets/icons/users.svg",
                          children: [
                            MenuItem(
                              title: "Staff",
                              icon: "assets/icons/users.svg",
                              onTap: () {
                                Navigator.pushNamed(context, staffScreenRoute);
                              },
                            ),

                          ],
                        ),

                        MenuDropdown(
                          title: "Expanse Management",
                          icon: "assets/icons/expense.svg",
                          children: [
                            MenuItem(
                              title: "Expense Category",
                              icon: "assets/icons/users.svg",
                              onTap: () {
                                Navigator.pushNamed(context, expenseCategoriesRoute);
                              },
                            ),
                            MenuItem(
                              title: "Office Expense",
                              icon: "assets/icons/Plus.svg",
                              onTap: () {
                                Navigator.pushNamed(context, OfficeExpensePageRoute);
                              },
                            ),
                          ],
                        ),
                        const MenuSectionHeader(title: "Others"),
                        MenuDropdown(
                          title: "Letter Head",
                          icon: "assets/icons/Letterhead.svg",
                          children: [
                            MenuItem(
                              title: "Letter Head",
                              icon: "assets/icons/Letterhead.svg",
                              onTap: () {
                                Navigator.pushNamed(context, LetterheadRoute);
                              },
                            ),
                          ],
                        ),
                         MenuDropdown(
                          title: "Subscription",
                          icon: "assets/icons/subs.svg",
                          children: [
                            MenuItem(
                              title: "subscription",
                              icon: "assets/icons/subs.svg",
                              onTap: () {
                                Navigator.pushNamed(context, SubscriptionRoute);
                              },
                            ),
                          ],
                        ),
                         MenuDropdown(
                          title: "Business Details",
                          icon: "assets/icons/buisness.svg",
                          children: [
                            MenuItem(
                              title: "subscription",
                              icon: "assets/icons/subs.svg",
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DummyExpenseScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),


                ],
              ),
            ),
          );
        }
      ),
    );
  }
}


/*
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

      body: Consumer(
        builder: (context, ref, child) {
          return Container(
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

                         MenuDropdown(
                          title: "Survey",
                          icon: "assets/icons/Survey.svg",
                          children: [
                            MenuItem(
                                title: "Survey list",
                                icon: "assets/icons/bar.svg",
                              onTap: () {
                                Navigator.pushNamed(context, surveyScreenRoute);
                              },


                            ),
                            MenuItem(
                                title: "Add new survey",
                                icon: "assets/icons/Plus.svg",
                              onTap: () {
                                Navigator.pushNamed(context, surveyLinkRoute);
                              },

                            ),
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
                              title: "Quotation List",
                              icon: "assets/icons/bar.svg",
                              onTap: () {
                                Navigator.pushNamed(context, quotationScreenRoute);
                              },
                            ),
                            MenuItem(
                              title: "Add new quotation",
                              icon: "assets/icons/Plus.svg",
                              onTap:  () async {
                                final oldData = HiveService.get();

                                if (oldData != null) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      return CommonResumeDialog(
                                        onContinue: () async {
                                          Navigator.pop(context);

                                          ref.read(quotationFormProvider.notifier).state = oldData;

                                          final result = await Navigator.pushNamed(
                                            context,
                                            newQuotationRoute,
                                            arguments: {"keyType": "create_quatation"},
                                          );

                                          /// 🔥 REFRESH AFTER BACK
                                          // if (result == true) {
                                          //   ref.read(quotationProvider.notifier).fetchQuotationList();
                                          // }
                                        },
                                        onNew: () async {
                                          await HiveService.clear();

                                          ref.read(quotationFormProvider.notifier).clear();

                                          Navigator.pop(context);
                                          final result = await Navigator.pushNamed(
                                            context,
                                            newQuotationRoute,
                                            arguments: {"keyType": "create_quatation"},
                                          );

                                          /// 🔥 REFRESH AFTER BACK
                                          if (result == true) {
                                            ref.read(quotationProvider.notifier).fetchQuotationList();
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  ref.read(quotationFormProvider.notifier).clear();
                                  final result = await Navigator.pushNamed(
                                    context,
                                    newQuotationRoute,
                                    arguments: {"keyType": "create_quatation"},
                                  );

                                  /// 🔥 REFRESH AFTER BACK
                                  // if (result == true) {
                                  //   ref.read(quotationProvider.notifier).fetchQuotationList();
                                  // }
                                }
                                //this api refrsesh when i came back from this screen newQuotationRoute
                                // ref.read(quotationProvider.notifier).fetchQuotationList();
                              },
                            ),

                          ],
                        ),


                        MenuDropdown(
                          title: "Orders",
                          icon: "assets/icons/Box.svg",
                          children: [
                            MenuItem(
                              title: "Orders List",
                              icon: "assets/icons/bar.svg",
                              onTap: () {
                                Navigator.pushNamed(context, ordersScreenRoute);
                              },
                            ),

                          ],
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
          );
        },
      )

    );
  }
}
 */