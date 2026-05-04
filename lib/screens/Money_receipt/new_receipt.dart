import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../global_widget/dropdown_with textfield.dart';
import '../../notifier/money_recepitform.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';
import '../Quotation/widget/insurance_and_other_form.dart';

class NewReceiptScreen extends ConsumerStatefulWidget {
  const NewReceiptScreen({super.key});

  @override
  ConsumerState<NewReceiptScreen> createState() =>
      _NewReceiptScreenState();
}

class _NewReceiptScreenState extends ConsumerState<NewReceiptScreen> {

  final receiptNoController = TextEditingController();
  final dateController = TextEditingController();
  final branchController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final quotationNoController = TextEditingController();
  final billDateController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();

  /// ✅ NEW CONTROLLERS
  final amountController = TextEditingController();
  final transactionController = TextEditingController();
  final remarksController = TextEditingController();

  /// ✅ DROPDOWN VALUES
  String receiptAgainst = "Quotation";
  String paymentType = "Part";
  String paymentMode = "Cash";
  String? uid; // 👈 add this


  bool isLoading = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is Map<String, dynamic>) {
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
    quotationNoController.text = data["receipt_against_id"] ?? "";
    billDateController.text =
        _formatDisplayDate(data["bill_quotation_date"]);
    fromController.text = data["move_from"] ?? "";
    toController.text = data["move_to"] ?? "";

    amountController.text =
        double.tryParse(data["receipt_amount"].toString())
            ?.toStringAsFixed(0) ??
            "";

    transactionController.text = data["transaction_no"] ?? "";
    remarksController.text = data["remarks"] ?? "";

    receiptAgainst = data["receipt_against"] ?? "Quotation";
    paymentType = data["payment_type"] ?? "Part";
    paymentMode = data["payment_mode"] ?? "Cash";
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
      "receipt_against_id": quotationNoController.text,
      "bill_quotation_date": formatDate(billDateController.text),
      "move_from": fromController.text,
      "move_to": toController.text,
      "payment_type": paymentType,
      "receipt_amount": double.parse(amountController.text),
      "payment_mode": paymentMode,
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
    quotationNoController.dispose();
    billDateController.dispose();
    fromController.dispose();
    toController.dispose();
    amountController.dispose();
    transactionController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(moneyReceiptFormProvider);
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
                    buildField("receipt.phoneNo".tr(), phoneController, "Enter phone no.",
                        keyboard: TextInputType.phone),

                    DropdownWithField(
                      title: "receipt.receiptAgainst".tr(),
                      value: receiptAgainst,
                      items: ["Quotation", "Bill"],
                      controller: quotationNoController,
                      hintText: "Enter Qat. no.",
                      onChanged: (val) {
                        setState(() {
                          receiptAgainst = val!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    buildDateField("receipt.billAndQuotationDate".tr(), billDateController),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: buildField("receipt.moveFrom".tr(), fromController, "Enter"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildField("receipt.moveTo".tr(), toController, "Enter"),
                        ),
                      ],
                    ),

                    /// 🔹 PAYMENT TYPE + AMOUNT
                    Row(
                      children: [
                        reusableDropdown(
                          title: "receipt.paymentType".tr(),
                          value: paymentType,
                          items: ["Part", "Full"],
                          onChanged: (val) {
                            setState(() {
                              paymentType = val!;
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
                      value: paymentMode,
                      items: ["Cash", "Online", "Cheque"],
                      controller: transactionController,
                      hintText: "Enter Transaction no.",
                      onChanged: (val) {
                        setState(() {
                          paymentMode = val!;
                        });
                      },
                    ),

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
      {TextInputType keyboard = TextInputType.text}) {
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