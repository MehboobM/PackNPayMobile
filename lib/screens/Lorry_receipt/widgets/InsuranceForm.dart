import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_widget/custom_button.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../models/create_lorry_receipt.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/lorry_receiptnotifier.dart';
import '../../../notifier/lr_provider.dart';
import '../../../routes/route_names_const.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';
import '../../../utils/toast_message.dart';
import '../../Quotation/widget/insurance_and_other_form.dart';

class InsuranceForm extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const InsuranceForm({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<InsuranceForm> createState() => _InsuranceFormState();
}

class _InsuranceFormState extends ConsumerState<InsuranceForm> {
  /// Controllers with Dummy Data
  final TextEditingController insuranceCompanyController =
  TextEditingController();
  final TextEditingController policyNoController =
  TextEditingController();
  final TextEditingController insuredAmountController =
  TextEditingController();
  final TextEditingController insuranceDateController =
  TextEditingController();
  final TextEditingController insuranceRiskController =
  TextEditingController();
  final TextEditingController demurrageChargeController =
  TextEditingController();
  String? selectedInsuranceType;
  String? selectedDemurrageType;
  String? selectedDemurrageApplicable;

  bool materialInsuranceExpanded = true;
  bool demurrageExpanded = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(lrFormDataProvider);
      if (data.isNotEmpty) {
        _populateFields(data);
        setState(() {});
      }
    });
  }
  void _populateFields(Map<String, dynamic> data) {
    final insurance = data["insurance"] ?? {};
    final demurrage = data["demurrage"] ?? {};
    selectedInsuranceType = insurance["insurance_type"];
    insuranceCompanyController.text =
        insurance["company_name"] ?? "";
    policyNoController.text = insurance["policy_no"] ?? "";
    insuredAmountController.text =
        (insurance["insured_amount"] ?? "").toString();
    insuranceDateController.text =
        insurance["insurance_date"] ?? "";
    insuranceRiskController.text =
        insurance["insurance_risk"] ?? "";
    demurrageChargeController.text =
        (demurrage["charge"] ?? "").toString();
    selectedDemurrageType =
    demurrage["charge_type"];
    selectedDemurrageApplicable =
    demurrage["applicable_rule"];
  }

  @override
  Widget build(BuildContext context) {
    final dropdown = ref.read(dropdownProvider.notifier);

    final insuranceItems =
    dropdown.getLabels("insurance_type");

    final demurrageTypeItems =
    dropdown.getLabels("demurrage_charge_type");

    final demurrageApplicableItems =
    dropdown.getLabels("demurrage_applicable_rule");

    final insuranceLabel = dropdown.getLabelByValue(
        "insurance_type", selectedInsuranceType);

    final demurrageTypeLabel = dropdown.getLabelByValue(
        "demurrage_charge_type", selectedDemurrageType);

    final demurrageApplicableLabel = dropdown.getLabelByValue(
        "demurrage_applicable_rule",
        selectedDemurrageApplicable);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          /// ================= FORM CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ================= MATERIAL INSURANCE =================
                    _sectionHeader(
                      "materialInsurance.title".tr(),
                      materialInsuranceExpanded,
                          () => setState(() => materialInsuranceExpanded =
                      !materialInsuranceExpanded),
                    ),

                    if (materialInsuranceExpanded) ...[
                      /// FIX: Wrapped inside Row
                      Row(
                        children: [
                          reusableDropdown(
                            title:  "materialInsurance.title".tr(),
                            value: insuranceLabel,
                            items: insuranceItems,
                            onChanged: (val) {
                              setState(() {
                                selectedInsuranceType = dropdown
                                    .getValueByLabel(
                                    "insurance_type", val ?? "");
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      formLabel("materialInsurance.insuranceCompany".tr()),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: insuranceCompanyController,
                        hintText: "Enter",
                        borderRadius: 12,
                      ),

                      const SizedBox(height: 12),

                      formLabel("materialInsurance.policyNo".tr()),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: policyNoController,
                        hintText: "Enter",
                        borderRadius: 12,
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                formLabel("materialInsurance.insuredAmount".tr()),
                                const SizedBox(height: 6),
                                CustomTextField(
                                  controller:
                                  insuredAmountController,
                                  hintText: "₹",
                                  keyboardType:
                                  TextInputType.number,
                                  borderRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                formLabel("lr.fields.insuranceDate".tr()),
                                const SizedBox(height: 6),
                                CustomTextField(
                                  controller:
                                  insuranceDateController,
                                  hintText: "00/00/0000",
                                  materialIcon: Icons
                                      .calendar_today_outlined,
                                  borderRadius: 12,
                                  onTap: () => _pickDate(
                                      insuranceDateController),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      formLabel("lr.fields.riskDetails".tr()),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: insuranceRiskController,
                        hintText: "Enter desc.",
                        borderRadius: 12,
                      ),
                    ],

                    const SizedBox(height: 12),
                    const Divider(
                      thickness: 1.2,
                      color: AppColors.primary,
                    ),

                    /// ================= DEMURRAGE CHARGE =================
                    _sectionHeader(
                      "lr.fields.demurrageCharge".tr(),
                      demurrageExpanded,
                          () => setState(
                              () => demurrageExpanded = !demurrageExpanded),
                    ),

                    if (demurrageExpanded) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                amountWithDropdownField(
                                  label:  "lr.fields.demurrageCharge".tr(),
                                  controller: demurrageChargeController,
                                  items: demurrageTypeItems,
                                  selectedValue: demurrageTypeLabel,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedDemurrageType =
                                          dropdown.getValueByLabel(
                                            "lr.fields.demurrageCharge".tr(),
                                            val ?? "",
                                          );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 12),

                      /// FIX: Wrapped inside Row
                      Row(
                        children: [
                          reusableDropdown(
                            title: "demurrageCharge.demurrageChargeApplicable".tr(),
                            value: demurrageApplicableLabel,
                            items: demurrageApplicableItems,
                            onChanged: (val) {
                              setState(() {
                                selectedDemurrageApplicable =
                                    dropdown.getValueByLabel(
                                      "demurrage_applicable_rule",
                                      val ?? "",
                                    );
                              });
                            },
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),

          /// ================= BOTTOM BUTTONS =================
          _buildBottomBar(),
        ],
      ),
    );
  }
  /// ================= SECTION HEADER =================
  Widget _sectionHeader(
      String title, bool expanded, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyles.f14w600mGray9,
              ),
            ),
            Icon(
              expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  /// ================= DATE PICKER =================
  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text =
      "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";
    }
  }
  Widget amountWithDropdownField({
    required String label,
    required TextEditingController controller,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
    String prefixText = "₹",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formLabel(label),
        const SizedBox(height: 6),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              /// Currency Prefix
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  prefixText,
                  style: TextStyles.f12w400Gray6,
                ),
              ),

              /// Text Field
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: TextStyles.f12w400Gray9, // Input text style
                  decoration: InputDecoration(
                    hintText: "Enter",
                    hintStyle: TextStyles.f12w400Gray6, // Hint style
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              /// Divider
              Container(
                height: 28,
                width: 1,
                color: Colors.grey.shade300,
              ),

              /// Dropdown
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: selectedValue,
                  hint: Text(
                    "Select",
                    style: TextStyles.f12w400Gray6, // Hint style
                    overflow: TextOverflow.ellipsis,
                  ),
                  selectedItemBuilder: (context) {
                    return items.map((item) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item,
                          style:
                          TextStyles.f12w400Gray9, // Selected value style
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList();
                  },
                  items: items
                      .map(
                        (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style:
                        TextStyles.f12w400Gray9, // Dropdown list style
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: onChanged,
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    width: 130,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  /// ================= BOTTOM BAR =================
  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 🔙 Back Button
            Expanded(
              child: CustomButton(
                onPressed: widget.onBack,
                text: "Back",
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                borderColor: AppColors.primary,
                height: 48,
              ),
            ),
            const SizedBox(width: 12),
            /// 🚀 Submit Button
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  return CustomButton(
                    onPressed: () async {
                      final notifier =
                      ref.read(lorryReceiptProvider.notifier);
                      /// 🔹 Get Route Arguments
                      final args = ModalRoute.of(context)
                          ?.settings
                          .arguments as Map<String, dynamic>?;
                      final String? uidFromArgs = args?['uid'];
                      final bool isEdit = args?['isEdit'] ?? false;
                      /// ✅ Save Insurance & Demurrage Data
                      updateFormData(ref, {
                        "insurance": {
                          "insurance_type": selectedInsuranceType ?? "",
                          "company_name":
                          insuranceCompanyController.text.trim(),
                          "policy_no": policyNoController.text.trim(),
                          "insured_amount": double.tryParse(
                              insuredAmountController.text.trim()) ??
                              0,
                          "insurance_date":
                          insuranceDateController.text.trim(),
                          "insurance_risk":
                          insuranceRiskController.text.trim(),
                        },
                        "demurrage": {
                          "charge": double.tryParse(
                              demurrageChargeController.text.trim()) ??
                              0,
                          "charge_type": selectedDemurrageType ?? "",
                          "applicable_rule":
                          selectedDemurrageApplicable ?? "",
                        },
                      });
                      /// ✅ Get Complete Form Data
                      final formData = ref.read(lrFormDataProvider);
                      try {
                        /// Convert JSON to Request Model
                        final request =
                        CreateLorryReceiptRequest.fromJson(formData);
                        bool success;
                        /// ✏️ UPDATE EXISTING LR
                        if (isEdit && uidFromArgs != null) {
                          success = await notifier.updateLorryReceipt(
                            uidFromArgs,
                            request,
                          );
                        }
                        /// ➕ CREATE NEW LR
                        else {
                          success =
                          await notifier.createLorryReceipt(request);
                        }
                        if (!context.mounted) return;
                        if (success) {
                          /// 🎉 Success Toast
                          ToastHelper.showSuccess(
                            title: "Success",
                            message: isEdit
                                ? "Lorry Receipt Updated Successfully"
                                : "Lorry Receipt Created Successfully",
                          );
                          /// 🧹 Reset Form State
                          ref.read(lrFormDataProvider.notifier).state = {};
                          notifier.resetCreateState();
                          /// 🔄 Refresh List
                          await notifier.fetchLorryReceipts();
                          /// 🚀 Navigate to List Screen
                          Navigator.pop(context);
                        } else {
                          final error =
                              ref.read(lorryReceiptProvider).error ??
                                  "Something went wrong";

                          ToastHelper.showError(
                            title: "Error",
                            message: error,
                          );
                        }
                      } catch (e) {
                        ToastHelper.showError(
                          title: "Error",
                          message: e.toString(),
                        );
                      }
                    },
                    text: "Submit",
                    backgroundColor: AppColors.primary,
                    height: 48,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}