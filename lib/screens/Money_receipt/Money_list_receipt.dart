import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pack_n_pay/screens/Money_receipt/widgets/Money_listItems.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';
import 'package:pack_n_pay/global_widget/custom_textfield.dart';
import '../../global_widget/menu_widget.dart';
import '../../global_widget/view_download_service.dart';
import '../../notifier/money_recepitform.dart';
import '../../notifier/moneyreceipt_notifier.dart';
import '../../routes/route_names_const.dart';
import '../../utils/toast_message.dart';
import '../staff/widgets/common_bottom_sheet.dart';
import '../survey/widget/filter_bottom_sheet.dart';

class MoneyListScreen extends ConsumerStatefulWidget {
  const MoneyListScreen({super.key});

  @override
  ConsumerState<MoneyListScreen> createState() =>
      _MoneyListScreenState();
}

class _MoneyListScreenState
    extends ConsumerState<MoneyListScreen> {


  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(moneyReceiptProvider).fetchReceipts();
    });
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String formatApiDate(String date) {
    try {
      final d = DateTime.parse(date);
      return "${d.day}-${d.month}-${d.year}";
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(moneyReceiptProvider);
    final from = notifier.fromDate;
    final to = notifier.toDate;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),

      /// ✅ APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        titleSpacing: 0,
        title: Row(
          children: [
            Flexible(
              child: Row(
                children: [
                  Text("Money Receipts", style: TextStyles.f16w600mGray9),
                  const SizedBox(width: 6),

                  /// 🔥 COUNT FROM API
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.tab,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      notifier.receipts.length.toString(),
                      style: TextStyles.f10w500primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              "assets/icons/pdf.svg",
              width: 20,
              height: 20,
              color: AppColors.primary,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              height: 34,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  elevation: 0,
                ),
    onPressed: () async {
    final result = await Navigator.pushNamed(
    context,
    newReceiptScreenRoute,
    );

    if (result == true) {
    await ref.read(moneyReceiptProvider).fetchReceipts();
    }
    },
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: Text(
                  "New MR",
                  style: TextStyles.f12w400mWhite,
                ),
              ),
            ),
          ),
        ],
      ),

      /// ✅ BODY
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔍 SEARCH
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
                        ref.read(moneyReceiptProvider).updateSearch(value);
                      }
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommonFilterBottomSheet(
                        notifier: ref.read(moneyReceiptProvider),
                      ), // same widget
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

                GestureDetector(
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      ref.read(moneyReceiptProvider).updateDateRange(
                        picked.start,
                        picked.end,
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

            const SizedBox(height: 12),

            /// 📅 DATE VIEW


            if (from != null && to != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.tab,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 10),
                    Text("${formatDate(from)} - ${formatDate(to)}"),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        ref.read(moneyReceiptProvider).updateDateRange(null, null);
                      },
                    ),
                  ],
                ),
              ),

            /// 🔵 HEADER
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
                        style: TextStyles.f10w500mWhite),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("LOCATION & PRICE",
                          style: TextStyles.f10w500mWhite),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child:
                      Text("ACTION", style: TextStyles.f10w500mWhite),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ✅ API LIST
            Expanded(
              child: notifier.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notifier.filteredReceipts.isEmpty
                  ? const Center(child: Text("No Data Found"))
                  : ListView.builder(
    itemCount: notifier.filteredReceipts.length,
                itemBuilder: (context, index) {
                  final item = notifier.filteredReceipts[index];

                  return MoneyReceiptListItem(
                    id: item.receiptNo,
                    date: formatApiDate(item.date),
                    name: item.name,
                    phone: item.phone,
                    from: item.from,
                    to: item.to,
                    amount: item.amount,

                    onTapView: (_) {
                      ViewDownloadService.handlePdf(
                        context: context,
                        type: "money_receipt",
                        uid: item.uid,
                        isDownload: false,
                      );
                    },

                    onTapDownload: (_) {
                      ViewDownloadService.handlePdf(
                        context: context,
                        type: "money_receipt",
                        uid: item.uid,
                        isDownload: true,
                      );
                    },
                    onTapMenu: (details) {
                      onTapMenu(context, details.globalPosition, item);
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
  void onTapMenu(BuildContext context, Offset position, item) {
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
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _handleEdit(item);
            break;

          case 'delete':
            _handleDelete(item);
            break;
        }
      },
    );
  }
  void _handleEdit(item) async {
    try {
      final data = await ref
          .read(moneyReceiptProvider.notifier)
          .getReceiptByUid(item.uid);

      ref.read(moneyReceiptFormProvider.notifier).clear();

      final result = await Navigator.pushNamed(
        context,
        newReceiptScreenRoute,
        arguments: data,
      );

      if (result == true) {
        await ref.read(moneyReceiptProvider).fetchReceipts();
      }
    } catch (e) {
      ToastHelper.showError(
        message: "Failed to load receipt",
      );
    }
  }
  void _handleDelete(item) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Delete Receipt"),
          content: const Text("Are you sure you want to delete this receipt?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await ref
            .read(moneyReceiptProvider.notifier)
            .deleteReceipt(item.uid);

        ToastHelper.showSuccess(
          message: "Receipt deleted successfully",
        );

      } catch (e) {
        ToastHelper.showError(
          message: "Failed to delete receipt",
        );
      }
    }
  }
}