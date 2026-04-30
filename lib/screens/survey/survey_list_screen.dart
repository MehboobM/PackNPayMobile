import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pack_n_pay/notifier/survey_notifier.dart';
import 'package:pack_n_pay/screens/survey/widget/filter_bottom_sheet.dart';
import 'package:pack_n_pay/screens/survey/widget/survey_items.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../database/hive_database/hive_permission.dart';
import '../../global_widget/confirmation_dialog.dart';
import '../../global_widget/menu_widget.dart';
import '../../global_widget/view_download_service.dart';
import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../models/survey_list_data.dart';
import '../../routes/route_names_const.dart';
import '../../utils/toast_message.dart';
import '../follow_up/followup_dialog.dart';

class SurveyListScreen extends ConsumerStatefulWidget {
   bool isHideLeading;
   SurveyListScreen({super.key,this.isHideLeading = false});

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

  bool isShareLoading = false;

  String? surveyShareUrl;
  updateGenericLInk() async {

    String? results = await ref.read(surveyDataProvider.notifier).getSurveyShareLink();
    surveyShareUrl = results as String?;
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    updateGenericLInk();
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

  bool get isFilterApplied {
    final state = ref.watch(surveyDataProvider);
    return state.sortOrder != null && state.sortOrder!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyDataProvider);
    final list = state.filteredList ?? [];

    final canAdd = PermissionHelper.canAdd(ModuleCode.survey);
    final canView = PermissionHelper.canView(ModuleCode.survey);

    return canView ? Scaffold(
      backgroundColor: AppColors.bodysecondry,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: widget.isHideLeading
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            Navigator.pop(context);
          },
        )
            : null,
        title:  Padding(
          padding:  EdgeInsets.only(left: widget.isHideLeading ? 0:18 ),
          child: Text(
            "Survey list",
            style: TextStyles.f16w600mGray9
          ),
        ),

        actions: [
          SvgPicture.asset(
            "assets/icons/pdf.svg",
            width: 22,
            height: 22,
            color: AppColors.primary,
          ),

          const SizedBox(width: 16),

          InkWell(
            onTap: () async {
              if (surveyShareUrl == null) {
                ToastHelper.showError(message: "Link not ready, try again");
                return;
              }

              await Share.share(surveyShareUrl!);
            },
            child: SvgPicture.asset(
              "assets/icons/share.svg",
              width: 22,
              height: 22,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 16),

          if(canAdd)
           CustomButton(
            onPressed: () {
              Navigator.pushNamed(context, surveyLinkRoute);
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
                    text: "Total: ${state.surveyListData?.pagination?.total ?? 0}",
                    isActive: selectedIndex == 0,
                    onTap: () {
                      setState(() => selectedIndex = 0);

                      /// ✅ NO STATUS PARAM (ALL)
                      ref.read(surveyDataProvider.notifier).fetchSurveyList(
                        fromDate: fromDate != null ? formatDate(fromDate!) : null,
                        toDate: toDate != null ? formatDate(toDate!) : null,
                      );
                    },
                  ),
                  _StatusChip(
                    text: "Pending: ${state.surveyListData?.pagination?.pendingCount?? "0"}",
                    isActive: selectedIndex == 1,
                    onTap: () {
                      setState(() => selectedIndex = 1);

                      /// ✅ PASS pending
                      ref.read(surveyDataProvider.notifier).fetchSurveyList(
                        status: "pending",
                        fromDate: fromDate != null ? formatDate(fromDate!) : null,
                        toDate: toDate != null ? formatDate(toDate!) : null,
                      );
                    },
                  ),
                  _StatusChip(
                    text: "Settled: ${state.surveyListData?.pagination?.settledCount ?? "0"}",
                    isActive: selectedIndex == 2,
                    onTap: () {
                      setState(() => selectedIndex = 2);
                      ref.read(surveyDataProvider.notifier).fetchSurveyList(
                        status: "settled",
                        fromDate: fromDate != null ? formatDate(fromDate!) : null,
                        toDate: toDate != null ? formatDate(toDate!) : null,
                      );
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
                  onTapDown: (details) {
                    // showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   backgroundColor: Colors.transparent,
                    //   builder: (context) => const FilterBottomSheet(),
                    // );
                    _onTapSort(context, details.globalPosition);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.mGray3),
                        ),
                        child: const Icon(Icons.filter_list),
                      ),

                      /// 🔴 DOT INDICATOR
                      if (isFilterApplied)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),


                    ],
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
                                  to: "",
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
                                    String link = "http://packnpay.in/";
                                    _onTapMenu(context, detail.globalPosition,item.uid ?? "",link,item);
                                  },
                                );
                              },
                            ),
            )


          ],
        ),
      ),

    ) : Center(child: Text( "Permission not granted", style: TextStyles.f12w400Gray5,));
  }


  void _onTapSort(BuildContext context, Offset position) async {
    showGlobalPopupMenu(
      context: context,
      tapPosition: position,
      items: [
        PopupMenuModel(
          value: 'new_first',
          title: 'Date: Newest First',
          icon: "assets/images/arrow_down2.svg",
        ),
        PopupMenuModel(
          value: 'old_first',
          title: 'Date: Oldest First',
          icon: "assets/images/arrow_up.svg",
        ),
        PopupMenuModel(
          value: 'clear',
          title: 'Clear',
          icon: "assets/images/x.svg",
        ),
      ],

      onSelected: (value) async {
        switch (value) {
          case 'new_first':
            ref.read(surveyDataProvider.notifier).fetchSurveyList(
              sort: "new",
            );
            break;

          case 'old_first':
            ref.read(surveyDataProvider.notifier).fetchSurveyList(
              sort: "old",
            );
            break;

          case 'clear':
            ref.read(surveyDataProvider.notifier).clearSort();
            break;
        }
      },
    );
  }


  void _onTapMenu(BuildContext context, Offset position, String quotationNo,String link,SurveyList? item) async {
    final isCompleted = (item?.status ?? "").toLowerCase().trim() == "completed";
    final canEdit = PermissionHelper.canEdit(ModuleCode.survey);

    print("can edit is >>>>>>>>>>>>>$canEdit");
    showGlobalPopupMenu(
      context: context,
      tapPosition: position,
      items: [
        if (!isCompleted && canEdit)
         PopupMenuModel(
          value: 'edit',
          title: 'Edit',
          icon: "assets/images/edit.svg",
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
        if (!isCompleted && canEdit)
         PopupMenuModel(
          value: 'setFollow',
          title: 'Set Follow Up',
          icon: "assets/images/follow_up.svg",
        ),
      ],

      /// 🔥 IMPORTANT: make async
      onSelected: (value) async {
        switch (value) {

        /// ✅ EDIT + QUOTATION (same flow)
          case 'edit':
            String urlLink = "https://packnpay.in/survey/form/$quotationNo";
            await _opeFormUrl(urlLink);
            // Navigator.pushNamed(context, surveyLinkRoute,arguments:item );
            break;

        /// SHARE LINK
          case 'link':
            await _shareSurveyLink(context, quotationNo, link);
            break;

          case 'quotation':
            await handleSurveyNavigation(
              context: context,
              ref: ref,
              quotationNo: quotationNo,
            );
            break;

          case 'setFollow':
           print("object>>>>>>>>>>>>>>>${quotationNo}") ;
           showFollowUpDialog(
             context: context,
             ref: ref,
             sourceType: "Survey",
             sourceId: quotationNo,
           );
            break;
        }
      },
    );
  }
  // PopupMenuModel(
  //   value: 'signature',
  //   title: 'Customer Signature',
  //   icon: "assets/images/signature.svg",
  // ),


  Future<void> handleSurveyNavigation({
    required BuildContext context,
    required WidgetRef ref,
    required String quotationNo,
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
      await ref.read(surveyDataProvider.notifier).fetchSurveyAndFillForm(quotationNo, ref);

      Navigator.pop(context);

      final result = await Navigator.pushNamed(
        context,
        newQuotationRoute,
        arguments: {"keyType": "edit_click_from_survey","uid": quotationNo},
      );

      if (result == true) {
        ref.read(surveyDataProvider.notifier).fetchSurveyList();
      }

    } catch (e) {
      Navigator.pop(context);
      ToastHelper.showError(
        message: "Unable to load survey. Please try again.",
      );
    }
  }


  Future<void> _opeFormUrl(String urls) async {
    final Uri url = Uri.parse(urls);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ToastHelper.showError(message: "Could not open link");
    }
  }


  Future<void> _shareSurveyLink(BuildContext context,String quotationNo, String link,) async {
    final shareText = """Survey Link : $link """;

    final result = await SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: "Survey Link",
      ),
    );

    if (result.status == ShareResultStatus.success) {
      print("Shared successfully");
    }
  }

  Future<void> _openSignatureUrl() async {
    final Uri url = Uri.parse("http://packnpay.in/customer-signature");

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ToastHelper.showError(message: "Could not open link");
    }
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