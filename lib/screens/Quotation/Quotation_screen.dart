import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/global_widget/view_download_service.dart';
import 'package:pack_n_pay/screens/Quotation/widget/Quotation_items.dart';
import 'package:pack_n_pay/screens/Quotation/widget/common_dialog.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';
import 'package:pack_n_pay/utils/toast_message.dart';
import '../../database/hive_database/hive_permission.dart';
import '../../database/hive_database/hive_quation_form.dart';
import '../../global_widget/confirmation_dialog.dart';
import '../../global_widget/menu_widget.dart';
import '../../global_widget/custom_textfield.dart';
import '../../notifier/order_detail_notifier.dart';
import '../../notifier/quatation_notifier.dart';
import '../../notifier/quotation_form_notifier.dart';
import '../../routes/route_names_const.dart';
import '../follow_up/followup_dialog.dart';
import '../survey/widget/filter_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';



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
            ref.read(quotationProvider.notifier).fetchQuotationList(
              sort: "new",
            );
            break;

          case 'old_first':
            ref.read(quotationProvider.notifier).fetchQuotationList(
              sort: "old",
            );
            break;

          case 'clear':
            ref.read(quotationProvider.notifier).clearSort();
            break;
        }
      },
    );
  }

  bool get isFilterApplied {
    final state = ref.watch(quotationProvider);
    return state.sortOrder != null && state.sortOrder!.isNotEmpty;
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quotationProvider);
    final list = state.filteredList ?? [];
    final canAddQuotation = PermissionHelper.canAdd(ModuleCode.quotation);

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
          if(canAddQuotation)
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
                        onContinue: () async {
                          Navigator.pop(context);

                          ref.read(quotationFormProvider.notifier).state = oldData;

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
                  if (result == true) {
                    ref.read(quotationProvider.notifier).fetchQuotationList();
                  }
                }
                //this api refrsesh when i came back from this screen newQuotationRoute
                // ref.read(quotationProvider.notifier).fetchQuotationList();
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

                      ref.read(quotationProvider.notifier).fetchQuotationList(fromDate: formatDate(fromDate!), toDate: formatDate(toDate!),);
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

                /// FILTER
                // GestureDetector(
                //   onTap: () {
                //     showModalBottomSheet(
                //       context: context,
                //       isScrollControlled: true,
                //       backgroundColor: Colors.transparent,
                //       builder: (context) => const FilterBottomSheet(),
                //     );
                //   },
                //   child: Container(
                //     height: 48,
                //     width: 48,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(12),
                //       border: Border.all(color: AppColors.mGray3),
                //     ),
                //     child: const Icon(Icons.filter_list),
                //   ),
                // ),
                //
                // const SizedBox(width: 10),
                //
                // /// CALENDAR
                // GestureDetector(
                //   onTap: () async {
                //     final picked = await showDateRangePicker(
                //       context: context,
                //       firstDate: DateTime(2020),
                //       lastDate: DateTime(2100),
                //     );
                //
                //     if (picked != null) {
                //       setState(() {
                //         fromDate = picked.start;
                //         toDate = picked.end;
                //       });
                //
                //       ref
                //           .read(quotationProvider.notifier)
                //           .fetchQuotationList(
                //         fromDate: formatDate(fromDate!),
                //         toDate: formatDate(toDate!),
                //       );
                //     }
                //   },
                //   child: Container(
                //     height: 48,
                //     width: 48,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(12),
                //       border: Border.all(color: AppColors.mGray3),
                //     ),
                //     child: const Icon(Icons.calendar_today),
                //   ),
                // ),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                    _onTapMenu(context, detail.globalPosition,item.uid);

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
  void _onTapMenu(BuildContext context, Offset position,String? quotationNo) {

    final canEditQuotation = PermissionHelper.canEdit(ModuleCode.quotation);
    final canDeleteQuotation = PermissionHelper.canDelete(ModuleCode.quotation);
    final canViewOrder = PermissionHelper.canView(ModuleCode.order);
    final canAddOrder = PermissionHelper.canAdd(ModuleCode.order);

    showGlobalPopupMenu(
      context: context,
      tapPosition: position,
      items: [
       if(canEditQuotation)
           PopupMenuModel(
          value: 'edit',
          title: 'Edit',
          icon: "assets/images/edit.svg",
        ),

       if(canDeleteQuotation)
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

        if(canViewOrder && canAddOrder)
        PopupMenuModel(
          value: 'order_generate',
          title: 'Order Generate',
          icon: "assets/images/signature.svg",
        ),

        PopupMenuModel(
          value: 'setFollow',
          title: 'Set Follow Up',
          icon: "assets/images/follow_up.svg",
        ),


      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _handleEdit(context, quotationNo);
            break;

          case 'delete':
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CommonConfirmDialog(
                  description:
                  "Are you sure you want to delete this quotation?",
                  iconData: Icons.delete_outline,
                  onNo: () {
                    Navigator.pop(context);
                  },
                  onYes: () async {
                    Navigator.pop(context);

                    final success = await ref
                        .read(quotationProvider.notifier)
                        .deleteQuotation(quotationNo ?? "");

                    if (success) {
                      ToastHelper.showSuccess(
                          message: "Quotation deleted successfully");
                      ref
                          .read(quotationProvider.notifier)
                          .fetchQuotationList();
                    } else {
                      ToastHelper.showError(
                          message: "Quotation deletion failed");
                    }
                  },
                );
              },
            );
            break;

          case 'signature':
            _openSignatureUrl(); // ✅ CLEAN
            break;

          case 'order_generate':
            generateOrder(context,quotationNo!); // ✅ CLEAN
            break;

          case 'setFollow':
            print("object>>>>>>>>>>>>>>>${quotationNo}") ;
            showFollowUpDialog(
              context: context,
              ref: ref,
              sourceType: "Quotation",
              sourceId: quotationNo ?? "aa",
            );
            break;
        }
      },
    );
  }


  Future<void> generateOrder(BuildContext context, String uid) async {
    final container = ProviderScope.containerOf(context, listen: false);
    await container.read(orderDetailProvider.notifier).getFormData(uid);
    Navigator.pushNamed(context, orderDetailsScreenRoute);

    // Navigator.pushNamed(context, orderDetailsScreenRoute);
    // Future.microtask(() {
    //   ref.read(orderDetailProvider.notifier).getFormData(uid);
    // });
  }

  Future<void> _handleEdit(BuildContext context, String? quotationNo) async {
    await ref
        .read(quotationProvider.notifier)
        .fetchQuotationAndFillForm(quotationNo ?? "", ref);

    final result = await Navigator.pushNamed(
      context,
      newQuotationRoute,
      arguments: {"keyType": "edit_click", "uid": quotationNo},
    );

    if (result == true) {
      ref.read(quotationProvider.notifier).fetchQuotationList();
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
