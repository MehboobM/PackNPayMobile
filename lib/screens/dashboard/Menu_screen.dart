import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/screens/dashboard/widget/Drop_down_items.dart';
import 'package:pack_n_pay/screens/dashboard/widget/set_up_popup.dart';
import 'package:share_plus/share_plus.dart';

import '../../database/hive_database/hive_permission.dart';
import '../../database/hive_database/hive_quation_form.dart';
import '../../database/shared_preferences/shared_storage.dart';
import '../../global_widget/confirmation_dialog.dart';
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
  int? expandedIndex;

  @override
  void initState() {
    updateGenericLInk();
    super.initState();
  }
  Future<bool> _checkAccess() async {
    final storage = StorageService();

    final companyStatus = await storage.getCompanyStatus();
    final subscriptionStatus = await storage.getSubscriptionStatus();

    final isComplete =
        companyStatus == "complete" &&
            subscriptionStatus == "complete";

    if (!isComplete) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return SetupPopup(
            onClose: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }

    return isComplete;
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
        automaticallyImplyLeading: false, 
        shadowColor: Colors.black38, 
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
                  Expanded(
                    child: ListView(
                      children: [
                        const MenuSectionHeader(title: "Main"),
                         MenuDropdown(
                          title: "Home",
                          icon: "assets/images/home_icon.svg",
                           isExpanded: expandedIndex == 0,
                           onTap: () {
                             setState(() {
                               expandedIndex = expandedIndex == 0 ? null : 0;
                             });
                           },
                          children: [
                            MenuItem(
                              title: "Home",
                              icon: "assets/icons/home_icon.svg",
                              onTap: () {
                                Navigator.pushNamed(context, homeScreenRoute);
                              },
                            ),
                          ],
                        ),

                       if(canViewSurvey)
                        MenuDropdown(
                          title: "Survey",
                          icon: "assets/icons/Survey.svg",
                          isExpanded: expandedIndex == 1,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 1 ? null : 1;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "Survey list",
                              icon: "assets/icons/bar.svg",

                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;

                                Navigator.pushNamed(context, surveyScreenRoute);
                              },
                            ),
                            if(canAddSurvey)
                              MenuItem(
                              title: "Add new survey",
                              icon: "assets/icons/Plus.svg",
                                onTap: () async {
                                  final allowed = await _checkAccess();
                                  if (!allowed) return;

                                  Navigator.pushNamed(context, surveyLinkRoute);
                                },

                            ),
                            MenuItem(
                                title: "Generic survey link",
                                icon: "assets/icons/file.svg",
                              onTap: () async {
                                if (surveyShareUrl == null) {
                                  ToastHelper.showError(message: "Link not ready, try again");
                                  return;
                                }
                                await Share.share(surveyShareUrl!);
                              },
                            ),

                          ],
                        ),

                       if(canViewQuotation)
                         MenuDropdown(
                          title: "Quotation",
                          icon: "assets/icons/generic.svg",
                           isExpanded: expandedIndex == 2,
                           onTap: () {
                             setState(() {
                               expandedIndex = expandedIndex == 2 ? null : 2;
                             });
                           },
                          children: [
                            MenuItem(
                              title: "Quotation List",
                              icon: "assets/icons/bar.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;

                                Navigator.pushNamed(context, quotationScreenRoute);
                              },
                            ),
                          if(canAddQuotation)
                            MenuItem(
                              title: "Add new quotation",
                              icon: "assets/icons/Plus.svg",
                              onTap:  () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
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
                                          await Navigator.pushNamed(
                                            context,
                                            newQuotationRoute,
                                            arguments: {"keyType": "create_quatation"},
                                          );
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
                                          if (result == true) {
                                            ref.read(quotationProvider.notifier).fetchQuotationList();
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  ref.read(quotationFormProvider.notifier).clear();
                                  await Navigator.pushNamed(
                                    context,
                                    newQuotationRoute,
                                    arguments: {"keyType": "create_quatation"},
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                      if(canViewOrder)
                        MenuDropdown(
                          title: "Orders",
                          icon: "assets/icons/Box.svg",
                          isExpanded: expandedIndex == 3,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 3 ? null : 3;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "Orders List",
                              icon: "assets/icons/bar.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, ordersScreenRoute);
                              },
                            ),
                          ],
                        ),

                      if(canViewLr)
                        MenuDropdown(
                          title: "LR Bilty",
                          icon: "assets/icons/Bilty.svg",
                          isExpanded: expandedIndex == 4,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 4 ? null : 4;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "Lorry Receipts",
                              icon: "assets/icons/bar.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, lorryReceiptListScreenRoute);
                              },
                            ),
                          ],
                        ),
                      if(canViewMReceipt)
                        MenuDropdown(
                          title: "Money Receipt",
                          icon: "assets/icons/Receipt.svg",
                          isExpanded: expandedIndex == 5,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 5 ? null : 5;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "Money List",
                              icon: "assets/icons/bar.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, moneyListScreenRoute);
                              },
                            ),
                          ],
                        ),
                      if(canViewStaff)
                        MenuDropdown(
                          title: "Staffs",
                          icon: "assets/icons/users.svg",
                          isExpanded: expandedIndex == 6,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 6 ? null : 6;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "Staff",
                              icon: "assets/icons/users.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, staffScreenRoute);
                              },
                            ),
                          ],
                        ),
                      if(canViewExpense)
                        MenuDropdown(
                          title: "Expanse Management",
                          icon: "assets/icons/expense.svg",
                          isExpanded: expandedIndex == 7,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 7 ? null : 7;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "Expense Category",
                              icon: "assets/icons/users.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, expenseCategoriesRoute);
                              },
                            ),
                            MenuItem(
                              title: "Office Expense",
                              icon: "assets/icons/Plus.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
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
                          isExpanded: expandedIndex == 8,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 8 ? null : 8;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "Letter Head",
                              icon: "assets/icons/Letterhead.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, LetterheadRoute);
                              },
                            ),
                          ],
                        ),

                     if(canViewSubscription)
                        MenuDropdown(
                          title: "Subscription",
                          icon: "assets/icons/subs.svg",
                          isExpanded: expandedIndex == 9,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 9 ? null : 9;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "subscription",
                              icon: "assets/icons/subs.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, SubscriptionRoute);
                              },
                            ),
                          ],
                        ),

                      if(canViewBusiness)
                          MenuDropdown(
                          title: "Business Details",
                          icon: "assets/icons/buisness.svg",
                            isExpanded: expandedIndex == 10,
                            onTap: () {
                              setState(() {
                                expandedIndex = expandedIndex == 10 ? null : 10;
                              });
                            },
                          children: [
                            MenuItem(
                              title: "Business List",
                              icon: "assets/icons/bar.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, companyListRoute);
                              },
                            ),
                            MenuItem(
                              title: "New Business",
                              icon: "assets/icons/Plus.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(
                                  context,
                                  myBusinessRoute,
                                  arguments: null,
                                );
                              },
                            ),
                          ],
                        ),

                        MenuDropdown(
                          title: "Language",
                          icon: "assets/images/language.svg",
                          isExpanded: expandedIndex == 11,
                          onTap: () {
                            setState(() {
                              expandedIndex = expandedIndex == 11 ? null : 11;
                            });
                          },
                          children: [
                            MenuItem(
                              title: "Select Language",
                              icon: "assets/icons/bar.svg",
                              onTap: () async {
                                final allowed = await _checkAccess();
                                if (!allowed) return;
                                Navigator.pushNamed(context, languageRoute);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: Text(
                              "Logout",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return CommonConfirmDialog(
                                    iconData: Icons.logout,
                                    title: "Logout",
                                    description: "Are you sure you want to logout?",
                                    yesText: "Logout",
                                    onNo: () => Navigator.pop(context, false),
                                    onYes: () => Navigator.pop(context, true),
                                  );
                                },
                              );

                              if (confirm == true) {
                                await StorageService().clearAll();

                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    loginScreenRoute,
                                        (route) => false,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
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
