
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/screens/dashboard/widget/Drop_down_items.dart';
import 'package:share_plus/share_plus.dart';

import '../../database/hive_database/hive_permission.dart';
import '../../database/hive_database/hive_quation_form.dart';
import '../../notifier/quatation_notifier.dart';
import '../../notifier/quotation_form_notifier.dart';
import '../../notifier/survey_notifier.dart';
import '../../routes/route_names_const.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';
import '../dummy/dummy_screen.dart';
import '../Quotation/widget/common_dialog.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String? surveyShareUrl;

  updateGenericLInk() async {
    String? results = await ref.read(surveyDataProvider.notifier).getSurveyShareLink();
    surveyShareUrl = results as String?;
    setState(() {});
  }

  @override
  void initState() {
    updateGenericLInk();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final canViewSurvey = PermissionHelper.canView(ModuleCode.survey);
    final canAddSurvey = PermissionHelper.canAdd(ModuleCode.survey);

    final canViewQuotation = PermissionHelper.canView(ModuleCode.quotation);
    final canAddQuotation = PermissionHelper.canAdd(ModuleCode.quotation);

    final canViewOrder = PermissionHelper.canView(ModuleCode.order);

    final canViewMReceipt = PermissionHelper.canView(ModuleCode.moneyReceipt);
    final canViewStaff = PermissionHelper.canView(ModuleCode.staff);
    final canViewExpense = PermissionHelper.canView(ModuleCode.expense);
    final canViewLr = PermissionHelper.canView(ModuleCode.lr);
    final canViewLetterHead = PermissionHelper.canView(ModuleCode.letterHead);
    final canViewSubscription = PermissionHelper.canView(ModuleCode.subscription);
    final canViewBusiness = PermissionHelper.canView(ModuleCode.business);


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

                       if(canViewSurvey)
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
                            if(canAddSurvey)
                              MenuItem(
                              title: "Add new survey",
                              icon: "assets/icons/Plus.svg",
                              onTap: () {
                                Navigator.pushNamed(context, surveyLinkRoute);
                              },

                            ),
                            MenuItem(
                                title: "Share survey link",
                                icon: "assets/icons/file.svg",
                              onTap: () async {
                                if (surveyShareUrl == null) {
                                  ToastHelper.showError(message: "Link not ready, try again");
                                  return;
                                }

                                await Share.share(surveyShareUrl!);
                              },
                            ),
                            MenuItem(
                                title: "Generic survey link",
                                icon: "assets/icons/generic.svg"),
                          ],
                        ),

                       if(canViewQuotation)
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
                          if(canAddQuotation)
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

                      if(canViewOrder)
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

                      if(canViewLr)
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
                      if(canViewMReceipt)
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
                      if(canViewStaff)
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
                      if(canViewExpense)
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

                      if(canViewLetterHead)
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

                     if(canViewSubscription)
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

                      if(canViewBusiness)
                          MenuDropdown(
                          title: "Business Details",
                          icon: "assets/icons/buisness.svg",
                          children: [
                            MenuItem(
                              title: "Business List",
                              icon: "assets/icons/bar.svg",
                              onTap: () {
                                Navigator.pushNamed(context, companyListRoute);
                              },
                            ),

                            MenuItem(
                              title: "New Business",
                              icon: "assets/icons/Plus.svg",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  myBusinessRoute,
                                  arguments: null, // create
                                );
                              },
                            ),
                          ],
                        ),

                        MenuDropdown(
                          title: "Language",
                          icon: "assets/images/language.svg",
                          children: [
                            MenuItem(
                              title: "Language",
                              icon: "assets/images/language.svg",
                              onTap: () {
                                Navigator.pushNamed(context, languageRoute);
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