import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../../global_widget/build_common_dropdown.dart';
import '../../../global_widget/custom_button.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/lorry_receiptnotifier.dart';
import '../../../notifier/lr_provider.dart';
import '../../Quotation/widget/insurance_and_other_form.dart';

class PackagePaymentForm extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PackagePaymentForm({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<PackagePaymentForm> createState() =>
      _PackagePaymentFormState();
}

class _PackagePaymentFormState
    extends ConsumerState<PackagePaymentForm> {
  /// Controllers - Package Details
  final TextEditingController packageController =
  TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();
  final TextEditingController actualWeightController =
  TextEditingController();
  final TextEditingController chargedWeightController =
  TextEditingController();
  final TextEditingController conditionController =
  TextEditingController();
  final TextEditingController remarksController =
  TextEditingController();

  /// Controllers - Payment Details
  final TextEditingController freightToBeBilledController =
  TextEditingController();
  final TextEditingController freightPaidController =
  TextEditingController();
  final TextEditingController freightToPayController =
  TextEditingController();
  final TextEditingController totalBasicFreightController =
  TextEditingController();
  final TextEditingController loadingChargeController =
  TextEditingController();
  final TextEditingController unloadingChargeController =
  TextEditingController();
  final TextEditingController stChargeController =
  TextEditingController();
  final TextEditingController otherChargeController =
  TextEditingController();
  final TextEditingController lrCnChargeController =
  TextEditingController();

  String? selectedGst = "18%";
  String? selectedGstPaidBy = "Consignee";
  String selectedActualWeightUnit = "KG";
  String selectedChargedWeightUnit = "KG";
  final _formKey = GlobalKey<FormState>();


  bool packageExpanded = true;
  bool paymentExpanded = true;
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
    final package = data["package_details"] ?? {};
    final payment = data["payment_details"] ?? {};

    packageController.text = package["no_of_package"] ?? "";
    descriptionController.text = package["description"] ?? "";
    actualWeightController.text = package["actual_weight"] ?? "";
    chargedWeightController.text = package["charged_weight"] ?? "";
    conditionController.text = package["condition"] ?? "";
    remarksController.text = package["remarks"] ?? "";

    selectedActualWeightUnit =
        package["actual_weight_unit"] ?? "KG";
    selectedChargedWeightUnit =
        package["charged_weight_unit"] ?? "KG";

    freightToBeBilledController.text =
        payment["freight_to_be_billed"] ?? "";
    freightPaidController.text =
        payment["freight_paid"] ?? "";
    freightToPayController.text =
        payment["freight_to_pay"] ?? "";
    totalBasicFreightController.text =
        payment["total_basic_freight"] ?? "";
    loadingChargeController.text =
        payment["loading_charge"] ?? "";
    unloadingChargeController.text =
        payment["unloading_charge"] ?? "";
    stChargeController.text =
        payment["st_charge"] ?? "";
    otherChargeController.text =
        payment["other_charge"] ?? "";
    lrCnChargeController.text =
        payment["lr_cn_charge"] ?? "";

    selectedGst = payment["gst_percent"] ?? "18%";
    selectedGstPaidBy =
        payment["gst_paid_by"] ?? "Consignee";
  }

  @override
  Widget build(BuildContext context) {
    final dropdown = ref.read(dropdownProvider.notifier);
    final weightUnitItems = dropdown.getLabels("weight_unit");

    final gstItems = dropdown.getLabels("gst_percent");
    final gstPaidByItems = dropdown.getLabels("gst_paid_by");

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          /// ================= FORM CONTENT =================
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// ================= PACKAGE DETAILS =================
                      _sectionHeader(
                        "packageDetails.title".tr(),
                        packageExpanded,
                            () => setState(() => packageExpanded = !packageExpanded),
                      ),

                      if (packageExpanded) _buildPackageDetails(),

                      const Divider(
                        thickness: 1.2,
                        color: AppColors.primary,
                      ),

                      /// ================= PAYMENT DETAILS =================
                      _sectionHeader(
                        "paymentDetailsLR.title".tr(),
                        paymentExpanded,
                            () => setState(() => paymentExpanded = !paymentExpanded),
                      ),

                      if (paymentExpanded)
                        _buildPaymentDetails(gstItems, gstPaidByItems),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// ================= BOTTOM BAR =================
          _buildBottomBar(),
        ],
      ),
    );
  }

  /// ================= PACKAGE DETAILS =================
  Widget _buildPackageDetails() {
    final dropdown = ref.read(dropdownProvider.notifier);
    final weightUnitItems = dropdown.getLabels("weight_unit");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formLabel("packageDetails.noOfPackage".tr()),
        const SizedBox(height: 6),
        CustomTextField(
          controller: packageController,
          hintText: "Enter no.",
          keyboardType: TextInputType.number,
          borderRadius: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter number of packages";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        formLabel("packageDetails.description".tr()),
        const SizedBox(height: 6),
        CustomTextField(
          controller: descriptionController,
          hintText: "Enter desc.",
          borderRadius: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter description";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        /// Actual & Charged Weight
        Row(
          children: [
            Expanded(
              child: buildWeightField(
                title: "packageDetails.actualWeight".tr(),
                controller: actualWeightController,
                selectedUnit: selectedActualWeightUnit,
                units: weightUnitItems,
                onUnitChanged: (value) {
                  setState(() {
                    selectedActualWeightUnit = value!;
                  });
                },

              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildWeightField(
                title: "packageDetails.chargedWeight".tr(),
                controller: chargedWeightController,
                selectedUnit: selectedChargedWeightUnit,
                units: weightUnitItems,
                onUnitChanged: (value) {
                  setState(() {
                    selectedChargedWeightUnit = value!;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        formLabel("lr.fields.conditionNote".tr(),),
        const SizedBox(height: 6),
        CustomTextField(
          controller: conditionController,
          hintText: "Enter",
          borderRadius: 10,
        ),
        const SizedBox(height: 12),

        formLabel("lr.fields.remarks".tr(),),
        const SizedBox(height: 6),
        CustomTextField(
          controller: remarksController,
          hintText: "Enter remarks...",
          borderRadius: 10,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// ================= PAYMENT DETAILS =================
  Widget _buildPaymentDetails(
      List<String> gstItems, List<String> gstPaidByItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formLabel("packageDetails.freightToBeBilled".tr()),
        const SizedBox(height: 6),
        CustomTextField(
          controller: freightToBeBilledController,
          hintText: "Enter",
          borderRadius: 10,
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _currencyField(
                  "lr.fields.freightPaid".tr(), freightPaidController),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _currencyField(
                  "lr.fields.freightToPay".tr(), freightToPayController),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _currencyField( "lr.fields.basicFreight".tr(),
                  totalBasicFreightController),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _currencyField(
                  "lr.fields.loadingCharge".tr(), loadingChargeController),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _currencyField(
                  "lr.fields.unloadingCharge".tr(), unloadingChargeController),
            ),
            const SizedBox(width: 10),
            Expanded(
              child:
              _currencyField("lr.fields.stCharge".tr(), stChargeController),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _currencyField(
                  "lr.fields.otherCharge".tr(), otherChargeController),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _currencyField(
                  "lr.fields.lrCnCharge".tr(), lrCnChargeController),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: buildCommonDropdown(
                title: "lr.fields.gstPercent".tr(),
                value: selectedGst,
                items: gstItems,
                onChanged: (value) {
                  setState(() => selectedGst = value);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildCommonDropdown(
                title: "lr.fields.gstPaidBy".tr(),
                value: selectedGstPaidBy,
                items: gstPaidByItems,
                onChanged: (value) {
                  setState(() => selectedGstPaidBy = value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ================= COMMON CURRENCY FIELD =================
  Widget _currencyField(
      String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formLabel(title),
        const SizedBox(height: 6),
        CustomTextField(
          controller: controller,
          hintText: "₹",
          keyboardType: TextInputType.number,
          borderRadius: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            }
            if (double.tryParse(value) == null) {
              return "Invalid amount";
            }
            return null;
          },
        ),
      ],
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
  /// ================= BOTTOM BAR =================
  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            Expanded(
              child: CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final notifier = ref.read(lorryReceiptProvider.notifier);

                    updateFormData(ref, {
                      "package_details": {
                        "no_of_package": packageController.text.trim(),
                        "description": descriptionController.text.trim(),
                        "actual_weight": actualWeightController.text.trim(),
                        "actual_weight_unit": selectedActualWeightUnit,
                        "charged_weight": chargedWeightController.text.trim(),
                        "charged_weight_unit": selectedChargedWeightUnit,
                        "condition": conditionController.text.trim(),
                        "remarks": remarksController.text.trim(),
                      },
                      "payment_details": {
                        "freight_to_be_billed":
                        freightToBeBilledController.text.trim(),
                        "freight_paid": freightPaidController.text.trim(),
                        "freight_to_pay": freightToPayController.text.trim(),
                        "total_basic_freight":
                        totalBasicFreightController.text.trim(),
                        "loading_charge": loadingChargeController.text.trim(),
                        "unloading_charge": unloadingChargeController.text.trim(),
                        "st_charge": stChargeController.text.trim(),
                        "other_charge": otherChargeController.text.trim(),
                        "lr_cn_charge": lrCnChargeController.text.trim(),
                        "gst_percent": selectedGst,
                        "gst_paid_by": selectedGstPaidBy,
                      },
                    });

                    widget.onNext();
                  }
                },
                text: "Save & Next  >>",
                iconRight: true,
                backgroundColor: AppColors.primary,
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildWeightField({
    required String title,
    required TextEditingController controller,
    required String? selectedUnit,
    required List<String> units,
    required Function(String?) onUnitChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formLabel(title),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mGray3),
          ),
          child: Row(
            children: [
              /// Text Field (Expands Fully)
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyles.f12w400Gray9,
                  decoration: const InputDecoration(
                    hintText: "Enter",
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
              ),
              /// Divider aligned to the right
              Container(
                width: 1,
                height: 28,
                color: AppColors.mGray3,
              ),
              /// Weight Unit Dropdown (Fixed Width)
              SizedBox(
                width: 80,
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    value: selectedUnit,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    style: TextStyles.f12w400Gray9,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    items: units.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: onUnitChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}