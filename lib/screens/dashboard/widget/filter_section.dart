import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/lorry_receipt.dart';
import '../../../models/order_model.dart';
import '../../../models/quatation_list_data.dart';
import '../../../models/survey_list_data.dart';
import '../../../notifier/lorry_receiptnotifier.dart';
import '../../../notifier/quatation_notifier.dart';
import '../../../notifier/survey_notifier.dart';
import '../../../notifier/order_notifier.dart';
import '../../../routes/route_names_const.dart';
import '../../../utils/m_font_styles.dart';

class FilterSearchSection extends ConsumerStatefulWidget {
  const FilterSearchSection({super.key});

  @override
  ConsumerState<FilterSearchSection> createState() =>
      _FilterSearchSectionState();
}

class _FilterSearchSectionState
    extends ConsumerState<FilterSearchSection> {
  final List<String> items = [
    "User",
    "Quotation",
    "Survey",
    "LR Builty",
    "Order",
  ];

  String selectedValue = "User";
  String searchText = "";

  @override
  void initState() {
    super.initState();
    _callApi();
  }

  /// ✅ API CALL
  void _callApi() {
    Future.microtask(() {
      if (selectedValue == "Quotation") {
        ref.read(quotationProvider.notifier).fetchQuotationList();
      } else if (selectedValue == "Survey") {
        ref.read(surveyDataProvider.notifier).fetchSurveyList();
      } else if (selectedValue == "LR Builty") {
        ref.read(lorryReceiptProvider.notifier).fetchLorryReceipts();
      }
      else if (selectedValue == "Order" || selectedValue == "User") {
        // ✅ SAME API
        ref.read(orderDataProvider.notifier).fetchOrderList();
      }
    });
  }

  /// ✅ SMART FILTER (MULTI FIELD)
  List<dynamic> _filterList(List<dynamic> list) {
    if (searchText.isEmpty) return list;

    final query = searchText.toLowerCase();

    return list.where((item) {
      if (item is QuotationList) {
        return (item.customerName ?? "")
            .toLowerCase()
            .contains(query) ||
            (item.phone ?? "").toLowerCase().contains(query) ||
            (item.quotationNo ?? "").toLowerCase().contains(query) ||
            (item.orderNo ?? "").toLowerCase().contains(query) ||
            (item.lrNo ?? "").toLowerCase().contains(query);
      }

      else if (item is SurveyList) {
        return (item.customer ?? "")
            .toLowerCase()
            .contains(query) ||
            (item.phone ?? "").toLowerCase().contains(query) ||
            (item.id ?? "").toLowerCase().contains(query) ||
            (item.quotation ?? "").toLowerCase().contains(query);
      }

      else if (item is OrderDataList) {
        return (item.customerName ?? "")
            .toLowerCase()
            .contains(query) ||
            (item.phone ?? "").toLowerCase().contains(query) ||
            (item.orderNo ?? "").toLowerCase().contains(query) ||
            (item.quotationNo ?? "").toLowerCase().contains(query);
      }

      else if (item is LorryReceiptModel) {
        return (item.customerName ?? "")
            .toLowerCase()
            .contains(query) ||
            (item.phone ?? "").toLowerCase().contains(query) ||
            (item.lrNo ?? "").toLowerCase().contains(query) ||
            (item.quotationNo ?? "").toLowerCase().contains(query);
      }

      return false;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    final quotationState = ref.watch(quotationProvider);
    final surveyState = ref.watch(surveyDataProvider);
    final orderState = ref.watch(orderDataProvider);
    final lrState = ref.watch(lorryReceiptProvider);

    /// 🔹 GET LIST
    List<dynamic> list = [];

    if (selectedValue == "Quotation") {
      list = quotationState.quatationData?.data ?? [];
    } else if (selectedValue == "Survey") {
      list = surveyState.surveyListData?.data ?? [];
    } else if (selectedValue == "Order" || selectedValue == "User") {
      list = orderState.orderData?.orderList ?? [];

    } else if (selectedValue == "LR Builty") {
      list = lrState.receipts ?? [];
    }

    final filteredList = _filterList(list);

    return Column(
      children: [
        /// 🔹 SEARCH BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffE2E2E2)),
            ),
            child: Row(
              children: [
                /// DROPDOWN
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: selectedValue,
                    customButton: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: const BoxDecoration(
                        color: Color(0xffEDEFF3),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(selectedValue,
                              style: TextStyles.f12w600Gray9),
                          const SizedBox(width: 14),
                          SizedBox(
                            height: 10,
                            width: 10,
                            child: SvgPicture.asset(
                                "assets/images/arrow_down.svg"),
                          ),
                        ],
                      ),
                    ),
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item,
                            style: TextStyles.f12w600Gray9),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                        searchText = "";
                      });
                      _callApi();
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: 130,
                      maxHeight: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 36,
                    ),
                  ),
                ),

                /// SEARCH FIELD
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyles.f12w400Gray5,
                        prefixIcon: const Icon(Icons.search,
                            size: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// 🔥 RESULT LIST
        if (searchText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE2E2E2)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: filteredList.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: Text("No data found"),
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];

                  return InkWell(
                    onTap: () {
                      _handleNavigation(context, item);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// NAME
                          Text(
                            item is QuotationList
                                ? (item.customerName ?? "-")
                                : item is SurveyList
                                ? (item.customer ?? "-")
                                : item is OrderDataList
                                ? (item.customerName ?? "-")
                                : item is LorryReceiptModel
                                ? (item.customerName ?? "-")
                                : "-",
                            style: TextStyles.f12w600Gray9,
                          ),

                          /// PHONE
                          Text(
                            item is QuotationList
                                ? (item.phone ?? "-")
                                : item is SurveyList
                                ? (item.phone ?? "-")
                                : item is OrderDataList
                                ? (item.phone ?? "-")
                                : item is LorryReceiptModel
                                ? (item.phone ?? "-")
                                : "-",
                            style: TextStyles.f10w500Gray5,
                          ),

                          /// NUMBER
                          Text(
                            item is QuotationList
                                ? (item.orderNo ?? item.quotationNo ?? "-")
                                : item is SurveyList
                                ? (item.id ?? item.quotation ?? "-")
                                : item is OrderDataList
                                ? (item.orderNo ?? "-")
                                : item is LorryReceiptModel
                                ? (item.lrNo ?? item.quotationNo ?? "-")
                                : "-",
                            style: TextStyles.f10w500Gray5,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
  void _handleNavigation(BuildContext context, dynamic item) {
    if (item is QuotationList) {
      Navigator.pushNamed(
        context,
        newQuotationRoute,
        arguments: {
          "keyType": "edit",
          "uid": item.uid,
        },
      );
    }

    else if (item is SurveyList) {
      Navigator.pushNamed(
        context,
        newSurveyRoute,
        arguments: {
          "uid": item.uid,
          "isEdit": true,
        },
      );
    }

    else if (item is OrderDataList) {
      Navigator.pushNamed(
        context,
        orderDetailsScreenRoute,
        arguments: {
          "uid": item.uid,
        },
      );
    }

    else if (item is LorryReceiptModel) {
      Navigator.pushNamed(
        context,
         newLorryReceiptScreenRoute,
        arguments: {
          "uid": item.uid,
          "isEdit": true,
        },
      );
    }
  }
}