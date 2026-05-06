
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/screens/dashboard/widget/RedCard.dart';
import 'package:pack_n_pay/screens/dashboard/widget/calender_widget.dart';
import 'package:pack_n_pay/screens/dashboard/widget/custom_nav_bar.dart';
import 'package:pack_n_pay/screens/dashboard/widget/order_list.dart';
import 'package:pack_n_pay/screens/dashboard/widget/section_card.dart';
import 'package:pack_n_pay/screens/dashboard/widget/set_up_popup.dart';
import 'package:pack_n_pay/screens/dashboard/widget/staffWise_profit.dart';
import 'package:pack_n_pay/screens/dashboard/widget/subscription_card.dart';
import 'package:pack_n_pay/screens/dashboard/widget/top_section.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

import '../../all_state/dashboard_state.dart';
import '../../database/shared_preferences/shared_storage.dart';
import '../../global_widget/confirmation_dialog.dart';
import '../../global_widget/view_download_service.dart';
import '../../models/order_item.dart';
import '../../notifier/dashboard_notifier.dart';// ✅ IMPORTANT
import '../../routes/route_names_const.dart';
import '../../utils/toast_message.dart';
import '../survey/survey_list_screen.dart';
import 'Menu_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _ensureSetupCompleted();
    });
  }
  int selectedIndex = 0;
  Future<bool> _ensureSetupCompleted() async {
    final storage = StorageService();

    final companyStatus = await storage.getCompanyStatus();
    final subscriptionStatus = await storage.getSubscriptionStatus();

    print("companyStatus: $companyStatus");
    print("subscriptionStatus: $subscriptionStatus");

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

  /// SCREEN SWITCHER
  Widget _getScreen(DashboardState state) {
    switch (selectedIndex) {
      case 0:
        return _homeDashboard(state);
      case 1:
        return  SurveyListScreen(isHideLeading: false,);

      case 2:
        return const MenuScreen();
      default:
        return _homeDashboard(state);
    }
  }

  /// HOME DASHBOARD UI
  Widget _homeDashboard(DashboardState state) {
    final dashboard = state.dashboard;
    final actions = state.actions;
    final upcomingOrders = state.upcomingOrders;

    if (dashboard == null) {
      return const Center(child: Text("No Data"));
    }

    return Column(
      children: [
        const TopSection(),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SubscriptionCard(),
                ),
                const SizedBox(height: 16),
                const CalendarWidget(),
                const SizedBox(height: 16),

                /// ORDERS
                StatsSection(
                  title: "Orders",
                  total: dashboard.orders.total.toString(),
                  items: [
                    StatItem("Pending", dashboard.orders.pending.toString(),
                        color: AppColors.primarySecond),
                    StatItem("Shifting Started",
                        dashboard.orders.shiftingStarted.toString()),
                    StatItem("Pickup Completed",
                        dashboard.orders.pickupCompleted.toString()),
                    StatItem("Shifting Completed",
                        dashboard.orders.shiftingCompleted.toString()),
                    StatItem("Settled",
                        dashboard.orders.settled.toString()),
                    StatItem("Cancelled",
                        dashboard.orders.cancelled.toString()),
                  ],
                ),

                /// SURVEY
                StatsSection(
                  title: "Survey",
                  total: dashboard.surveys.total.toString(),
                  crossAxisCount: 2,
                  items: [
                    StatItem("Pending",
                        dashboard.surveys.pending.toString(),
                        color: AppColors.primarySecond),
                    StatItem(
                        "Converted Quotations",
                        dashboard.surveys.convertedQuotations
                            .toString()),
                  ],
                ),

                /// QUOTATION
                StatsSection(
                  title: "Quotation",
                  total: dashboard.quotations.total.toString(),
                  items: [
                    StatItem("Pending",
                        dashboard.quotations.pending.toString(),
                        color: AppColors.primarySecond),
                    StatItem(
                        "Conv. Orders",
                        dashboard.quotations.convertedOrders
                            .toString()),
                    StatItem("Cancelled",
                        dashboard.quotations.cancelled.toString()),
                  ],
                ),

                /// PROFIT
                StatsSection(
                  title: "Profit/Loss",
                  total: dashboard.profitLoss.netText,
                  crossAxisCount: 2,
                  items: [
                    StatItem("Revenue",
                        "₹${dashboard.profitLoss.revenue}",
                        color: Colors.green),
                    StatItem(
                      "Expenses",
                      "-₹${dashboard.profitLoss.expenses}",
                      color: Colors.red,
                    ),
                  ],
                ),

                const StaffProfitSection(),
                const SizedBox(height: 16),

                /// UPCOMING ORDERS (unchanged)
                OrdersListSection(
                  title: "Upcoming orders",
                  items: upcomingOrders.map((e) {
                    return OrderItemModel(
                      orderNo: e.orderNo,
                      date: formatDate(e.packingDate),
                      name: e.customerName,
                      phone: e.phone,
                      from: e.movingFrom,
                      to: e.movingTo,
                      uid: e.uid, // ✅ REQUIRED
                    );
                  }).toList(),

                  onViewTap: (item) {
                    if (item.uid != null) {
                      ViewDownloadService.handlePdf(
                        context: context,
                        type: "order", // ✅ IMPORTANT (same as backend expects)
                        uid: item.uid!,
                        isDownload: false, // 👁 VIEW = OPEN PDF
                      );
                    }
                  },
                ),

                /// ✅ ACTION LIST (API)
               OrdersListSection(
    title: "Action lists",
    isUpcoming: false,
                 items: actions.map((e) {
                   final docNo = e.quotationNo ??
                       e.surveyNo ??
                       e.orderNo ??
                       e.lrNo;

                   return OrderItemModel(
                     /// ✅ SHOW NAME IN UI
                     orderNo: _getDisplayName(e.type),

                     /// 🔥 KEEP REAL TYPE
                     sourceType: e.type,

                     date: (e.date.isNotEmpty) ? formatDate(e.date) : "-",
                     name: e.name,
                     phone: e.phone,
                     from: e.from,
                     to: e.to,

                     /// 🔥 KEEP DOC NUMBER FOR API
                     uid: docNo,
                   );
                 }).toList(),

    /// ✅ CHANGE HERE (IMPORTANT)
                 onViewTap: (item) {
                   if (item.uid != null && item.uid!.isNotEmpty) {

                     final type = _mapSourceType(item.sourceType);

                     if (type.isEmpty) {
                       ToastHelper.showError(
                         message: "Unsupported document type",
                       );
                       return;
                     }

                     ViewDownloadService.handlePdf(
                       context: context,
                       type: type,
                       uid: item.uid!,
                       isDownload: false,
                     );
                   }
                 },
    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  String _mapSourceType(String? sourceType) {
    final type = sourceType?.trim().toLowerCase();

    switch (type) {
      case "quotation":
        return "quotation";

      case "survey":
        return "survey";

      case "order":
        return "order";

      case "money receipt":
      case "money_receipt":
        return "money_receipt";

      case "lr":
      case "lorry receipt":
      case "lorry_receipt":
        return "lr_bilty";

      default:
        debugPrint("⚠️ Unknown sourceType: $sourceType");
        return ""; // ❌ DON'T fallback blindly
    }
  }
  String _getDisplayName(String? sourceType) {
    final type = sourceType?.trim().toLowerCase();

    switch (type) {
      case "quotation":
        return "Quotation";

      case "survey":
        return "Survey";

      case "order":
        return "Order";

      case "money receipt":
      case "money_receipt":
        return "Money Receipt";

      case "lr":
      case "lorry receipt":
      case "lorry_receipt":
        return "Lorry Receipt";

      default:
        return "Document";
    }
  }

  String formatDate(String date) {
    final d = DateTime.tryParse(date);
    if (d == null) return '';

    return DateFormat('MMM d, yyyy').format(d);
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);

    if (state.isInitialLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        body: Center(child: Text(state.error!)),
      );
    }

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
              description:
              "Are you sure you want to close the application?",
              yesText: "Exit",
              onNo: () => Navigator.pop(context, false),
              onYes: () => Navigator.pop(context, true),
            );
          },
        );

        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF7F7F7),
        body: _getScreen(state), // ✅ FIXED
        bottomNavigationBar: CustomBottomNav(
          selectedIndex: selectedIndex,
          onTap: (index) async {
            final allowed = await _ensureSetupCompleted();

            if (!allowed) return; // ❌ block navigation

            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}