import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../global_widget/custom_textfield.dart';
import '../../global_widget/menu_widget.dart';
import '../../models/create_lorry_receipt.dart';
import '../../models/lorry_receipt.dart';
import '../../notifier/lorry_receiptnotifier.dart';
import '../../notifier/lr_provider.dart';
import '../../screens/Money_receipt/widgets/Money_listItems.dart';
import '../../utils/toast_message.dart';

class LorryReceiptListScreen extends ConsumerStatefulWidget {
  const LorryReceiptListScreen({super.key});

  @override
  ConsumerState<LorryReceiptListScreen> createState() =>
      _LorryReceiptListScreenState();
}

class _LorryReceiptListScreenState
    extends ConsumerState<LorryReceiptListScreen> {
  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Fetch data after widget is built
    Future.microtask(() {
      ref
          .read(lorryReceiptProvider.notifier)
          .fetchLorryReceipts();
    });
  }

  /// Format Date (UI)
  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Format API Date (YYYY-MM-DD → DD-MM-YYYY)
  String formatApiDate(String date) {
    try {
      final d = DateTime.parse(date);
      return "${d.day.toString().padLeft(2, '0')}-"
          "${d.month.toString().padLeft(2, '0')}-"
          "${d.year}";
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(lorryReceiptProvider);
    final lrNotifier =
    ref.read(lorryReceiptProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bodysecondry,

      /// ✅ APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Flexible(
              child: Row(
                children: [
                  Text(
                    "Lorry Receipts",
                    style: TextStyles.f16w600mGray9,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
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
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10),
                  elevation: 0,
                ),
                onPressed: () {
                  // Clear any previous form data
                  ref.read(lrFormDataProvider.notifier).state = {};

                  Navigator.pushNamed(
                    context,
                    newLorryReceiptScreenRoute,
                    arguments: {
                      "isEdit": false,
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  "New LR",
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
            /// 🔍 SEARCH & FILTER
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: searchController,
                    hintText: "Search",
                    prefixIcon: "assets/icons/search.svg",
                    hintStyle: TextStyles.f12w400Gray5,
                    textStyle:
                    const TextStyle(fontSize: 12),
                    borderRadius: 12,
                    onChanged: (value) {
                      lrNotifier.updateSearch(value);
                    },
                  ),
                ),
                const SizedBox(width: 10),

                /// Filter Icon
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.mGray3),
                  ),
                  child: const Icon(Icons.filter_list),
                ),

                const SizedBox(width: 10),

                /// Date Range Picker
                GestureDetector(
                  onTap: () async {
                    final picked =
                    await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() {
                        fromDate = picked.start;
                        toDate = picked.end;
                      });

                      lrNotifier.updateDateRange(
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
                      borderRadius:
                      BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.mGray3),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/calender_icon.svg",
                        width: 28,
                        height: 28,
                        colorFilter:
                        const ColorFilter.mode(
                          AppColors.mBlack9,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 📅 DATE VIEW
            if (fromDate != null && toDate != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.tab,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18),
                    const SizedBox(width: 10),
                    Text(
                      "${formatDate(fromDate!)} - ${formatDate(toDate!)}",
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close,
                          size: 20),
                      onPressed: () {
                        setState(() {
                          fromDate = null;
                          toDate = null;
                        });
                        lrNotifier.updateDateRange(
                            null, null);
                      },
                    ),
                  ],
                ),
              ),


            /// 🔵 HEADER CONTAINER
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3582),
                borderRadius:
                BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "DETAILS",
                      style:
                      TextStyles.f10w500mWhite,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "LOCATION & PRICE",
                        style: TextStyles
                            .f10w500mWhite,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment:
                      Alignment.centerRight,
                      child: Text(
                        "ACTION",
                        style: TextStyles
                            .f10w500mWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 📦 LORRY RECEIPT LIST
    Expanded(
    child: notifier.isLoading
    ? const Center(child: CircularProgressIndicator())
        : notifier.filteredReceipts.isEmpty
    ? const Center(child: Text("No Data Found"))
        : ListView.builder(
    itemCount: notifier.filteredReceipts.length,
    itemBuilder: (context, index) {
    final LorryReceiptModel item =
    notifier.filteredReceipts[index];

    return MoneyReceiptListItem(
    id: item.lrNo,
    date: formatApiDate(item.lrDate),
    name: item.customerName,
    phone: item.phone,
    from: item.movingFrom,
    to: item.movingTo,
    amount: item.totalAmount.split('.').first,
    onTapView: () {
    debugPrint("View ${item.uid}");
    },
    onTapDownload: () {
    debugPrint("Download ${item.uid}");
    },
    onTapMenu: (details) {
    _onTapMenu(context, details.globalPosition, item);
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
  void _onTapMenu(
      BuildContext context,
      Offset position,
      LorryReceiptModel item,
      ) {
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
  void _handleEdit(LorryReceiptModel item) async {
    try {
      final data = await ref
          .read(lorryReceiptProvider.notifier)
          .getLorryReceiptByUid(item.uid);

      /// Clear old form data
      ref.read(lrFormDataProvider.notifier).state = {};

      /// Store API response for prefill
      ref.read(lrFormDataProvider.notifier).state = data;

      /// Navigate to Edit Screen
      Navigator.pushNamed(
        context,
        newLorryReceiptScreenRoute,
        arguments: {
          "uid": item.uid,
          "isEdit": true,
        },
      );
    } catch (e) {
      ToastHelper.showError(
        message: "Failed to load Lorry Receipt",
      );
    }
  }
  void _handleDelete(LorryReceiptModel item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Lorry Receipt"),
          content: const Text(
              "Are you sure you want to delete this lorry receipt?"),
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
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final success = await ref
          .read(lorryReceiptProvider.notifier)
          .deleteLorryReceipt(item.uid);

      if (success) {
        ToastHelper.showSuccess(
          message: "Lorry Receipt deleted successfully",
        );
      } else {
        ToastHelper.showError(
          message: "Failed to delete lorry receipt",
        );
      }
    }
  }
}