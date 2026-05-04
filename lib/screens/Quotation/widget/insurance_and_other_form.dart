


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/dropdown_widget.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/quotation_form_notifier.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class InsuranceAndOtherForm extends ConsumerStatefulWidget {
  const InsuranceAndOtherForm({super.key});

  @override
  ConsumerState<InsuranceAndOtherForm> createState() => _InsuranceAndOtherFormState();
}

class _InsuranceAndOtherFormState extends ConsumerState<InsuranceAndOtherForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController goodsController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController balconyController = TextEditingController();
  final TextEditingController needConcernController = TextEditingController();



  dynamic? selectedGst = 0;//'CGST/SGST';
  dynamic gstSelectedPercentage = null;
  String? selectedInsurance = null;
  String? selectedInsuranceVehicle = null;

  dynamic vehicleGstSelectedPercentage = null;
  dynamic? vehicleSelectedGst = null;

  String? selectedEasyAccess = null;
  String? selectedRestriction = null;

  @override
  void initState() {
    super.initState();

    final data = ref.read(quotationFormProvider);

    /// ✅ TEXTFIELDS RESTORE
    goodsController.text = data.goodsDeclaration ?? "";
    vehicleController.text = data.vehicleDeclaration ?? "";
    balconyController.text = data.balconyRemarks ?? "";
    needConcernController.text = data.specialNeeds ?? "";

    /// ✅ DROPDOWN RESTORE
    selectedInsurance = data.insuranceType;
    gstSelectedPercentage = double.tryParse(data.insurancePercent.toString())?.toInt();
    selectedGst = double.tryParse(data.insuranceGst.toString())?.toInt();

    selectedInsuranceVehicle = data.vehicleInsuranceType;

    // vehicleGstSelectedPercentage = data.vehicleInsurancePercent;
    // vehicleSelectedGst = data.vehicleInsuranceGst;
    vehicleGstSelectedPercentage = double.tryParse(data.vehicleInsurancePercent.toString())?.toInt();
    vehicleSelectedGst = double.tryParse(data.vehicleInsuranceGst.toString())?.toInt();

    selectedEasyAccess = data.easyAccess;
    selectedRestriction = data.restriction;
  }


  @override
  Widget build(BuildContext context) {

    final dropdown = ref.read(dropdownProvider.notifier);

    final insuranceItem = dropdown.getLabels("insurance_type");
    final selectedInsuranceLabel = dropdown.getLabelByValue("insurance_type", selectedInsurance);

    /// 🔹 GST TYPE
    final gstTypeItems = dropdown.getLabels("gst_percent");
    final selectedGstLabel = dropdown.getLabelByValue("gst_percent", selectedGst);

    /// 🔹 GST %
    final gstPercentItems = dropdown.getLabels("insurance_charge_percent");
    final selectedGstPercentLabel = dropdown.getLabelByValue("insurance_charge_percent", gstSelectedPercentage);

    ///Vehicle
    final insuranceVehicleItem = dropdown.getLabels("vehicle_insurance_type");
    final selectedVehicleInsuranceLabel = dropdown.getLabelByValue("vehicle_insurance_type", selectedInsuranceVehicle);

    /// 🔹 GST %
    final gstVehiclePercentItems = dropdown.getLabels("vehicle_insurance_charge_percent");
    final selectedGstVehiclePercentLabel = dropdown.getLabelByValue("vehicle_insurance_charge_percent", vehicleGstSelectedPercentage);

    /// 🔹 GST TYPE
    final gstVehicleTypeItems = dropdown.getLabels("gst_percent");
    final selectedVehicleGstLabel = dropdown.getLabelByValue("gst_percent", vehicleSelectedGst);


    final easyAccessItem = dropdown.getLabels("easy_access");
    final easyAccessLabel = dropdown.getLabelByValue("easy_access", selectedEasyAccess);

    final selectedRestrictionItem = dropdown.getLabels("easy_access");
    final restrictionLabel = dropdown.getLabelByValue("easy_access", selectedRestriction);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("insurance.insuranceType".tr(), style: TextStyles.f14w600mGray9),
            SizedBox(height: 10),

            /// 🔹 Single Dropdown
            Row(
              children: [
                reusableDropdown(
                  title: "insurance.title".tr(),
                  isRequired: true,
                  value: selectedInsuranceLabel,
                  items: insuranceItem,
                  onChanged: (label) {
                    final val = dropdown.getValueByLabel("insurance_type", label ?? "");

                    setState(() {
                      selectedInsurance = val;
                    });

                    /// ✅ ADD THIS
                    ref.read(quotationFormProvider.notifier).state.insuranceType = val;
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),


             reusableDropdownRow(
              title: "insurance.insuranceCharges".tr(),
              title2: "",
              value1: selectedGstPercentLabel,
              value2: selectedGstLabel,
              items1: gstPercentItems,
              items2: gstTypeItems,
              flex1: 6,
              flex2: 4,
              onChanged1: (label) {
                 final val = dropdown.getValueByLabel("insurance_charge_percent", label ?? "");

                 setState(() {
                   gstSelectedPercentage = val;
                 });

                 /// ✅ ADD THIS
                 ref.read(quotationFormProvider.notifier).state.insurancePercent = val;
               },
              onChanged2: (label) {
                 final val = dropdown.getValueByLabel("gst_percent", label ?? "");

                 setState(() {
                   selectedGst = val;
                 });

                 /// ✅ ADD THIS
                 ref.read(quotationFormProvider.notifier).state.insuranceGst = val;
               },
            ),




            const SizedBox(height: 16),

            formLabel("insurance.declarationOfGoods".tr(), isRequired: true),// "insurance.insuranceCharges".tr(),
            const SizedBox(height: 6),
            CustomTextField(
              controller: goodsController,
              hintText: "Write remarks",
              borderRadius: 12,
              hintStyle: TextStyles.f12w400Gray5,
              onChanged: (val) {
                ref.read(quotationFormProvider.notifier).state.goodsDeclaration = val;
              },
            ),

            /// Vehicle Insurance details
            const SizedBox(height: 10),
            Text("insurance.vehicleInsuranceDetails".tr(), style: TextStyles.f14w600mGray9),

            const SizedBox(height: 10),
            Row(
              children: [
                reusableDropdown(
                  title: "insurance.insuranceType".tr(),
                  isRequired: true,
                  value: selectedVehicleInsuranceLabel,
                  items: insuranceVehicleItem,
                  onChanged: (label) {
                    final val = dropdown.getValueByLabel("vehicle_insurance_type", label ?? "");

                    setState(() {
                      selectedInsuranceVehicle = val;
                    });

                    /// ✅ ADD THIS
                    ref.read(quotationFormProvider.notifier).state.vehicleInsuranceType = val;
                  },

                ),
              ],
            ),
            const SizedBox(height: 16),
            reusableDropdownRow(
              title: "insurance.insuranceCharges".tr(),
              title2: "",
              value1: selectedGstVehiclePercentLabel,
              value2: selectedVehicleGstLabel,
              items1: gstVehiclePercentItems,
              items2: gstVehicleTypeItems,
              flex1: 6,
              flex2: 4,
              onChanged1: (label) {
                final val = dropdown.getValueByLabel("vehicle_insurance_charge_percent", label ?? "");

                setState(() {
                  vehicleGstSelectedPercentage = val;
                });

                /// ✅ ADD THIS
                ref.read(quotationFormProvider.notifier).state.vehicleInsurancePercent = val;
              },

              onChanged2: (label) {
                final val = dropdown.getValueByLabel("gst_percent", label ?? "");

                setState(() {
                  vehicleSelectedGst = val;
                });

                /// ✅ ADD THIS
                ref.read(quotationFormProvider.notifier).state.vehicleInsuranceGst = val;
              },
            ),
            const SizedBox(height: 16),
            Text("insurance.declarationOfVehicle".tr(),
                style: TextStyles.f12w500Gray7),
            const SizedBox(height: 6),
            CustomTextField(
              controller: vehicleController,
              hintText: "Write remarks",
              borderRadius: 12,
              hintStyle: TextStyles.f12w400Gray5,
              onChanged: (val) {
                ref.read(quotationFormProvider.notifier).state.vehicleDeclaration = val;
              },
            ),

            /// Other details
            const SizedBox(height: 10),
            Text("otherDetails.title".tr(), style: TextStyles.f14w600mGray9),
            const SizedBox(height: 10),

            Row(
              children: [//easy_access
                reusableDropdown(
                  title: "otherDetails.easyAccess".tr(),

                  value: easyAccessLabel,
                  items: easyAccessItem,
                  onChanged: (value) {
                    final val = dropdown.getValueByLabel("easy_access", value ?? "");

                    setState(() {
                      selectedEasyAccess = val;
                    });

                    /// ✅ ADD THIS
                    ref.read(quotationFormProvider.notifier).state.easyAccess = val;
                  },

                ),
              ],
            ),
            const SizedBox(height: 16),
            Text( "otherDetails.balconyItems".tr(),
                style: TextStyles.f12w500Gray7),
            const SizedBox(height: 6),
            CustomTextField(
              controller: balconyController,
              hintText: "Write remarks",
              borderRadius: 12,
              hintStyle: TextStyles.f12w400Gray5,
              onChanged: (val) {
                ref.read(quotationFormProvider.notifier).state.balconyRemarks = val;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [//easy_access
                reusableDropdown(
                  title:"otherDetails.loadingRestrictions".tr(),
                  value: restrictionLabel,
                  items: selectedRestrictionItem,
                  onChanged: (value) {
                    final val = dropdown.getValueByLabel("easy_access", value ?? "");

                    setState(() {
                      selectedRestriction = val;
                    });

                    /// ✅ ADD THIS
                    ref.read(quotationFormProvider.notifier).state.restriction = val;
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text("otherDetails.specialNeeds".tr(), style: TextStyles.f12w500Gray7),
            const SizedBox(height: 6),
            CustomTextField(
              controller: needConcernController,
              hintText: "Write remarks",
              hintStyle: TextStyles.f12w400Gray5,
              onChanged: (val) {
                ref.read(quotationFormProvider.notifier).state.specialNeeds = val;
              },
            ),
          ],
        ),
      ),
    );
  }
}



Widget reusableDropdownRow({
  required String title,
  String title2 = "",
  required String? value1,
  required String? value2,
  required List<String> items1,
  required List<String> items2,
  required ValueChanged<String?> onChanged1,
  required ValueChanged<String?> onChanged2,
  int flex1 = 6,
  int flex2 = 4,
}) {
  return Row(
    children: [

      Expanded(
        flex: flex1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles.f12w500Gray7),
            const SizedBox(height: 6),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mGray3),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.mWhite,
              ),

              child:  CustomDropdownField<String>(
                value: value1,
                hintText: "select",
                items: items1, // ✅ now List<String>
                onChanged: onChanged1,
                textStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.mBlack9,
                ),
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.mBlack9,
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(width: 10),

      /// 🔹 Second Field
      Expanded(
        flex: flex2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(title2, style: TextStyles.f12w500Gray7),
              const SizedBox(height: 6),
             Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mGray3),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.mWhite,
              ),
               child:  CustomDropdownField<String>(
                 value: value2,
                 hintText: title2.isEmpty ? "select gst" : "select",
                 items: items2, // ✅ now List<String>
                 onChanged: onChanged2,
                 textStyle: GoogleFonts.inter(
                   fontSize: 12,
                   color: AppColors.mBlack9,
                 ),
                 hintStyle: GoogleFonts.inter(
                   fontSize: 12,
                   color: AppColors.mBlack9,
                 ),
               ),
            ),
          ],
        ),
      ),
    ],
  );
}


Widget reusableDropdown({
  required String title,
  required String? value,
  required List<String> items, // ✅ changed
  required ValueChanged<String?> onChanged,
  bool isRequired = false, // ✅ add this
  int flex = 1,
  TextStyle? textStle
}) {
  return Expanded(
    flex: flex,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formLabel(title, isRequired: isRequired,textStyle: textStle), // ✅ use here
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mGray3),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.mWhite,
          ),
          child: CustomDropdownField<String>(
            value: value,
            hintText: "select",
            items: items, // ✅ now List<String>
            onChanged: onChanged,
            textStyle: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.mBlack9,
            ),
            hintStyle: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.mBlack9,
            ),
          ),
        ),
      ],
    ),
  );
}