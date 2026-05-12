import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../global_widget/common_state_city_dropdown.dart';
import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../global_widget/dropdown_with textfield.dart';
import '../../models/city_modal.dart';
import '../../models/dropdown_item.dart';
import '../../notifier/money_recepitform.dart';
import '../../notifier/moneyreceipt_notifier.dart';
import '../../notifier/survey_moving_city_notifier.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';
import '../Quotation/widget/insurance_and_other_form.dart';

class NewReceiptScreen extends ConsumerStatefulWidget {
  const NewReceiptScreen({super.key});

  @override
  ConsumerState<NewReceiptScreen> createState() => _NewReceiptScreenState();
}

class _NewReceiptScreenState extends ConsumerState<NewReceiptScreen> {

  final receiptNoController = TextEditingController();
  final dateController = TextEditingController();
  final branchController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final orderNoController = TextEditingController();
  final billDateController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();

  /// ✅ NEW CONTROLLERS
  final amountController = TextEditingController();
  final transactionController = TextEditingController();
  final remarksController = TextEditingController();

  /// ✅ DROPDOWN VALUES
  String receiptAgainst = "Order";
  String paymentTypeValue = "Part";
  String paymentModeValue = "Cash";
  String? uid; // 👈 add this

  final paymentTypeLabels = [
    "Full Payment",
    "Part Payment",
    "Advance",
  ];

  final paymentTypeValues = [
    "Full",
    "Part",
    "Advance",
  ];

  final paymentModeLabels = [
    "Cash",
    "Cheque",
    "Online",
    "UPI",
    "NEFT",
    "RTGS",
  ];

  final paymentModeValues = [
    "Cash",
    "Cheque",
    "Online",
    "UPI",
    "NEFT",
    "RTGS",
  ];




  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      /// LOAD CITIES FIRST
      await ref.read(cityProviders.notifier).loadCities();

      /// PREFILL FROM ORDER
      final args = ModalRoute.of(context)?.settings.arguments;

      // here if args has this key then call this order_no_from_order


      /// CHECK ORDER NO FROM ORDER SCREEN
      if (args != null && args is Map<String, dynamic> && args.containsKey("order_no_from_order")) {
        print(
          "object>>>>>>FDdsf.>>>>${args["order_no_from_order"] ?? ""}",
        );
        final orderNo = args["order_no_from_order"];
        if (orderNo == null || orderNo.toString().trim().isEmpty) {
          return;
        }

        final response = await ref.read(moneyReceiptProvider).prefillByOrderNo(orderNo);

        final data = response["data"] ?? {};

        if (data.isNotEmpty) {

          /// POPULATE TEXTFIELDS
          _populateFields(data);

          /// RESTORE DROPDOWN
          final cityState = ref.read(cityProviders);

          try {

            final fromCityId = data["from_city_id"];
            final toCityId = data["to_city_id"];

            if (fromCityId != null) {
              selectedMovingFormCity = cityState.cities.firstWhere(
                    (e) => e.id == fromCityId,
              );
            }

            if (toCityId != null) {
              selectedMovingToCity = cityState.cities.firstWhere(
                    (e) => e.id == toCityId,
              );
            }

          } catch (e) {
            debugPrint("City restore error: $e");
          }

          if (mounted) {
            setState(() {});
          }
        }
        else{
          ToastHelper.showError(message: "Order not found for this id");
          //orderNoController.text = "";
        }
      }
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //this is initilaization from edit
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is Map<String, dynamic> && !args.containsKey("order_no_from_order")) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(args);
      });
    }
  }


  /// ✅ DATE FORMAT
  String formatDate(String input) {
    try {
      final parsed = DateFormat("dd/MM/yyyy").parse(input);
      return DateFormat("yyyy-MM-dd").format(parsed);
    } catch (e) {
      return "";
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    receiptNoController.text = data["receipt_no"] ?? "";
    dateController.text = _formatDisplayDate(data["receipt_date"]);
    branchController.text = data["branch"] ?? "";
    nameController.text = data["name"] ?? "";
    phoneController.text = data["phone"] ?? "";
    orderNoController.text = data["receipt_against_id"] ?? "";
    billDateController.text = _formatDisplayDate(data["bill_quotation_date"]);
    fromController.text = data["move_from"] ?? "";
    toController.text = data["move_to"] ?? "";

    amountController.text = double.tryParse(data["receipt_amount"].toString())?.toStringAsFixed(0) ?? "";

    transactionController.text = data["transaction_no"] ?? "";
    remarksController.text = data["remarks"] ?? "";

    receiptAgainst = data["receipt_against"] ?? "Quotation";
    paymentTypeValue = data["payment_type"] ?? "Part";
    paymentModeValue = data["payment_mode"] ?? "Cash";
    uid = data["uid"];
  }

  String _formatDisplayDate(String? date) {
    if (date == null || date.isEmpty) return "";

    try {
      final d = DateTime.parse(date); // handles ISO
      return "${d.day.toString().padLeft(2, '0')}/"
          "${d.month.toString().padLeft(2, '0')}/"
          "${d.year}";
    } catch (e) {
      return "";
    }
  }

  /// ✅ API CALL
  Future<void> saveReceipt() async {
    if (amountController.text.isEmpty ||
        int.tryParse(amountController.text) == null ||
        int.parse(amountController.text) <= 0) {
      ToastHelper.showError(message: "Enter valid amount");
      return;
    }

    final body = {
      "receipt_date": formatDate(dateController.text),
      "branch": branchController.text,
      "name": nameController.text,
      "phone": phoneController.text,
      "receipt_against": receiptAgainst,
      "receipt_against_id": orderNoController.text,
      "bill_quotation_date": formatDate(billDateController.text),
      "move_from": fromController.text,
      "move_to": toController.text,
      "payment_type": paymentTypeValue,
      "receipt_amount": double.parse(amountController.text),
      "payment_mode": paymentModeValue,
      "transaction_no": transactionController.text.isEmpty
          ? null
          : transactionController.text,
      "remarks": remarksController.text,
    };

    try {
      await ref
          .read(moneyReceiptFormProvider.notifier)
          .saveReceipt(body: body, uid: uid);

      ToastHelper.showSuccess(
        message: uid != null
            ? "Receipt updated successfully"
            : "Receipt created successfully",
      );

      Navigator.pop(context, true); // 👈 return true
    } catch (e) {
      ToastHelper.showError(message: e.toString());
    }
  }

  @override
  void dispose() {
    receiptNoController.dispose();
    dateController.dispose();
    branchController.dispose();
    nameController.dispose();
    phoneController.dispose();
    orderNoController.dispose();
    billDateController.dispose();
    fromController.dispose();
    toController.dispose();
    amountController.dispose();
    transactionController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  CityModel? selectedMovingFormCity;
  CityModel? selectedMovingToCity;

  void showPincodeDialog({
    required BuildContext context,
    required Function(CityModel city) onSelected,
  }) {
    final pinCtrl = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TITLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Find Pickup City",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Enter 6-digit pincode to locate city & state",
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: pinCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: "e.g. 560068",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        counterText: "",
                      ),
                    ),

                    const SizedBox(height: 12),

                    CustomButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (pinCtrl.text.length != 6) {
                            ToastHelper.showError(
                                message: "Enter valid pincode");
                            return;
                          }

                          setStateDialog(() {
                            isLoading = true;
                          });

                          try {
                            final city = await ref.read(cityProviders.notifier).getCityByPincode(pinCtrl.text);

                            Navigator.pop(context);

                            if (city != null) {
                              onSelected(city);
                            }
                          } catch (e) {
                            ToastHelper.showError(
                                message: "Invalid pincode");
                          }

                          setStateDialog(() {
                            isLoading = false;
                          });
                        },
                        backgroundColor: AppColors.primary,
                        text: "Find City")

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(moneyReceiptFormProvider);
    final cityState = ref.watch(cityProviders);

    final cityItems = cityState.cities.map((e) {
      return DropdownItem(
        value: e.id.toString(),
        label: e.displayName, // "Bangalore, Karnataka"
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),

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
              Text(
                formState.isEdit ? "Edit Receipt" : "New Receipt",
                style: TextStyles.f16w600mGray9,
              ),

              /// ✅ SHOW ONLY IF AVAILABLE
              if (receiptNoController.text.isNotEmpty) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.tab,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    receiptNoController.text,
                    style: TextStyles.f10w500primary,
                  ),
                ),
              ],
            ],
          ),
        ),


      body: Column(
        children: [
          Container(height: 14, color: AppColors.mGray3),

          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    /// 🔹 RECEIPT NO + DATE
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("receipt.receiptNo".tr(), style: TextStyles.f12w500Gray7),
                              const SizedBox(height: 6),
                              CustomTextField(
                                controller: receiptNoController,
                                isEnable: false,
                                hintText: "#PNP0001",
                                backgroundColor: const Color(0xFFF3F3F3),
                                borderRadius: 12,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("receipt.date".tr(), style: TextStyles.f12w500Gray7),
                              const SizedBox(height: 6),
                              CustomTextField(
                                controller: dateController,
                                hintText: "00/00/0000",
                                materialIcon: Icons.calendar_today_outlined,
                                borderRadius: 12,
                                onTap: () => pickDate(dateController),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    buildField("receipt.branch".tr(), branchController, "Enter Branch"),
                    buildField("receipt.name".tr(), nameController, "Enter name"),
                    buildField(
                        "receipt.phoneNo".tr(),
                        phoneController,
                        "Enter phone no.",
                        keyboard: TextInputType.phone
                    ),

                    buildField(
                        "order.orderNo".tr(),
                        orderNoController,
                        "Enter Order no.",
                        onChanged: (val) {

                          if (_debounce?.isActive ?? false) {
                            _debounce?.cancel();
                          }

                          _debounce = Timer(
                            const Duration(milliseconds: 700),
                                () async {

                              if (val.trim().isEmpty) return;

                              try {

                                final response = await ref
                                    .read(moneyReceiptProvider)
                                    .prefillByOrderNo(val);

                                final data = response["data"] ?? {};

                                if (data.isNotEmpty) {

                                  _populateFields(data);

                                  final cityState = ref.read(cityProviders);

                                  final fromCityId = data["from_city_id"];
                                  final toCityId = data["to_city_id"];

                                  if (fromCityId != null) {
                                    selectedMovingFormCity = cityState.cities.firstWhere(
                                          (e) => e.id == fromCityId,
                                    );
                                  }

                                  if (toCityId != null) {
                                    selectedMovingToCity = cityState.cities.firstWhere(
                                          (e) => e.id == toCityId,
                                    );
                                  }

                                  setState(() {});
                                } else {

                                  ToastHelper.showError(
                                    message: "Order not found for this id",
                                  );
                                }

                              } catch (e) {

                                ToastHelper.showError(
                                  message: "Order not found for this id",
                                );
                              }
                            },
                          );
                        }
                    ),


                    buildDateField("receipt.billAndQuotationDate".tr(), billDateController),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        /// Moving From Dropdown
                        Expanded(
                          child: commonStateCityDropdowns(
                            title: "lr.fields.movingFrom".tr(),
                            addButton: InkWell(
                              onTap: () {
                                showPincodeDialog(
                                  context: context,
                                  onSelected: (city) {
                                    setState(() {
                                      selectedMovingFormCity = city;
                                    });
                                  },
                                );
                              },
                              child: Icon(Icons.add_circle_outline,color: AppColors.primary,size: 18,),
                            ),
                            isRequired: false,
                            value: selectedMovingFormCity?.id.toString(),
                            items: cityItems,
                            onChanged: (item) {
                              if (item != null) {
                                final selected = cityState.cities.firstWhere(
                                      (e) => e.id.toString() == item.value,
                                );

                                setState(() {
                                  selectedMovingFormCity = selected;
                                  fromController.text = selected.name;

                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: commonStateCityDropdowns(
                            title: "lr.fields.movingTo".tr(),
                            addButton: InkWell(
                              onTap: () {
                                showPincodeDialog(
                                  context: context,
                                  onSelected: (city) {
                                    setState(() {
                                      selectedMovingToCity = city;
                                    });
                                  },
                                );
                              },
                              child: Icon(Icons.add_circle_outline,color: AppColors.primary,size: 18,),
                            ),
                            isRequired: false,
                            value: selectedMovingToCity?.id.toString(),
                            items: cityItems,
                            onChanged: (item) {
                              if (item != null) {
                                final selected = cityState.cities.firstWhere(
                                      (e) => e.id.toString() == item.value,
                                );

                                setState(() {
                                  selectedMovingToCity = selected;
                                  toController.text = selected.name;

                                });
                              }
                            },
                          ),
                        ),
                        // Expanded(
                        //   child: buildCommonDropdown(
                        //     title: "lr.fields.movingFrom".tr(),
                        //     value: selectedFromCity, // Keep null to show hint
                        //     items: cityNames,
                        //     onChanged: (value) {
                        //       if (value == null) return;
                        //
                        //       final selectedCity =
                        //       cities.firstWhere((c) => c.name == value);
                        //
                        //       setState(() {
                        //         selectedFromCity = value;
                        //         selectedFromCityId = selectedCity.id;
                        //       });
                        //     },
                        //   ),
                        // ),
                        //
                        // const SizedBox(width: 10),
                        //
                        // /// Moving To Dropdown
                        // Expanded(
                        //   child: buildCommonDropdown(
                        //     title: "lr.fields.movingTo".tr(),
                        //     value: selectedToCity, // Keep null to show hint
                        //     items: cityNames,
                        //     onChanged: (value) {
                        //       if (value == null) return;
                        //
                        //       final selectedCity =
                        //       cities.firstWhere((c) => c.name == value);
                        //
                        //       setState(() {
                        //         selectedToCity = value;
                        //         selectedToCityId = selectedCity.id;
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: buildField("receipt.moveFrom".tr(), fromController, "Enter"),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     Expanded(
                    //       child: buildField("receipt.moveTo".tr(), toController, "Enter"),
                    //     ),
                    //   ],
                    // ),

                    /// 🔹 PAYMENT TYPE + AMOUNT
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // reusableDropdown(
                        //   title: "receipt.paymentType".tr(),
                        //   value: paymentTypeValue,
                        //   items: ["Part", "Full"],
                        //   onChanged: (val) {
                        //     setState(() {
                        //       paymentTypeValue = val!;////replace with paymentTypeItem
                        //     });
                        //   },
                        //   flex: 1,
                        // ),

                        reusableDropdown(
                          title: "receipt.paymentType".tr(),
                          value: paymentTypeValue,
                          items: paymentTypeValues,
                          onChanged: (val) {
                            setState(() {
                              paymentTypeValue = val!;
                            });
                          },
                          flex: 1,
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("receipt.receiptAmount".tr(),style: TextStyles.f12w500Gray7),
                              const SizedBox(height: 6),
                              CustomTextField(
                                controller: amountController,
                                hintText: "₹",
                                keyboardType: TextInputType.number,
                                borderRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 PAYMENT MODE
                    DropdownWithField(
                      title: "receipt.paymentMode".tr(),
                      value: paymentModeValue,
                      items: paymentModeValues,
                      controller: transactionController,
                      hintText: "Enter Transaction no.",
                      onChanged: (val) {
                        setState(() {
                          paymentModeValue = val!;
                        });
                      },
                    ),
                    // DropdownWithField(
                    //   title: "receipt.paymentMode".tr(),
                    //   value: paymentModeValue,
                    //   items: ["Cash", "Online", "Cheque"],//replace with paymentModeItem
                    //   controller: transactionController,
                    //   hintText: "Enter Transaction no.",
                    //   onChanged: (val) {
                    //     setState(() {
                    //       paymentModeValue = val!;
                    //     });
                    //   },
                    // ),

                    const SizedBox(height: 16),

                    /// 🔹 REMARKS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("receipt.remarks".tr(), style: TextStyles.f12w500Gray7),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: remarksController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter remarks.....",
                            hintStyle: TextStyles.f12w400Gray5,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.mGray3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.mGray3),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                              BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Back",
                            onPressed: () => Navigator.pop(context, true),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            borderColor: AppColors.primary,
                            borderRadius: 10,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: formState.isLoading ? "Saving..." : "Save",
                            onPressed: formState.isLoading ? null : saveReceipt,
                            backgroundColor: AppColors.primary,
                            borderRadius: 10,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// 🔹 REUSABLE FIELD
  Widget buildField(String title, TextEditingController controller,
      String hint,
      {TextInputType keyboard = TextInputType.text,Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.f12w500Gray7),
          const SizedBox(height: 6),
          CustomTextField(
            controller: controller,
            hintText: hint,
            keyboardType: keyboard,
            borderRadius: 12,
            hintStyle: TextStyles.f12w400Gray5,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// 🔹 DATE FIELD
  Widget buildDateField(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.f12w500Gray7),
        const SizedBox(height: 6),
        CustomTextField(
          controller: controller,
          hintText: "00/00/0000",
          materialIcon: Icons.calendar_today_outlined,
          borderRadius: 12,
          onTap: () => pickDate(controller),
        ),
      ],
    );
  }

  /// 🔹 DATE PICKER
  Future<void> pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text =
      "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/"
          "${picked.year}";
    }
  }
}


// DropdownWithField(
//   title: "receipt.receiptAgainst".tr(),
//   value: receiptAgainst,
//   items: ["Quotation", "Bill"],
//   controller: orderNoController,
//   hintText: "Enter Qat. no.",
//   onChanged: (val) {
//     setState(() {
//       receiptAgainst = val!;
//     });
//   },
// ),