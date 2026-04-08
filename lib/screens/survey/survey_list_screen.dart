import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pack_n_pay/notifier/survey_notifier.dart';
import 'package:pack_n_pay/screens/survey/widget/filter_bottom_sheet.dart';
import 'package:pack_n_pay/screens/survey/widget/survey_items.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../global_widget/menu_widget.dart';
import '../../global_widget/view_download_service.dart';
import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../routes/route_names_const.dart';
import '../../utils/toast_message.dart';

class SurveyListScreen extends ConsumerStatefulWidget {
  const SurveyListScreen({super.key});

  @override
  ConsumerState<SurveyListScreen> createState() => _SurveyListScreenState();
}


class _SurveyListScreenState extends ConsumerState<SurveyListScreen> {

  int selectedIndex = 0;

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
      ref.read(surveyDataProvider.notifier).fetchSurveyList();
    });

    /// Pagination Listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(surveyDataProvider.notifier).fetchSurveyList(
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
    final state = ref.watch(surveyDataProvider);
    final list = state.filteredList ?? [];
    return Scaffold(
      backgroundColor: AppColors.bodysecondry,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        surfaceTintColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title:  Text(
          "Survey list",
          style: TextStyles.f16w600mGray9
        ),

        actions: [
          SvgPicture.asset(
            "assets/icons/pdf.svg",
            width: 22,
            height: 22,
            color: AppColors.primary,
          ),

          const SizedBox(width: 16),

          SvgPicture.asset(
            "assets/icons/share.svg",
            width: 22,
            height: 22,
            color: AppColors.primary,
          ),

          const SizedBox(width: 16),

          CustomButton(
            onPressed: () {
              Navigator.pushNamed(context, newSurveyRoute);
            },
            width: 100,
            height: 36,
            borderRadius: 6,
            backgroundColor: AppColors.primary,
            icon: Icons.add,
            text: "Add Survey",
            textStyle: TextStyles.f12w400mWhite.copyWith(
              fontWeight: FontWeight.w500
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          ),

          const SizedBox(width: 12),
        ],

        /// THIS PUTS CHIPS INSIDE THE APPBAR WHITE AREA
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusChip(
                    text: "All: 100",
                    isActive: selectedIndex == 0,
                    onTap: () {
                      setState(() => selectedIndex = 0);
                    },
                  ),
                  _StatusChip(
                    text: "Pending: 70",
                    isActive: selectedIndex == 1,
                    onTap: () {
                      setState(() => selectedIndex = 1);
                    },
                  ),
                  _StatusChip(
                    text: "InProgress: 10",
                    isActive: selectedIndex == 2,
                    onTap: () {
                      setState(() => selectedIndex = 2);
                    },
                  ),
                ],
              )
            ),
          ),
        ),
      ),
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
                      ref.read(surveyDataProvider.notifier).filterLocalList(value);
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

                      ref.read(surveyDataProvider.notifier).fetchSurveyList(fromDate: formatDate(fromDate!), toDate: formatDate(toDate!),);
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

                        ref.read(surveyDataProvider.notifier).fetchSurveyList();
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            /// TABLE HEADER (UNCHANGED)
            SurveyListHeader(),

            // LIST (DYNAMIC)
             Expanded(
              child: (state.isPageLoading) && list.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null
                  ? Center(
                child: Text(
                  state.error ?? "Something went wrong",
                  style: TextStyles.f12w400Gray5,
                  textAlign: TextAlign.center,
                ),
              )
                  : list.isEmpty
                  ? Center(
                child: Text(
                  searchController.text.isNotEmpty
                      ? "No data available for search"
                      : (fromDate != null || toDate != null)
                      ? "No data available for selected filter"
                      : state.isInitialLoading ? "":"No data available",
                  style: TextStyles.f12w400Gray5,
                  textAlign: TextAlign.center,
                ),
              )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final item = list[index];
                                return SurveyListItem(
                                  status: item.status ?? "",
                                  orderNo: item.id ?? "",
                                  date: item.date ?? "",
                                  name: item.customer ?? "",
                                  phone: item.phone ?? "",
                                  from: item.location ?? "",
                                  to: "DELHI",
                                  itemNo: item.items.toString(),
                                  actionText: item.flag ?? "",
                                  onTapView: () {
                                    ViewDownloadService.handlePdf(
                                      context: context,
                                      type: "survey",
                                      uid: item.uid ?? "",
                                      isDownload: false,
                                    );
                                  },
                                  onTapDownload: () {
                                    ViewDownloadService.handlePdf(
                                      context: context,
                                      type: "survey",
                                      uid: item.uid ?? "",
                                      isDownload: true,
                                    );
                                  },
                                  onTapMenu: (detail) {
                                    _onTapMenu(context, detail.globalPosition,item.uid ?? "");
                                  },
                                );
                              },
                            ),
            )


          ],
        ),
      ),

    );
  }

  Future<void> handleSurveyNavigation({
    required BuildContext context,
    required WidgetRef ref,
    required String surveyId,
  }) async {
    try {
      /// 🔄 SHOW LOADER
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>  Center(
          child: CupertinoActivityIndicator(radius: 16,),
        ),
      );

      /// 🔥 API CALL
      await ref.read(surveyDataProvider.notifier).fetchSurveyAndFillForm(surveyId, ref);

      Navigator.pop(context);

      Navigator.pushNamed(context, newQuotationRoute,arguments: {"keyType":"generate"});

    } catch (e) {
      Navigator.pop(context);
      ToastHelper.showError(
        message: "Unable to load survey. Please try again.",
      );
    }
  }

  void _onTapMenu(BuildContext context, Offset position, String surveyId) async {
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
          value: 'signature',
          title: 'Customer Signature',
          icon: "assets/images/signature.svg",
        ),
        PopupMenuModel(
          value: 'link',
          title: 'Share survey link',
          icon: "assets/images/share_link.svg",
        ),
        PopupMenuModel(
          value: 'quotation',
          title: 'Generate Quotation',
          icon: "assets/images/quotation.svg",
        ),
      ],

      /// 🔥 IMPORTANT: make async
      onSelected: (value) async {
        switch (value) {

        /// ✅ EDIT + QUOTATION (same flow)
          case 'edit':
            print("edit clicked");
            break;


        /// SIGNATURE
          case 'signature':
            print("Signature clicked");
            break;

        /// SHARE LINK
          case 'link':
            print("Link clicked");
            break;

          case 'quotation':
            await handleSurveyNavigation(
              context: context,
              ref: ref,
              surveyId: surveyId,
            );
            break;
        }
      },
    );


  }
}


class _StatusChip extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusChip({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ?AppColors.tab // active
              : const Color(0xFFF5F5F7), // inactive
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyles.f10w500primary
        ),
      ),
    );
  }
}