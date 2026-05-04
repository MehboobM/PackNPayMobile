import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/notifier/order_notifier.dart';
import 'package:pack_n_pay/screens/orders/widgets/order_list.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';
import '../../database/hive_database/hive_permission.dart';
import '../../global_widget/confirmation_dialog.dart';
import '../../global_widget/custom_textfield.dart';
import '../../global_widget/menu_widget.dart';
import '../../global_widget/view_download_service.dart';
import '../../notifier/order_detail_notifier.dart';
import '../../routes/route_names_const.dart';
import '../../utils/toast_message.dart';
import '../Quotation/widget/Quotation_items.dart';
import '../follow_up/followup_dialog.dart';
import '../survey/widget/filter_bottom_sheet.dart';
import '../survey/widget/status_chip.dart';
import '../survey/widget/survey_items.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {

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
      ref.read(orderDataProvider.notifier).fetchOrderList();
    });

    /// Pagination Listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(orderDataProvider.notifier).fetchOrderList(
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
  void _exportOrders() {
    final state = ref.read(orderDataProvider);

    /// ❌ Prevent empty export
    if (state.filteredList == null || state.filteredList!.isEmpty) {
      ToastHelper.showError(message: "No data to export");
      return;
    }

    ViewDownloadService.exportPdf(
      context: context,
      module: "ORDER", // ✅ as per API doc
      filters: {
        /// ✅ Date filter
        if (fromDate != null) "from_date": formatDate(fromDate!),
        if (toDate != null) "to_date": formatDate(toDate!),

        /// ✅ Search
        if (searchController.text.isNotEmpty)
          "search": searchController.text,

        /// ✅ Status mapping (IMPORTANT)
        if (selectedIndex == 1) "order_status": "ORDER_CONFIRMED",
        if (selectedIndex == 2) "order_status": "SETTLED",
        if (selectedIndex == 3) "status": "DELETED",
      },
    );
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
            ref.read(orderDataProvider.notifier).fetchOrderList(
              sort: "new",
            );
            break;

          case 'old_first':
            ref.read(orderDataProvider.notifier).fetchOrderList(
              sort: "old",
            );
            break;

          case 'clear':
            ref.read(orderDataProvider.notifier).clearSort();
            break;
        }
      },
    );
  }

  bool get isFilterApplied {
    final state = ref.watch(orderDataProvider);
    return state.sortOrder != null && state.sortOrder!.isNotEmpty;
  }



  @override
  Widget build(BuildContext context) {

    final state = ref.watch(orderDataProvider);
    final list = state.filteredList ?? [];
    return Scaffold(
      backgroundColor: AppColors.bodysecondry,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "Orders",
          style: TextStyles.f16w600mGray9,
        ),

        actions: [
          InkWell(
            onTap: _exportOrders, // ✅ single action
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/pdf.svg",
                    width: 22,
                    height: 22,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Export",
                    style: TextStyles.f12w400mWhite.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        /// STATUS CHIPS
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16, bottom: 10),

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

                  StatusChip(
                    text: "Total : ${state.orderData?.pagination?.total??0}",
                    isActive: selectedIndex == 0,
                    onTap: () => setState(() => selectedIndex = 0),
                  ),

                  StatusChip(
                    text: "Pending : ${state.orderData?.counts?.total??0}",
                    isActive: selectedIndex == 1,
                    onTap: () => setState(() => selectedIndex = 1),
                  ),


                  StatusChip(
                    text: "Completed : ${state.orderData?.counts?.total??0}",
                    isActive: selectedIndex == 2,
                    onTap: () => setState(() => selectedIndex = 2),
                  ),

                  StatusChip(
                    text: "Cancelled : ${state.orderData?.counts?.total??0}",
                    isActive: selectedIndex == 3,
                    onTap: () => setState(() => selectedIndex = 3),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(

          children: [

            /// SEARCH + FILTER + CALENDAR
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
                      ref.read(orderDataProvider.notifier).filterLocalList(value);
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

                      ref.read(orderDataProvider.notifier).fetchOrderList(fromDate: formatDate(fromDate!), toDate: formatDate(toDate!),);
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


                // /// FILTER
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
                //       ref.read(orderDataProvider.notifier).fetchOrderList(fromDate: formatDate(fromDate!), toDate: formatDate(toDate!),);
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

            /// DATE  CONTAINER
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

                        ref.read(orderDataProvider.notifier).fetchOrderList();
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 6),

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
                  return OrderListItem(
                    orderNo: item.uid ?? "",
                    date: item.deliveryDate ?? "",
                    name: item.customerName ?? "",
                    phone: item.phone ?? "",
                    from:  item.movingFrom ?? "",
                    to: item.movingTo ?? "",
                    amount: item.totalAmount ?? "",
                    advance: item.totalAmount ?? "",
                    surveyId:"",
                    lrId: "#2365",
                    status: item.orderStatus ??"",
                    onTapMenu: (detail) {
                      _onTapMenu(context, detail.globalPosition,item.uid);
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


  void _onTapMenu(BuildContext context, Offset position,String? quotationNo) {


    final canEditOrder = PermissionHelper.canEdit(ModuleCode.order);
    final canDeleteOrder = PermissionHelper.canDelete(ModuleCode.order);

    showGlobalPopupMenu(
      context: context,
      tapPosition: position,
      items: [
      if(canEditOrder)
        PopupMenuModel(
          value: 'edit',
          title: 'Edit',
          icon: "assets/images/edit.svg",
        ),
      if(canDeleteOrder)
        PopupMenuModel(
          value: 'delete',
          title: 'Delete',
          icon: "assets/images/delete.svg",
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
                  "Are you sure you want to delete this order?",
                  iconData: Icons.delete_outline,
                  onNo: () {
                    Navigator.pop(context);
                  },
                  onYes: () async {
                    Navigator.pop(context);

                    final success = await ref.read(orderDataProvider.notifier).deleteOrder(quotationNo ?? "");

                    if (success) {
                      ToastHelper.showSuccess(message: "Order deleted successfully");
                      ref.read(orderDataProvider.notifier).fetchOrderList();
                    } else {
                      ToastHelper.showError(message: "Order deletion failed");
                    }

                  },
                );
              },
            );
            break;

          case 'setFollow':
            print("object>>>>>>>>>>>>>>>${quotationNo}") ;
            showFollowUpDialog(
              context: context,
              ref: ref,
              sourceType: "Order",
              sourceId: quotationNo ?? "",
            );
            break;
        }
      },
    );
  }


  Future<void> _handleEdit(BuildContext context, String? uid) async {
    if (uid == null || uid.isEmpty) return;

    final isSuccess = await ref.read(orderDetailProvider.notifier).fetchOrderByUid(uid);

    if (!isSuccess) {
      ToastHelper.showError(message:  'Failed to load order details',);
      return;
    }

    /// ✅ API SUCCESS → NAVIGATE
    final result = await Navigator.pushNamed(
      context,
      orderDetailsScreenRoute,
    );

    if (result == true) {
      ref.read(orderDataProvider.notifier).fetchOrderList();
    }
  }


}
