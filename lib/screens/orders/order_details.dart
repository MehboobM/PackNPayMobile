import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/orders/widgets/change_status_dialog.dart';
import 'package:pack_n_pay/screens/orders/widgets/expansion_section.dart';

import 'package:pack_n_pay/screens/orders/widgets/order_status_stepper.dart';
import 'package:pack_n_pay/screens/orders/widgets/shipment_staus.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../global_widget/custom_button.dart';
import '../../notifier/order_detail_notifier.dart';
import '../../utils/toast_message.dart';
import '../Quotation/widget/gradient_title_widget.dart';
import '../dummy/widgets/details_upload_dialog.dart';
import '../dummy/widgets/expense_popup.dart';
import '../dummy/widgets/staff_labour_popup.dart';
import '../dummy/widgets/vehicle_details.dart';  // <-- make sure this path is correct

class OrderDetailsScreen extends ConsumerStatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {



  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';

    try {
      final d = DateTime.parse(date);
      return "${d.day.toString().padLeft(2, '0')}-"
          "${d.month.toString().padLeft(2, '0')}-"
          "${d.year}";
    } catch (e) {
      return date; // fallback if parsing fails
    }
  }


  String getStatus(String? status) {
    switch (status) {
      case "SHIFTING_STARTED":
        return "SHIFTING STARTED";
      case "SHIFTING_COMPLETED":
        return "SHIFTING COMPLETED";
      default:
        return status ?? "-";
    }
  }

  List<Map<String, dynamic>> mapExpenses(List<dynamic> expenses) {
    return expenses.map((e) {
      return {
        "category_id": e.categoryId,
        "amount": int.tryParse(e.amount ?? "0") ?? 0,
      };
    }).toList();
  }

  @override
  void didUpdateWidget(covariant OrderDetailsScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _dialogShown = false;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderCreate(); // ✅ safe call after build
    });
  }

  orderCreate() async {
    var state = ref.read(orderDetailProvider);
    var data = state.orderData?.data;

    /// CREATE ORDER


    /// SHOW DIALOG
    if (!_dialogShown && data?.existingOrderNo != null && data!.existingOrderNo!.isNotEmpty) {

      _dialogShown = true; // ✅ set BEFORE dialog to avoid multiple calls

     final isBack = await showOrderExistsDialog(context, data.existingOrderNo!,);

      if( isBack ?? false){
        if (data?.id == null) {
          final message = await ref.read(orderDetailProvider.notifier).createOrderAndRefresh(data?.quotationId ?? "");
          if (message == "Order created successfully") {
            ToastHelper.showSuccess(message: message!);
          } else {
            ToastHelper.showError(message: message ?? "Error occurred");
          }

          /// 🔥 IMPORTANT: re-fetch updated state
          // state = ref.read(orderDetailProvider);
          // data = state.orderData?.data;
        }
      }
    }
  }

  Future<bool?> showOrderExistsDialog(BuildContext context, String existingId) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final state = ref.watch(orderDetailProvider);
        final isLoading = state.isPageLoading;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.mWhite,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔶 Top Row (Icon)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.lightYellow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.orangeStatus,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),

                const SizedBox(height: 16),

                /// 🔤 Title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Order Already Exists",
                    style: TextStyles.f18w600Black8,
                  ),
                ),

                const SizedBox(height: 8),

                /// 📄 Description
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "An order $existingId already exists for this quotation. Do you want to open it?",
                    style: TextStyles.f14w500mGray7,
                  ),
                ),

                const SizedBox(height: 20),

                Divider(color: AppColors.mGray3, height: 1),

                const SizedBox(height: 16),

                /// 🔘 Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: AppColors.mGray3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                          Navigator.pop(context, true); // ✅ return true
                        },
                        child: Text(
                          "Stay Here",
                          style: TextStyles.f14w600mGray9,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primarySecond,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          final navigator = Navigator.of(context);

                          final isSuccess = await ref
                              .read(orderDetailProvider.notifier)
                              .fetchOrderByUid(existingId);

                          if (!mounted) return;

                          if (!isSuccess) {
                            ToastHelper.showError(
                              message: 'Failed to load order details',
                            );
                            return;
                          }

                          if (navigator.canPop()) {
                            navigator.pop(false); // ✅ return false
                          }
                        },
                        child: Text(
                          "Open Order",
                          style: TextStyles.f14w400White,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void showOrderExistsDialog(BuildContext context, String existingId) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       final state = ref.watch(orderDetailProvider);
  //       final isLoading = state.isPageLoading;
  //
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         backgroundColor: AppColors.mWhite,
  //         child: Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //
  //               /// 🔶 Top Row (Icon)
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: AppColors.lightYellow,
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: Icon(
  //                       Icons.warning_amber_rounded,
  //                       color: AppColors.orangeStatus,
  //                       size: 22,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 24),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 16),
  //
  //               /// 🔤 Title
  //               Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   "Order Already Exists",
  //                   style: TextStyles.f18w600Black8,
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 8),
  //
  //               /// 📄 Description
  //               Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   "An order $existingId already exists for this quotation. Do you want to open it?",
  //                   style: TextStyles.f14w500mGray7,
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               Divider(color: AppColors.mGray3, height: 1),
  //
  //               const SizedBox(height: 16),
  //
  //               /// 🔘 Buttons
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: OutlinedButton(
  //                       style: OutlinedButton.styleFrom(
  //                         padding: const EdgeInsets.symmetric(vertical: 12),
  //                         side: BorderSide(color: AppColors.mGray3),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                       ),
  //                       onPressed: isLoading
  //                           ? null
  //                           : () {
  //                         //  ref.read(orderDetailProvider.notifier).clearState();
  //                         Navigator.pop(context,true);
  //                       },
  //                       child: Text(
  //                         "Stay Here",
  //                         style: TextStyles.f14w600mGray9,
  //                       ),
  //                     ),
  //                   ),
  //
  //                   const SizedBox(width: 12),
  //
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: AppColors.primarySecond,
  //                         padding: const EdgeInsets.symmetric(vertical: 12),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         elevation: 0,
  //                       ),
  //                       onPressed:
  //                       // isLoading && !_dialogShown ? null :
  //                           () async {
  //                         final navigator = Navigator.of(context);
  //
  //                         final isSuccess = await ref.read(orderDetailProvider.notifier).fetchOrderByUid(existingId);
  //
  //                         if (!mounted) return;
  //
  //                         if (!isSuccess) {
  //                           ToastHelper.showError(message: 'Failed to load order details',);
  //                           return;
  //                         }
  //
  //                         if (navigator.canPop()) {
  //                           navigator.pop(false);
  //                         }
  //                         // final isSuccess = await ref
  //                         //     .read(orderDetailProvider.notifier)
  //                         //     .fetchOrderByUid(existingId);
  //                         //
  //                         // if (!isSuccess) {
  //                         //   ToastHelper.showError(
  //                         //     message: 'Failed to load order details',
  //                         //   );
  //                         //   return;
  //                         // }
  //                         // _dialogShown = true;
  //                         // Navigator.pop(context);
  //                       },
  //                       child:
  //                       // (isLoading && _dialogShown)
  //                       //     ? SizedBox(
  //                       //   height: 16,
  //                       //   width: 16,
  //                       //   child: CircularProgressIndicator(
  //                       //     strokeWidth: 2,
  //                       //     color: AppColors.mWhite,
  //                       //   ),
  //                       // ) :
  //                       Text(
  //                         "Open Order",
  //                         style: TextStyles.f14w400White,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }




  bool _dialogShown = false;
  @override
  Widget build(BuildContext context) {

    final state = ref.watch(orderDetailProvider);
    final data = state.orderData?.data;

    print("existingOrderNo>>>>> ${data?.existingOrderNo}");


    final pickup = data?.quotationAddresses?.pickup;
    final delivery = data?.quotationAddresses?.delivery;
    final items = data?.surveyItems ?? [];

    final expenses = data?.expenses ?? [];
    final staffList = data?.staff ?? []; // if result null then pass data?.staff because reslut
    final labourList = data?.labour ?? []; // if result null then pass data?.labour

    final media = data?.media;
    final paymentSummary = data?.paymentSummary;


    final packingList = media?.packing ?? [];
    final unpackingList = media?.unpacking ?? [];

    String imageBaseUrl = "https://packnpay.in/uploads/";

    final int baseFare = paymentSummary?.baseFare ?? 0;
    final int gstAmount = paymentSummary?.taxesAndSurcharges ?? 0;

    final int totalAmount = baseFare + gstAmount;

    final int expense = paymentSummary?.expenses ?? 0;
    final int advance = paymentSummary?.advancePayment ?? 0;

    final int totalPayable = totalAmount + expense - advance;
    double totalExpense = 0;

    for (var e in expenses) {
      totalExpense += double.tryParse(e.amount ?? "0") ?? 0;
    }
    final statusLogs = data?.statusLogs ?? [];
    final statusTimeline = data?.statusTimeline ?? [];

    return Scaffold(
      backgroundColor: AppColors.bodysecondry,

      appBar: AppBar(
        surfaceTintColor: AppColors.mWhite,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "order.title".tr(),
          style: TextStyles.f16w600mGray9,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/pdf.svg",
              width: 22,
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/expense.svg",
              width: 22,
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.more_vert,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //hide if null
                 // OrderStatusStepper(currentStep: 0),

                  OrderStatusStepper(logs: statusLogs,timeline: statusTimeline,),
                  const SizedBox(height: 16),
                  //ShipmentStatusStepper(currentStep: 1),
                  ShipmentStatusStepper(logs: statusLogs),
                  const SizedBox(height: 10),

                  //Order details
                  CustomExpansionSection(
                    title: "order.orderDetails".tr(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(
                                "order.orderNo".tr(),
                                style: TextStyles.f10w400Gray6,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${data?.existingOrderNo ?? data?.orderNo ?? ""}",
                                style: TextStyles.f12w600Gray5,
                              ),
                            ],
                          ),
                          const SizedBox(width: 24), // spacing between columns
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(
                                "order.quotationNo".tr(),
                                style: TextStyles.f10w400Gray6,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${data?.linkedQuotation?.quotationNo ?? "-"}",
                                style: TextStyles.f12w600Gray5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  //Order Status
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("order.orderStatus".tr(), style: TextStyles.f12w600Gray9),
                        InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (_) => ChangeStatusDialog(
                                uid: data?.existingOrderUid ?? "",
                                logs: statusLogs,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Change Status",
                              style: TextStyles.f12w600Gray9.copyWith(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // "${data.shipmenStatus}",
                              getStatus(data?.shipmenStatus),
                              style: TextStyles.f12w700pinkish
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     showDialog(
                          //       context: context,
                          //       builder: (_) => ChangeStatusDialog(
                          //         uid: data?.existingOrderUid ?? "",
                          //         logs: logs,
                          //       ),
                          //     );
                          //   },
                          //   style: TextButton.styleFrom(
                          //     padding: EdgeInsets.zero,
                          //     minimumSize: Size(50, 30),
                          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //     alignment: Alignment.centerRight,
                          //   ),
                          //   child:  Text(
                          //     "Change Status",
                          //     style: TextStyles.f12w600Gray9.copyWith(
                          //       color: AppColors.primary, // Primary color
                          //       decoration: TextDecoration.underline, // Underline
                          //
                          //
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),

                  //Staff
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("order.staff".tr(), style: TextStyles.f12w600Gray9),

                        InkWell(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => ManagePeoplePopup(
                                title: "Manage Staff",
                                people: staffList.map((e) {
                                  return {
                                    "name": e.name ?? "",
                                    "role": "Staff",
                                    "id": e.userId?.toString() ?? "",
                                  };
                                }).toList(),
                              ),
                            );
                            print("Staff   >>>>>>>>>>>>>>$result");

                            if (result != null) {
                              final message = await ref.read(orderDetailProvider.notifier).updateOrder(
                                id: pickup?.quotationId ?? -1,
                                uid: data?.existingOrderUid ?? "",
                                vehicleNo: data?.vehicleNo,
                                driverName: data?.driverName,
                                driverPhone: data?.driverPhone,
                                driverLicense: data?.driverLicense,


                                staff: result, // ✅ PASS STAFF
                                labour: labourList.map((e) => {
                                  "user_id": e.userId,
                                  "role_label": e.roleLabel ?? "Labour",
                                }).toList(),
                                expenses: expenses.map((e) {
                                  final parsedAmount = double.tryParse(e.amount ?? "0")?.toInt() ?? 0;
                                  return {
                                    "category_id": e.categoryId,
                                    "amount": parsedAmount,
                                  };
                                }).toList(),

                              );

                              if (message == "Order updated successfully") {
                                ToastHelper.showSuccess(message: message!);
                              } else {
                                ToastHelper.showError(message: message ?? "Error");
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Edit",
                              style: TextStyles.f12w600Gray9.copyWith(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// ✅ SHOW ALL STAFF (NOT ONLY FIRST)
                    children: staffList.isEmpty
                        ? [
                      Text("order.addStaff".tr(), style: TextStyles.f12w500Gray7),
                    ]
                        : staffList.map((e) {
                      return Padding(
                        padding:  EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: "${e.name ?? "-"}\n",
                                  style: TextStyles.f12w700primary,
                                  children: [
                                    TextSpan(
                                      text: "Staff ID: ",
                                      style: TextStyles.f9w400mGray5,
                                    ),
                                    TextSpan(
                                      text: "${e.userId ?? "-"}",
                                      style: TextStyles.f9w400mGray5.copyWith(
                                        color: AppColors.mGray9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  //LAbour
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("order.labours".tr(), style: TextStyles.f12w600Gray9),

                        InkWell(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => ManagePeoplePopup(
                                title: "Manage Labours",
                                people: labourList.map((e) {
                                  return {
                                    "name": e.name ?? "",
                                    "role": "Labour",
                                    "id": e.userId?.toString() ?? "",
                                  };
                                }).toList(),
                              ),
                            );
                            print("Labours   >>>>>>>>>>>>>>$result");
                            if (result != null) {
                              final message = await ref.read(orderDetailProvider.notifier).updateOrder(
                                id: pickup?.quotationId ?? -1,
                                uid: data?.existingOrderUid ?? "",
                                vehicleNo: data?.vehicleNo,
                                driverName: data?.driverName,
                                driverPhone: data?.driverPhone,
                                driverLicense: data?.driverLicense,
                                labour: result, // ✅ PASS LABOUR
                                staff: staffList.map((e) => {
                                  "user_id": e.userId,
                                  "role_label": e.roleLabel ?? "Staff",
                                }).toList(),
                                expenses: expenses.map((e) {
                                  final parsedAmount = double.tryParse(e.amount ?? "0")?.toInt() ?? 0;
                                  return {
                                    "category_id": e.categoryId,
                                    "amount": parsedAmount,
                                  };
                                }).toList(),
                              );

                              if (message == "Order updated successfully") {
                                ToastHelper.showSuccess(message: message!);
                              } else {
                                ToastHelper.showError(message: message ?? "Error");
                              }
                            }
                          },

                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Edit",
                              style: TextStyles.f12w600Gray9.copyWith(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// ✅ SHOW ALL LABOURS
                    children: labourList.isEmpty
                        ? [
                      Text("order.addLabour".tr(), style: TextStyles.f12w500Gray7),
                    ]
                        : labourList.map((e) {
                      return Padding(
                        padding:  EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: "${e.name ?? "-"}\n",
                                  style: TextStyles.f12w700primary,
                                  children: [
                                    TextSpan(
                                      text: "Labour ID: ",
                                      style: TextStyles.f9w400mGray5,
                                    ),
                                    TextSpan(
                                      text: "${e.userId ?? "-"}",
                                      style: TextStyles.f9w400mGray5.copyWith(
                                        color: AppColors.mGray9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  /// ================= Quotation DETAILS =================
                  CustomExpansionSection(
                    title: "order.quotationDetails".tr(),
                    children: [
                      Wrap(
                        spacing: 80,
                        runSpacing: 16,
                        children: [
                          _quotationItem("order.quotationNo".tr(), data?.quotationNo ?? "-"),

                          _quotationItem("quotation.companyOrPartyName".tr(), data?.companyOrPartyName ?? "-"),

                          _quotationItem("quotation.partyName".tr(), data?.partyName ?? "-"),

                          _quotationItem("quotation.companyGst".tr(), data?.gstNo ?? "-"),

                          _quotationItem("quotation.phoneNo".tr(), data?.phone ?? "-"),

                          _quotationItem("quotation.email".tr(), data?.email ?? "-"),

                          _quotationItem("quotation.quotationDate".tr(), formatDate(data?.quotationDate)),

                          _quotationItem("quotation.packingDate".tr(), formatDate(data?.packingDate)),

                          _quotationItem("quotation.deliveryDate".tr(), formatDate(data?.deliveryDate)),

                          _quotationItem("quotation.loadType".tr(),  data?.loadType ?? "-"),

                          _quotationItem("quotation.vehicleType".tr(), data?.vehicleType ?? "-"),

                          _quotationItem("quotation.movingPath".tr(), data?.movingPath ?? "-"),

                          _quotationItem("packageDetails.remarks".tr(), data?.remarks ?? "-"),
                        ],
                      ),
                    ],
                  ),

                  //Vehicle Details
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("order.vehicleDetails".tr(), style: TextStyles.f12w600Gray9),

                        InkWell(
                          onTap: (){
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black.withOpacity(0.5),
                              // builder: (context) => const VehicleDetailsPopup(),
                              builder: (context) => VehicleDetailsPopup(
                                orderId: pickup?.quotationId ?? -1,
                                quotationId: data?.existingOrderUid ?? "",

                                vehicleNo: data?.vehicleNo,
                                driverName: data?.driverName,
                                driverPhone: data?.driverPhone,
                                driverLicense: data?.driverLicense,
                                staff: staffList.map((e) => {
                                  "user_id": e.userId,
                                  "role_label": e.roleLabel ?? "Staff",
                                }).toList(),
                                labour: labourList.map((e) => {
                                  "user_id": e.userId,
                                  "role_label": e.roleLabel ?? "Labour",
                                }).toList(),
                                expenses: expenses.map((e) {
                                  return {
                                    "category_id": e.categoryId,
                                    "amount":  double.tryParse(e.amount ?? "0")?.toInt() ?? 0,
                                  };
                                }).toList(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text("Edit",
                                style: TextStyles.f12w600Gray9.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ),
                      ],
                    ),
                    children: [

                      /// ROW 1
                      Row(
                        children: [
                          Expanded(
                            child: _vehicleItem(
                              "lr.fields.vehicleNo".tr(),
                              "${data?.vehicleNo ?? "-"}",
                            ),
                          ),
                          Expanded(
                            child: _vehicleItem(
                              "lr.fields.driverPhone".tr(),
                              "${data?.driverPhone ?? "-"}",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// ROW 2
                      Row(
                        children: [
                          Expanded(
                            child: _vehicleItem(
                              "lr.fields.driverName".tr(),
                              "${data?.driverName ?? "-"}",
                            ),
                          ),
                          Expanded(
                            child: _vehicleItem(
                              "lr.fields.driverLicense".tr(),
                              data?.driverLicense ?? "-",
                            ),
                          ),
                        ],
                      ),
                    ],

                  ),


                  //Packing Details
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("order.packingDetails".tr(), style: TextStyles.f12w600Gray9),

                        InkWell(
                          onTap: (){
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black.withOpacity(0.5),
                              builder: (context) => DetailsUploadPopup(
                                title: "order.packingDetails".tr(),
                                hintText: "Enter a description...",
                                onSave: (description, images) async {
                                  final notifier = ref.read(orderDetailProvider.notifier);

                                  final result = await notifier.updatePackingAndUnpackingOrder(
                                    uid: data?.existingOrderUid ?? "",
                                    mediaType: "PACKING",
                                    // description: description,
                                    images: images,
                                  );

                                  /// ✅ SUCCESS / ERROR handling
                                  if (result != null && result.contains("success")) {
                                    ToastHelper.showSuccess(message: result);
                                  } else {
                                    ToastHelper.showError(message: result ?? "Error occurred");
                                  }


                                },
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text("Add Images",
                                style: TextStyles.f12w600Gray9.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      // Text(
                      //   "Remarks",
                      //   style: TextStyles.f12w500Gray7,
                      // ),
                      // const SizedBox(height: 6),
                      // Text(
                      //   "Lorem ipsum dolor sit amet consectetur. In phasellus sollicitudin nulla pretium porttitor vel pulvinar eget. Erat orci donec iaculis morbi nam id ipsum. Tempor a sit facilisi in. At ac sit tincidunt tincidunt sapien imperdiet ac elit viverra.",
                      //   style: TextStyles.f11w400Gray9,
                      // ),
                      // const SizedBox(height: 12),
                      SizedBox(
                        height: 70,
                        child: packingList.isEmpty
                            ? const Text("No images uploaded")
                            : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: packingList.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, index) {
                            final item = packingList[index];
                            final imageUrl = "$imageBaseUrl${item.filePath}";

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  //Unpacking Details
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("order.unpackingDetails".tr(), style: TextStyles.f12w600Gray9),

                        InkWell(
                          onTap: (){
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black.withOpacity(0.5),
                              builder: (context) => DetailsUploadPopup(
                                title: "order.unpackingDetails".tr(),
                                hintText: "Enter a description...",
                                onSave: (description, images) async {
                                  final notifier = ref.read(orderDetailProvider.notifier);

                                  final result = await notifier.updatePackingAndUnpackingOrder(
                                    uid: data?.existingOrderUid ?? "",
                                    mediaType: "UNPACKING",
                                    // description: description,
                                    images: images,
                                  );

                                  /// ✅ SUCCESS / ERROR handling
                                  if (result != null && result.contains("success")) {
                                    ToastHelper.showSuccess(message: result);
                                  } else {
                                    ToastHelper.showError(message: result ?? "Error occurred");
                                  }
                                },
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text("Add Images",
                                style: TextStyles.f12w600Gray9.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      // Text(
                      //   "Remarks",
                      //   style: TextStyles.f12w500Gray7,
                      // ),
                      // const SizedBox(height: 6),
                      // Text(
                      //   "Lorem ipsum dolor sit amet consectetur. In phasellus sollicitudin nulla pretium porttitor vel pulvinar eget. Erat orci donec iaculis morbi nam id ipsum. Tempor a sit facilisi in. At ac sit tincidunt tincidunt sapien imperdiet ac elit viverra.",
                      //   style: TextStyles.f11w400Gray9,
                      //),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 70,
                        child: unpackingList.isEmpty
                            ? const Text("No images uploaded")
                            : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: unpackingList.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, index) {
                            final item = unpackingList[index];
                            final imageUrl = "$imageBaseUrl${item.filePath}";

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  /// ================= PICKUP =================
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      children: [
                        GradientTitleWidget(title: 'Pickup Details                  '),
                        Expanded(child: Container(height: 1, color: Colors.orange)),
                      ],
                    ),
                    children: [
                      Wrap(
                        spacing: 80,
                        runSpacing: 12,
                        children: [
                          _quotationItem("movingDetails.shiftingMovingDate".tr(), formatDate(pickup?.movingDate)),

                          _quotationItem("movingDetails.state".tr(),
                              pickup?.stateName ?? "-"),

                          _quotationItem("movingDetails.lift".tr(),
                              pickup?.liftAvailable ?? "-"),

                          _quotationItem("common.contactDetails".tr(),
                              "${pickup?.phone ?? '-'}\n${pickup?.email ?? ''}"),

                          _quotationItem("movingDetails.city".tr(),
                              pickup?.cityName ?? "-"),

                          _quotationItem("movingDetails.address".tr(),
                              pickup?.address ?? "-"),
                        ],
                      ),
                    ],
                  ),

                  /// ================= DELIVERY =================
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      children: [
                        GradientTitleWidget(title: 'Delivery Details                  '),
                        Expanded(child: Container(height: 1, color: Colors.orange)),
                      ],
                    ),
                    children: [
                      Wrap(
                        spacing: 80,
                        runSpacing: 12,
                        children: [
                          _quotationItem("movingDetails.shiftingMovingDate".tr(), formatDate(delivery?.movingDate)),

                          _quotationItem("movingDetails.state".tr(),
                              delivery?.stateName ?? "-"),

                          _quotationItem("movingDetails.lift".tr(),
                              delivery?.liftAvailable ?? "-"),

                          _quotationItem("common.contactDetails".tr(),
                              "${delivery?.phone ?? '-'}\n${delivery?.email ?? ''}"),

                          _quotationItem("movingDetails.city".tr(),
                              delivery?.cityName ?? "-"),

                          _quotationItem("movingDetails.address".tr(),
                              delivery?.address ?? "-"),
                        ],
                      ),
                    ],
                  ),

                  /// ================= ITEMS =================
                  CustomExpansionSection(
                    title: "${"order.item".tr()}(${items.length})",
                    children: [
                      _ItemsHeaderRow(),
                      const SizedBox(height: 4),

                      items.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("No items added"),
                      )
                          : ListView.separated(
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) =>
                            Container(height: 1, color: AppColors.mGray4),
                        itemBuilder: (_, index) {
                          final item = items[index];

                          return _ItemRow(
                            index: index,
                            name: item.itemName ?? "-",
                            qty: item.quantity ?? 0,
                            price: item.shiftingCharge ?? 0,
                            category: item.categoryName ?? "-",
                          );
                        },
                      ),
                    ],
                  ),

                  /// ================= INSURANCE =================
                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      children: [
                        GradientTitleWidget(title: 'Insurance Details                '),
                        Expanded(child: Container(height: 1, color: Colors.orange)),
                      ],
                    ),
                    children: [
                      Wrap(
                        spacing: 80,
                        runSpacing: 12,
                        children: [
                          _quotationItem("Insurance type", data?.insuranceType ?? "-"),

                          _quotationItem("Insurance charge(%)", "${data?.insuranceCharge ?? '0'}%"),
                          _quotationItem("Insurance gst", "${data?.insuranceGst ?? '0'}%"),

                          SizedBox(
                            width: double.infinity,
                            child: _quotationItem(
                              "Declaration of goods",
                              data?.declarationOfGoods ?? "-",
                              3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),


                  CustomExpansionSection(
                    title: "",
                    titleWidget: Row(
                      children: [
                        GradientTitleWidget(title: 'Vehicle Insurance                '),
                        Expanded(child: Container(height: 1, color: Colors.orange)),
                      ],
                    ),
                    children: [
                      Wrap(
                        spacing: 80,
                        runSpacing: 12,
                        children: [
                          _quotationItem("Insurance type", data?.vehicleInsuranceType ?? "-"),

                          _quotationItem("Insurance charge(%)", "${data?.vehicleInsuranceCharge ?? '0'}%"),
                          _quotationItem("Insurance gst", "${data?.vehicleInsuranceGst ?? '0'}%"),

                          SizedBox(
                            width: double.infinity,
                            child: _quotationItem(
                              "Declaration of goods",
                              data?.declarationOfVehicle ?? "-",
                              3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  ///Other Details
                  CustomExpansionSection(
                    title:"",
                    titleWidget: Row(
                      children: [
                        GradientTitleWidget(title: 'Other Details                    '),
                        Expanded( // ✅ NOW safe (because parent is bounded)
                          child: Container(
                            height: 1,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 10,)
                      ],
                    ),
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: _quotationItem(
                          "IS THERE EASY ACCESS FOR LOAD & UNLOADING AT ORIGIN & DESTINATION(क्या लोड और अनलोडिंग आसान है?",
                          data?.easyAccess ?? "-",
                          3,
                          2
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: _quotationItem(
                            "SHOULD ANY ITEMS BE GOT DOWN THROUGH BALCONY ETC.(क्या किसी सामान को बालकनी से नीचे उतारना है?)",
                            data?.balconyItems ?? "-",
                            3,
                            2
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: _quotationItem(
                            "ARE THERE ANY RESTRICTIONS FOR LOADING AT ORIGIN/DESTINATION (क्या लोडिंग/अनलोडिंग वाले स्थान पर कोई रोकेटोक है?)",
                            data?.loadingRestrictions ?? "-",
                            1,
                            2
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: _quotationItem(
                            "ARE THERE ANY RESTRICTIONS FOR UNLOADING AT ORIGIN/DESTINATION (क्या लोडिंग/अनलोडिंग वाले स्थान पर कोई रोकेटोक है?)",
                            data?.unloadingRestrictions ?? "-",
                            1,
                            2
                        ),
                      ),

                      SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: _quotationItem(
                            "DO YOU HAVE ANY SPECIAL NEEDS OR CONCERNT(अन्य जरूरी आवश्यकताएं?)",
                            data?.specialNeeds ?? "-",
                            1,
                            2
                        ),
                      ),
                    ],
                  ),

                  ///Payment Details
                  CustomExpansionSection(
                    title:"",
                    titleWidget: Row(
                      children: [

                        GradientTitleRowWidget(
                          titleWidget: Row(
                           children: [
                             Text(
                               "Payment Details",
                               style: TextStyles.f10w500mWhite,
                             ),
                             SizedBox(width: 6,),
                             Text(
                               "Total Amount: ₹$totalAmount",
                               style: TextStyles.f10w700mBlack,
                             ),
                           ],
                          ),),
                        Expanded( // ✅ NOW safe (because parent is bounded)
                          child: Container(
                            height: 1,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 10,)
                      ],
                    ),
                    children: [
                      PaymentRowItem(title: "Freight Charge", amount: "₹ ${paymentSummary?.baseFare ?? "-"}"),
                      PaymentRowItem(title: "GST Amount", amount: "₹ ${paymentSummary?.taxesAndSurcharges ?? "-"}"),
                      PaymentRowItem(title: "GST %", amount: "${data?.gstPercent ?? "-"}"),
                      PaymentRowItem(title: "GST Type", amount: "${data?.gstType ?? "-"}"),
                      // PaymentRowItem(title: "Packing Charge", amount: "${paymentSummary?.advancePayment ?? "-"}"),
                      // PaymentRowItem(title: "Unpacking Charge", amount: "2000"),
                      // PaymentRowItem(title: "Loading Charge", amount: "2000"),
                      // PaymentRowItem(title: "Unloading Charge", amount: "2000"),
                      // PaymentRowItem(title: "Packing material charge", amount: "2000"),
                    ],
                  ),

                  ///Expenses
                  CustomExpansionSection(
                    title:"",
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        GradientTitleRowWidget(
                          titleWidget: Row(
                            children: [
                              Text(
                                "Expenses",
                                style: TextStyles.f10w500mWhite,
                              ),
                              SizedBox(width: 6,),
                              Text(
                                "Total Amount: ₹$totalExpense",
                                style: TextStyles.f10w700mBlack,
                              ),
                            ],
                          ),),

                        InkWell(
                          onTap: () async {

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(child: CircularProgressIndicator()),
                            );

                            /// ✅ API CALL
                            final categories = await ref
                                .read(orderDetailProvider.notifier)
                                .fetchExpenseCategories();

                            Navigator.pop(context); // ❌ remove loader

                            /// ✅ OPEN POPUP WITH DATA
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black.withOpacity(0.5),
                              builder: (context) => ExpensesPopup(
                                id: pickup?.quotationId ?? -1,
                                uid: data?.existingOrderUid ?? "",
                                vehicleNo: data?.vehicleNo,
                                driverName: data?.driverName,
                                driverPhone: data?.driverPhone,
                                driverLicense: data?.driverLicense,
                                existingExpenses: expenses,
                                categories: categories,
                                staff: staffList.map((e) => {
                                  "user_id": e.userId,
                                  "role_label": e.roleLabel ?? "Staff",
                                }).toList(),
                                labour: labourList.map((e) => {
                                  "user_id": e.userId,
                                  "role_label": e.roleLabel ?? "Labour",
                                }).toList(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text("Edit",
                                style: TextStyles.f12w600Gray9.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ),

                      ],
                    ),
                    children: expenses.map((e) {
                      return PaymentRowItem(
                        title: e.categoryName ?? "-",
                        amount: "₹ ${e.amount ?? "0"}",
                      );
                    }).toList(),
                  ),


                  ///Payment Summary
                  CustomExpansionSection(
                    title:"",
                    titleWidget: Row(
                      children: [
                        GradientTitleWidget(title: 'Payment Summary                    '),
                        Expanded( // ✅ NOW safe (because parent is bounded)
                          child: Container(
                            height: 1,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 10,)
                      ],
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("order.baseFare".tr(),style: TextStyles.f10w400Gray9),
                          Text("₹ ${paymentSummary?.baseFare ?? "-"}",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.mBlack)),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("order.taxes".tr(),style: TextStyles.f10w400Gray9),
                          Text("₹ ${paymentSummary?.taxesAndSurcharges ?? "-"}",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.mBlack)),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("order.expenses".tr(),style: TextStyles.f10w400Gray9),
                          Text("₹ ${paymentSummary?.expenses ?? "-"}",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.darkOrange)),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("order.advancePayment".tr(),style: TextStyles.f10w400Gray9),
                          Text("- ₹${paymentSummary?.advancePayment ?? "-"}",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.darkOrange)),
                        ],
                      ),
                      Container(height: 1,color: AppColors.mGray4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("order.totalAmount".tr(),style: TextStyles.f12w600Gray9),
                          Text("₹ ${totalPayable}",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),

                  CustomButton2(
                    onPressed: () async {
                      final quotationId = data?.quotationId;
                      if (quotationId == null) return;

                      print(">>>>>>>>>>>>>>${data?.existingOrderUid}");

                      if(data?.id !=null){
                        expenses.forEach((e) {
                          print("Category: ${e.categoryId}, Amount: ${e.amount}");
                        });

                        final message = await ref.read(orderDetailProvider.notifier).updateOrder(
                          id: pickup?.quotationId ?? -1,
                          uid: data?.existingOrderUid ?? "",
                          vehicleNo: data?.vehicleNo,
                          driverName: data?.driverName,
                          driverPhone: data?.driverPhone,
                          driverLicense: data?.driverLicense,
                          staff: staffList.map((e) => {
                            "user_id": e.userId,
                            "role_label": e.roleLabel ?? "Staff",
                          }).toList(),
                          labour: labourList.map((e) => {
                            "user_id": e.userId,
                            "role_label": e.roleLabel ?? "Labour",
                          }).toList(),
                          expenses: expenses.map((e) {
                            final parsedAmount = double.tryParse(e.amount ?? "0")?.toInt() ?? 0;
                            return {
                              "category_id": e.categoryId,
                              "amount": parsedAmount,
                            };
                          }).toList(),
                        );

                        if (message == "Order updated successfully") {
                          ToastHelper.showSuccess(message: message!);
                        } else {
                          ToastHelper.showError(message: message ?? "Error occurred");
                        }

                      }else{

                        final message = await ref.read(orderDetailProvider.notifier).createOrderAndRefresh(quotationId);
                        if (message == "Order created successfully") {
                          ToastHelper.showSuccess(message: message!);
                        } else {
                          ToastHelper.showError(message: message ?? "Error occurred");
                        }

                      }


                    },
                    width:220,
                    borderRadius: 6,
                    backgroundColor: AppColors.primary,
                    textWidget:  Text(
                      "Update Order",
                      style: TextStyles.f14w600Primary.copyWith(color: AppColors.mWhite),
                    ),

                    textStyle: TextStyles.f14w600Primary.copyWith(
                      color: AppColors.mWhite,
                    ),
                  ),


                ],
              ),
            ),
          ),

          if (state.isPageLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _vehicleItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  TextStyles.f10w500Gray7
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style:  TextStyles.f12w400Gray6H
        ),
      ],
    );
  }

  Widget _quotationItem(String label, String value,[int? maxLine,int? maxTitleLine]) {
    if (label.isEmpty) return const SizedBox();
    bool isAddress = label.toLowerCase() == "address";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyles.f10w500Gray7,
          maxLines:maxTitleLine ?? 1, // 👈 important
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyles.f12w400Gray6H,
          maxLines: isAddress ? 2 : maxLine ?? 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class PaymentRowItem extends StatelessWidget {
  final String title;
  final String amount;
  final VoidCallback? onPressed;

  const PaymentRowItem({
    super.key,
    required this.title,
    required this.amount,
     this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Left Title
          Text(
            title,
            style: TextStyles.f11w500Gray7,
          ),

          const SizedBox(width: 10),

          // Line Divider
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 1,
              color: Colors.grey.shade400,
            ),
          ),

          // Amount
          Text(
            "$amount",
            style: TextStyles.f11w400Gray5,
          ),
          if(onPressed!=null)
          InkWell(onTap: onPressed, child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: SvgPicture.asset("assets/images/x.svg"),
          ))
        ],
      ),
    );
  }
}

class _ItemsHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4)
      ),
      padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'ITEM',
              style: TextStyles.f10w500Gray6.copyWith(color: AppColors.mWhite),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'QTY.',
              style: TextStyles.f10w500Gray6.copyWith(color: AppColors.mWhite),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Value(rupee)',
              textAlign: TextAlign.center,
              style: TextStyles.f10w500Gray6.copyWith(color: AppColors.mWhite),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Remarks',
              textAlign: TextAlign.center,
              style: TextStyles.f10w500Gray6.copyWith(color: AppColors.mWhite),
            ),
          ),
        ],
      ),
    );
  }
}


class _ItemRow extends StatelessWidget {
  final int index;
  final String name;
  final int qty;
  final num price;
  final String category;

  const _ItemRow({
    required this.index,
    required this.name,
    required this.qty,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// ITEM NAME
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TextStyles.f10w400Gray6,
            ),
          ),

          /// QUANTITY
          Expanded(
            flex: 3,
            child: Text(
              qty.toString().padLeft(2, '0'),
              style: TextStyles.f10w700mGray9,
            ),
          ),

          /// PRICE
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                '₹$price',
                style: TextStyles.f10w400Gray6,
              ),
            ),
          ),

          /// CATEGORY
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                category,
                style: TextStyles.f10w400Gray6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

