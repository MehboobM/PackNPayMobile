import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

import '../../../global_widget/build_common_dropdown.dart';
import '../../../global_widget/custom_button.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../notifier/city_notifier.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/lorry_receiptnotifier.dart';
import '../../../notifier/lr_provider.dart';
import '../../../utils/m_font_styles.dart';
import '../../Quotation/widget/insurance_and_other_form.dart';

class LRDetailsForm extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const LRDetailsForm({
    super.key,
    required this.onNext,
  });

  @override
  ConsumerState<LRDetailsForm> createState() =>
      _LRDetailsFormState();
}

class _LRDetailsFormState extends ConsumerState<LRDetailsForm> {
  String? selectedFromCity;
  String? selectedToCity;
  int? selectedFromCityId;
  int? selectedToCityId;
  /// ================= CONTROLLERS (UNCHANGED) =================
  final TextEditingController lrNoController =
  TextEditingController(text: "PNP0001");

  final TextEditingController dateController = TextEditingController();
  final TextEditingController orderIdController =
  TextEditingController(text: "ORD-0001");
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController altMobileController = TextEditingController();
  final TextEditingController invoiceAmountController =
  TextEditingController();
  final TextEditingController invoiceDateController = TextEditingController();
  final TextEditingController invoiceNoController = TextEditingController();
  final TextEditingController ewayBillNoController = TextEditingController();
  final TextEditingController ewayBillGenDateController = TextEditingController();
  final TextEditingController ewayBillExpireDateController = TextEditingController();
  final TextEditingController ewayBillExtendPeriodController = TextEditingController();

  /// ================= EXPAND STATES =================
  bool lrExpanded = true;
  bool truckExpanded = true;
  bool driverExpanded = true;
  bool invoiceExpanded = true;
  String? selectedRiskType;
  final FocusNode orderIdFocusNode = FocusNode();
  Timer? _debounce;
  Future<void> _fetchPrefillByOrderNo(String orderNo) async {
    if (orderNo.isEmpty) return;

    try {
      final data = await ref
          .read(lorryReceiptProvider.notifier)
          .prefillByOrderNo(orderNo);

      if (data.isNotEmpty) {
        // Store data for reuse across steps
        ref.read(lrFormDataProvider.notifier).state = data;

        // Populate fields in the form
        _populateFields(data);

        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No data found for this Order ID"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Listen for focus change on Order ID field
    orderIdFocusNode.addListener(() {
      if (!orderIdFocusNode.hasFocus) {
        final orderNo = orderIdController.text.trim();
        if (orderNo.isNotEmpty) {
          _fetchPrefillByOrderNo(orderNo);
        }
      }
    });

    // Populate data when editing existing LR
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(lrFormDataProvider);
      if (data.isNotEmpty) {
        _populateFields(data);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    orderIdController.dispose();
    orderIdFocusNode.dispose();
    super.dispose();
  }

  void _populateFields(Map<String, dynamic> data) {
    lrNoController.text = data["lr_no"] ?? "";
    orderIdController.text = data["order_id"] ?? "";
    dateController.text = _formatDisplayDate(data["lr_date"]);
    vehicleController.text = data["vehicle_no"] ?? "";
    driverNameController.text = data["driver_name"] ?? "";
    mobileController.text = data["driver_phone"] ?? "";
    altMobileController.text = data["driver_license"] ?? "";
    invoiceAmountController.text =
        (data["goods_value"] ?? "").toString();
    invoiceDateController.text =
        _formatDisplayDate(data["invoice_date"]);
    invoiceNoController.text = data["invoice_no"] ?? "";
    ewayBillNoController.text = data["eway_bill_no"] ?? "";
    ewayBillGenDateController.text =
        _formatDisplayDate(data["eway_bill_date"]);
    ewayBillExpireDateController.text =
        _formatDisplayDate(data["eway_expiry_date"]);
    ewayBillExtendPeriodController.text =
        _formatDisplayDate(data["eway_extend_date"]);

    selectedRiskType = data["risk_type"]?.toString().trim();
    selectedFromCity = data["moving_from"];
    selectedToCity = data["moving_to"];
  }

  String _formatDisplayDate(String? date) {
    if (date == null || date.isEmpty) return "";
    final parts = date.split("-");
    if (parts.length != 3) return date;
    return "${parts[2]}/${parts[1]}/${parts[0]}";
  }
  @override
  Widget build(BuildContext context) {
    final dropdown = ref.read(dropdownProvider.notifier);
    final citiesAsync = ref.watch(cityProvider);
    final riskTypeItems =
    dropdown.getLabels("risk_type").toSet().toList();
    // ✅ Fix invalid selected value
    if (selectedRiskType != null &&
        !riskTypeItems.contains(selectedRiskType)) {
      selectedRiskType = null;
    }
    selectedRiskType ??=
    riskTypeItems.isNotEmpty ? riskTypeItems.first : null;
    print("Risk Items: $riskTypeItems");
    print("Selected Risk: $selectedRiskType");
    return Container(
        color: Colors.white, // 👈 ADD THIS
        child: Column(
            children: [
    Expanded(
            child: SingleChildScrollView(
            child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= LR DETAILS =================
            sectionHeader(
              "lr.add.sections.lrDetails".tr(),
              lrExpanded,
                  () => setState(() => lrExpanded = !lrExpanded),
            ),

            if (lrExpanded) ...[
              formLabel("lr.fields.lrNo".tr(),),
              const SizedBox(height: 6),
              CustomTextField(
                controller: lrNoController,
                hintText: "#PNP0001",
                isEnable: false,
                borderRadius: 10,
              ),

              const SizedBox(height: 12),
              formLabel("lr.fields.orderId".tr(),),
              const SizedBox(height: 6),
              CustomTextField(
                controller: orderIdController,
                focusNode: orderIdFocusNode,
                hintText: "Enter Order ID",
                borderRadius: 10,
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  _debounce = Timer(const Duration(milliseconds: 600), () {
                    final orderNo = value.trim();
                    if (orderNo.isNotEmpty) {
                      _fetchPrefillByOrderNo(orderNo);
                    }
                  });
                },
              ),
              const SizedBox(height: 12),


              formLabel("lr.fields.date".tr(),),
              const SizedBox(height: 6),
              CustomTextField(
                controller: dateController,
                hintText: "00/00/0000",
                materialIcon: Icons.calendar_today,
                borderRadius: 10,

                onTap: () => _selectDate(dateController),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: buildCommonDropdown(
                  title: "lr.fields.riskType".tr(),
                  value: selectedRiskType,
                  items: riskTypeItems,
                  onChanged: (value) {
                    setState(() {
                      selectedRiskType = value;
                    });
                  },
                ),
              ),


              const SizedBox(height: 10),

            ],
            primaryDivider(),

            /// ================= TRUCK DETAILS =================
            sectionHeader(
              "lr.add.sections.truckDetails".tr(),
              truckExpanded, () => setState(() => truckExpanded = !truckExpanded),
            ),

            if (truckExpanded) ...[
              formLabel("lr.fields.vehicleNo".tr()),
              const SizedBox(height: 6),
              CustomTextField(
                controller: vehicleController,
                hintText: "Enter vehicle no.",
                borderRadius: 10,
              ),

              const SizedBox(height: 12),



              citiesAsync.when(loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),

                error: (error, stack) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      const Text(
                        "Failed to load cities",
                        style: TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: () => ref.refresh(cityProvider),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),

                data: (cities) {
                  // Prepare dropdown items
                  final cityNames = cities.map((city) => city.name).toList();

                  return Row(
                    children: [
                      /// Moving From Dropdown
                      Expanded(
                        child: buildCommonDropdown(
                          title: "lr.fields.movingFrom".tr(),
                          value: selectedFromCity, // Keep null to show hint
                          items: cityNames,
                          onChanged: (value) {
                            if (value == null) return;

                            final selectedCity =
                            cities.firstWhere((c) => c.name == value);

                            setState(() {
                              selectedFromCity = value;
                              selectedFromCityId = selectedCity.id;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// Moving To Dropdown
                      Expanded(
                        child: buildCommonDropdown(
                          title: "lr.fields.movingTo".tr(),
                          value: selectedToCity, // Keep null to show hint
                          items: cityNames,
                          onChanged: (value) {
                            if (value == null) return;

                            final selectedCity =
                            cities.firstWhere((c) => c.name == value);

                            setState(() {
                              selectedToCity = value;
                              selectedToCityId = selectedCity.id;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height:20),


            /// ================= DRIVER DETAILS =================
              sectionHeaderWithDivider(
                "lr.add.sections.driverDetails".tr(),
                driverExpanded,
                 () => setState(() => driverExpanded = !driverExpanded),
              ),
              const SizedBox(height: 20),


              formLabel("lr.fields.driverName".tr()),
              const SizedBox(height: 6),
              CustomTextField(
                controller: driverNameController,
                hintText: "Enter driver name",
                borderRadius: 10,
              ),

              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        formLabel("lr.fields.driverPhone".tr()),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: mobileController,
                          hintText: "Enter mobile no.",
                          keyboardType: TextInputType.phone,
                          borderRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formLabel("lr.fields.driverLicense".tr()),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: altMobileController,
                          hintText: "XXXX-XXXX-XXXX",
                          keyboardType: TextInputType.phone,
                          borderRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
            primaryDivider(),

            /// ================= INVOICE =================
            sectionHeader(
              //"Invoice & E-Bill",
              "invoiceEBill.title".tr(),
              invoiceExpanded,
                  () => setState(() => invoiceExpanded = !invoiceExpanded),
            ),

            if (invoiceExpanded) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formLabel( "invoiceEBill.invoiceAmount".tr(),),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: invoiceAmountController,
                          hintText: "₹",
                          keyboardType: TextInputType.number,
                          borderRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formLabel("invoiceEBill.invoiceDate".tr(),),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: invoiceDateController,
                          hintText: "00/00/0000",
                          materialIcon: Icons.calendar_today,
                          borderRadius: 10,
                          onTap: () => _selectDate(invoiceDateController),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              formLabel("invoiceEBill.invoiceBillNo".tr(),),
              const SizedBox(height: 6),

              CustomTextField(
                controller: invoiceNoController,
                hintText: "Enter invoice no.",
                borderRadius: 10,
              ),
              const SizedBox(height: 20),
              sectionHeaderWithDivider(
                "E-Way Bill",
                false,
                    () {},
              ),
              const SizedBox(height: 20),

              /// Row 1: E-way Bill Number & Generation Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formLabel("invoiceEBill.eWayBillNo".tr(),),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: ewayBillNoController,
                          hintText: "Enter no.",
                          borderRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formLabel("invoiceEBill.eWayBillGenerationDate".tr(),),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: ewayBillGenDateController,
                          hintText: "00/00/0000",
                          materialIcon: Icons.calendar_today,
                          borderRadius: 10,
                          onTap: () => _selectDate(ewayBillGenDateController),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Row 2: Expire Date & Extend Period
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formLabel("invoiceEBill.eWayBillExpireDate".tr(),),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: ewayBillExpireDateController,
                          hintText: "00/00/0000",
                          materialIcon: Icons.calendar_today,
                          borderRadius: 10,
                          onTap: () => _selectDate(ewayBillExpireDateController),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formLabel("E-way Bill Extend Period"),
                     //   formLabel("invoiceEBill.eWayBillPeriod".tr(),),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: ewayBillExtendPeriodController,
                          hintText: "00/00/0000",
                          materialIcon: Icons.calendar_today,
                          borderRadius: 10,
                          onTap: () => _selectDate(ewayBillExtendPeriodController),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


            ],
            const SizedBox(height: 10),

            primaryDivider(),





          ],
        ),

      ),
            ),
        ),
       buildBottomBar(),
    ]
    ),
    );
  }

  /// ================= HEADER WIDGET =================
  Widget sectionHeader(String title, bool expanded, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
  Widget primaryDivider() {
    return const Divider(
      thickness: 1.5,
      color: AppColors.primary,
      height: 0, // Removes extra vertical space
    );
  }
  Widget sectionHeaderWithDivider(
      String title,
      bool expanded,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyles.f14w600Primary,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(
              thickness: 1.5,
              height: 1, // Prevents extra vertical space
              color: AppColors.mGray3,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildBottomBar() {
    return SafeArea(
      top: false, // 👈 only handle bottom
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10, // 👈 reduced from 16
        ),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Back",
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                borderColor: AppColors.primary,
                height: 48, // 👈 slightly smaller
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: CustomButton(
                onPressed: () {
                  final notifier = ref.read(lorryReceiptProvider.notifier);

                  updateFormData(ref, {
                    "order_id": orderIdController.text.trim(), // ✅ Added
                    "quotation_id": "QT-0001",
                    "survey_id": "SV-0001",
                    "lr_no": lrNoController.text.trim(),
                    "lr_date": _formatDate(dateController.text),
                    "risk_type": selectedRiskType ?? "",
                    "vehicle_no": vehicleController.text.trim(),
                    "moving_from": selectedFromCity ?? "",
                    "moving_to": selectedToCity ?? "",
                    "driver_name": driverNameController.text.trim(),
                    "driver_phone": mobileController.text.trim(),
                    "driver_license": altMobileController.text.trim(),
                    "goods_value":
                    double.tryParse(invoiceAmountController.text) ?? 0,
                    "invoice_date": _formatDate(invoiceDateController.text),
                    "invoice_no": invoiceNoController.text.trim(),
                    "eway_bill_no": ewayBillNoController.text.trim(),
                    "eway_bill_date":
                    _formatDate(ewayBillGenDateController.text),
                    "eway_expiry_date":
                    _formatDate(ewayBillExpireDateController.text),
                    "eway_extend_date":
                    ewayBillExtendPeriodController.text.isEmpty
                        ? null
                        : _formatDate(
                        ewayBillExtendPeriodController.text),
                    "total_amount":
                    double.tryParse(invoiceAmountController.text) ?? 0,
                  });

                  widget.onNext();
                },
                text: "Save & Next  >>",

                iconRight: true,
                backgroundColor: AppColors.primary,
                height: 48, // 👈 match height
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _formatDate(String date) {
    if (date.isEmpty) return "";
    final parts = date.split('/');
    return "${parts[2]}-${parts[1]}-${parts[0]}"; // yyyy-MM-dd
  }
  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary, // Header & selected date color
              onPrimary: Colors.white,    // Text color on header
              onSurface: Colors.black,    // Default text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.text =
      "${pickedDate.day.toString().padLeft(2, '0')}/""${pickedDate.month.toString().padLeft(2, '0')}/""${pickedDate.year}";
    }
  }
}