import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/global_widget/view_download_service.dart';
import 'package:pack_n_pay/screens/Quotation/widget/Quotation_items.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';
import '../../database/hive_database/hive_quation_form.dart';
import '../../global_widget/menu_widget.dart';
import '../../global_widget/custom_textfield.dart';
import '../../notifier/quatation_notifier.dart';
import '../../notifier/quotation_form_notifier.dart';
import '../../routes/route_names_const.dart';
import '../survey/widget/filter_bottom_sheet.dart';

import 'package:flutter/material.dart';

class CommonResumeDialog extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onNew;

  const CommonResumeDialog({
    super.key,
    required this.onContinue,
    required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restore,
                color: AppColors.primary,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            /// TITLE
            Text(
              "Resume Draft",
              style: TextStyles.f16w600mGray9,
            ),

            const SizedBox(height: 8),

            /// DESCRIPTION
            Text(
              "Do you want to continue with your saved form or start a new quotation?",
              textAlign: TextAlign.center,
              style: TextStyles.f14w500mGray7,
            ),

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              children: [

                /// CONTINUE
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onContinue,
                    child: Text(
                      "Continue",
                      style: TextStyles.f8w500mWhite.copyWith(
                        color: AppColors.primary,
                        fontSize: 12
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// NEW
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onNew,
                    child: Text(
                      "New",
                      style: TextStyles.f12w500White,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class QuotationScreen extends ConsumerStatefulWidget {

  const QuotationScreen({super.key});

  @override
  ConsumerState<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends ConsumerState<QuotationScreen> {


  DateTime? fromDate;
  DateTime? toDate;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();

    /// First API Call
    Future.microtask(() {
      ref.read(quotationProvider.notifier).fetchQuotationList();
    });

    /// Pagination Listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(quotationProvider.notifier).fetchQuotationList(
          isLoadMore: true,
          fromDate: fromDate != null ? formatDate(fromDate!) : null,
          toDate: toDate != null ? formatDate(toDate!) : null,
        );
      }
    });
  }



  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quotationProvider);
    final list = state.filteredList ?? [];
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Row(
          children: [
            Text("Quotation", style: TextStyles.f16w600mGray9),
            const SizedBox(width: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.tab,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${state.quatationData?.pagination?.total ?? 0}",
                style: TextStyles.f10w500primary,
              ),
            ),
          ],
        ),
        actions: [
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
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(140, 34),
                padding: EdgeInsets.zero,
              ),
              onPressed: () async {
                final oldData = HiveService.get();

                if (oldData != null) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return CommonResumeDialog(
                        onContinue: () {
                          Navigator.pop(context);

                          ref.read(quotationFormProvider.notifier).state = oldData;

                          Navigator.pushNamed(context, newQuotationRoute,arguments: "create_quatation");
                        },
                        onNew: () async {
                          await HiveService.clear();

                          ref.read(quotationFormProvider.notifier).clear();

                          Navigator.pop(context);
                          Navigator.pushNamed(context, newQuotationRoute,arguments: "create_quatation");
                        },
                      );
                    },
                  );
                } else {
                  ref.read(quotationFormProvider.notifier).clear();
                  Navigator.pushNamed(context, newQuotationRoute,arguments: "create_quatation");
                }
              },

              icon: const Icon(Icons.add, size: 18, color: AppColors.mWhite),
              label: Text("Create Quotation", style: TextStyles.f12w400mWhite),
            ),
          )
        ],
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
                    controller: searchController,
                    hintText: "Search",
                    prefixIcon: "assets/icons/search.svg",
                    hintStyle: TextStyles.f12w400Gray5,
                    textStyle: const TextStyle(fontSize: 14),
                    borderRadius: 12,
                    onChanged: (value) {
                      ref.read(quotationProvider.notifier).filterLocalList(value);
                    },

                  ),
                ),

                const SizedBox(width: 10),

                /// FILTER
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FilterBottomSheet(),
                    );
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.mGray3),
                    ),
                    child: const Icon(Icons.filter_list),
                  ),
                ),

                const SizedBox(width: 10),

                /// CALENDAR
                GestureDetector(
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() {
                        fromDate = picked.start;
                        toDate = picked.end;
                      });

                      ref
                          .read(quotationProvider.notifier)
                          .fetchQuotationList(
                        fromDate: formatDate(fromDate!),
                        toDate: formatDate(toDate!),
                      );
                    }
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.mGray3),
                    ),
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),



            /// DATE HEADER (WITH CLEAR)
            if (fromDate != null && toDate != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                margin: EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.tab,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      "${formatDate(fromDate!)} - ${formatDate(toDate!)}",
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          fromDate = null;
                          toDate = null;
                        });

                        ref.read(quotationProvider.notifier).fetchQuotationList();
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            /// TABLE HEADER (UNCHANGED)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3582),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text("DETAILS",
                          style: TextStyles.f10w500mWhite)),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("LOCATION & FREIGHT",
                          style: TextStyles.f10w500mWhite),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("ACTION",
                          style: TextStyles.f10w500mWhite),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// LIST (DYNAMIC)
             Expanded(
              child: state.isPageLoading && list.isEmpty
                  ? const Center(child: CircularProgressIndicator())

                  /// ✅ ERROR STATE
                  : state.error != null
                      ? Center(
                          child: Text(
                            state.error ?? "Something went wrong",
                            style: TextStyles.f12w400Gray5,
                            textAlign: TextAlign.center,
                          ),
                        )

                      /// ✅ EMPTY STATE (SEARCH / FILTER / DEFAULT)
                      : list.isEmpty
                          ? Center(
                              child: Text(
                                searchController.text.isNotEmpty
                                    ? "No data available for search"
                                    : (fromDate != null || toDate != null)
                                        ? "No data available for selected filter"
                                        : "No data available",
                                style: TextStyles.f12w400Gray5,
                                textAlign: TextAlign.center,
                              ),
                            )

                          /// ✅ DATA LIST
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final item = list[index];

                                return QuotationListItem(
                                  orderNo: item.quotationNo ?? "",
                                  date: item.quotationDate ?? "",
                                  name: item.customerName ?? "",
                                  phone: item.phone ?? "",
                                  from: item.movingFrom ?? "",
                                  to: item.movingTo ?? "",
                                  amount: item.totalAmount ?? "",
                                  advance: item.advancePaid ?? "",
                                  surveyId: item.surveyNo ?? "",
                                  lrId: item.lrNo ?? "",
                                  orderId: item.orderNo ?? "",
                                  onTapView: () {
                                    ViewDownloadService.handlePdf(
                                      context: context,
                                      type: "quotation",
                                      uid: item.uid ?? "",
                                      isDownload: false,
                                    );
                                  },
                                  onTapDownload: () {
                                    ViewDownloadService.handlePdf(
                                      context: context,
                                      type: "quotation",
                                      uid: item.uid ?? "",
                                      isDownload: true,
                                    );
                                  },
                                  onTapMenu: (detail) {
                                    _onTapMenu(context, detail.globalPosition);

                                  },
                                );
                              },
                            ),
            ),

          ],
        ),
      ),
    );
  }
  void _onTapMenu(BuildContext context, Offset position) {
    showGlobalPopupMenu(
      context: context,
      tapPosition: position,
      items: [
        PopupMenuModel(
          value: 'edit',
          title: 'Edit',
          icon: "assets/images/edit.svg",
        ),
        PopupMenuModel(
          value: 'delete',
          title: 'Delete',
          icon: "assets/images/delete.svg",
        ),
        PopupMenuModel(
          value: 'signature',
          title: 'Customer Signature',
          icon: "assets/images/signature.svg",
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            print("Edit clicked");
            break;

          case 'delete':
            print("Delete clicked");
            break;

          case 'signature':
            print("Signature clicked");
            break;
        }
      },
    );
  }

}

/*
class _QuotationScreenState extends State<QuotationScreen> {



  DateTime? fromDate;
  DateTime? toDate;

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

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

                ///Filter
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FilterBottomSheet(),
                    );
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.mGray3),
                    ),
                    child: const Icon(Icons.filter_list),
                  ),
                ),

                const SizedBox(width: 10),

                /// CALENDAR
                GestureDetector(
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() {
                        fromDate = picked.start;
                        toDate = picked.end;
                      });

                      //callApi(); // call API after selecting date
                    }
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.mGray3),
                    ),
                    child: const Icon(Icons.calendar_today),
                  ),
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
            Expanded(  // here need to show quatation list data instead of static on and on scroll send the page no. and if data selected then send date in api
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
}*/
