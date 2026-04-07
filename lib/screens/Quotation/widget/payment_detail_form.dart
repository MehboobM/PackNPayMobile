
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_widget/build_charge_field.dart';
import '../../../global_widget/build_common_dropdown.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../models/payment_field_visible.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/quotation_form_notifier.dart';
import '../../../utils/m_font_styles.dart';

class PaymentDetailForm extends ConsumerStatefulWidget {
  const PaymentDetailForm({super.key});

  @override
  ConsumerState<PaymentDetailForm> createState() => _PaymentDetailFormState();
}


class _PaymentDetailFormState extends ConsumerState<PaymentDetailForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController freightController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  final TextEditingController packingController = TextEditingController();
  final TextEditingController unPackingController = TextEditingController();
  final TextEditingController loadingController = TextEditingController();
  final TextEditingController unLoadingController = TextEditingController();
  final TextEditingController packingMaterialController = TextEditingController();
  final TextEditingController stChargesController = TextEditingController();
  final TextEditingController surChargesController = TextEditingController();

  final TextEditingController storageController = TextEditingController();
  final TextEditingController tptController = TextEditingController();
  final TextEditingController miscController = TextEditingController();
  final TextEditingController otherController = TextEditingController();


  String? selectedIncludeForUnPacking = 'Included in freight';
  String? selectedIncludeForLoading = 'Included in freight';
  String? selectedIncludeForUnloading = 'Included in freight';
  String? selectedIncludeForPackingMaterial = 'Included in freight';

  String? selectedSurcharges = 'Applicable';

  dynamic gstSelectedPercentage = 18;
  String? gstTypeSelectedPercentage = 'CGST/SGST';

  String? selectedIncludeForPacking = 'included';
  String? selectedIncludeForUnpacking = 'included';
  String? selectedLoadingCharge = 'included';
  String? selectedUnLoadingCharge = 'included';
  String? selectedPackingMaterialCharge = 'included';
  String? selectedSurcharge = 'not_applicable';


  @override
  void initState() {
    super.initState();

    final data = ref.read(quotationFormProvider);

    /// ✅ TEXTFIELDS RESTORE
    freightController.text = data.freightCharge ?? "";
    advanceController.text = data.advancePaid ?? "";
    packingController.text = data.packingCharge ?? "";
    unPackingController.text = data.unpackingCharge ?? "";
    loadingController.text = data.loadingCharge ?? "";
    unLoadingController.text = data.unloadingCharge ?? "";
    packingMaterialController.text = data.packingMaterialCharge ?? "";
    stChargesController.text = data.stCharges ?? "";
    surChargesController.text = data.surchargeAmount ?? "";

    otherController.text = data.otherCharges ?? "";
    storageController.text = data.storageCharge ?? "";
    tptController.text = data.tptCharge ?? "";
    miscController.text = data.miscCharge ?? "";

    /// ✅ DROPDOWN RESTORE
    selectedIncludeForPacking = data.packingChargeType ?? 'included';
    selectedIncludeForUnpacking = data.unpackingChargeType ?? 'included';
    selectedLoadingCharge = data.loadingChargeType ?? 'included';
    selectedUnLoadingCharge = data.unloadingChargeType ?? 'included';
    selectedPackingMaterialCharge = data.packingMaterialChargeType ?? 'included';

    selectedSurcharge = data.surchargeType ?? 'not_applicable';

    gstSelectedPercentage = data.gstPercent ?? 18;
    gstTypeSelectedPercentage = data.gstType ?? 'CGST/SGST';
  }

  @override
  Widget build(BuildContext context) {
    final visibleFields = ref.watch(paymentVisibilityProvider);

    final dropdown = ref.read(dropdownProvider.notifier);

    //packing charge
    final includeForPackingItem = dropdown.getLabels("packing_charge_type");
    final selectedIncludeForPackingLabel = dropdown.getLabelByValue("packing_charge_type", selectedIncludeForPacking);

   //unpacking charge
    final includeForUnpackingItem = dropdown.getLabels("packing_charge_type");
    final selectedForUnpackingLabel = dropdown.getLabelByValue("packing_charge_type", selectedIncludeForUnpacking);

    //loading charge
    final loadingChargeItem = dropdown.getLabels("packing_charge_type");
    final loadingChargeLabel = dropdown.getLabelByValue("packing_charge_type", selectedLoadingCharge);

    //unloading charge
    final unLoadingChargeItem = dropdown.getLabels("packing_charge_type");
    final unLoadingChargeLabel = dropdown.getLabelByValue("packing_charge_type", selectedUnLoadingCharge);

    //packing material
    final packingMaterialItem = dropdown.getLabels("packing_charge_type");
    final packingMaterialLabel = dropdown.getLabelByValue("packing_charge_type", selectedPackingMaterialCharge);

    final gstPercentItems = dropdown.getLabels("gst_percent");
    final selectedGstPercentLabel = dropdown.getLabelByValue("gst_percent", gstSelectedPercentage);

    final gstTypeItems = dropdown.getLabels("gst_type");
    final selectedGstLabel = dropdown.getLabelByValue("gst_type", gstTypeSelectedPercentage);

    //surcharge
    final surchargeItem = dropdown.getLabels("surcharge_type");
    final surchargeItemLabel = dropdown.getLabelByValue("surcharge_type", selectedSurcharge);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Payment Details", style: TextStyles.f14w600mGray9),
            const SizedBox(height: 10),

            /// Freight + Advance
            if (visibleFields.isFreightVisible || visibleFields.isAdvanceVisible)
              Row(
                children: [
                  if (visibleFields.isFreightVisible)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Freight Charge",
                              style: TextStyles.f12w500Gray7),
                          const SizedBox(height: 6),
                          CustomTextField(
                            controller: freightController,
                            hintText: "₹",
                            keyboardType: TextInputType.phone,
                            borderRadius: 12,
                            hintStyle: TextStyles.f12w400Gray5,
                            onChanged: (val) {
                              ref.read(quotationFormProvider.notifier).state.freightCharge = val;
                            },
                          ),
                        ],
                      ),
                    ),

                  if (visibleFields.isFreightVisible && visibleFields.isAdvanceVisible)
                    const SizedBox(width: 12),

                  if (visibleFields.isAdvanceVisible)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Advance Paid",
                              style: TextStyles.f12w500Gray7),
                          const SizedBox(height: 6),
                          CustomTextField(
                            controller: advanceController,
                            hintText: "₹",
                            keyboardType: TextInputType.phone,
                            borderRadius: 12,
                            hintStyle: TextStyles.f12w400Gray5,
                            onChanged: (val) {
                              ref.read(quotationFormProvider.notifier).state.advancePaid = val;
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 16),

            /// Packing
            if (visibleFields.isPackingVisible)
              buildChargeField(
                title: "Packing Charge",
                items: includeForPackingItem,
                selectedValue: selectedIncludeForPackingLabel,
                controller: packingController,
                onChanged: (label) {
                  ref.read(quotationFormProvider.notifier).state.packingCharge = null;
                  final val = dropdown.getValueByLabel("packing_charge_type", label ?? "");

                  setState(() {
                    selectedIncludeForPacking = val;
                  });

                  /// ✅ ADD THIS LINE
                  ref.read(quotationFormProvider.notifier).state.packingChargeType = val;
                },
                onTextChanged: (val){
                  ref.read(quotationFormProvider.notifier).state.packingCharge = val;
                },
              ),

            /// Unpacking
            if (visibleFields.isUnpackingVisible)
              buildChargeField(
                title: "Unpacking Charge",
                items: includeForUnpackingItem,
                selectedValue: selectedForUnpackingLabel,
                controller: unPackingController,
                onTextChanged: (val){
                  ref.read(quotationFormProvider.notifier).state.unpackingCharge = val;
                },
                onChanged: (label) {
                  ref.read(quotationFormProvider.notifier).state.unpackingCharge = null;
                  final val = dropdown.getValueByLabel("packing_charge_type", label ?? "");

                  setState(() {
                    selectedIncludeForUnpacking = val;
                  });

                  /// ✅ ADD THIS
                  ref.read(quotationFormProvider.notifier).state.unpackingChargeType = val;
                },
              ),


            /// Loading
            // if (visibleFields.isUnpackingVisible)
            buildChargeField(
              title: "Loading Charge",
              items: loadingChargeItem,
              selectedValue: loadingChargeLabel,
              controller: loadingController,
              onTextChanged: (val){
                ref.read(quotationFormProvider.notifier).state.loadingCharge = val;
              },
              onChanged: (label) {
                ref.read(quotationFormProvider.notifier).state.loadingCharge = null;
                final val = dropdown.getValueByLabel("packing_charge_type", label ?? "");

                setState(() {
                  selectedLoadingCharge = val;
                });

                /// ✅ ADD THIS
                ref.read(quotationFormProvider.notifier).state.loadingChargeType = val;
              },
            ),


            buildChargeField(
              title: "Unloading Charge",
              items: unLoadingChargeItem,
              selectedValue: unLoadingChargeLabel,
              controller: unLoadingController,
              onTextChanged: (val){
                ref.read(quotationFormProvider.notifier).state.unloadingCharge = val;
              },
              onChanged: (label) {
                ref.read(quotationFormProvider.notifier).state.unloadingCharge = null;
                final val = dropdown.getValueByLabel("packing_charge_type", label ?? "");

                setState(() {
                  selectedUnLoadingCharge = val;
                });

                /// ✅ ADD THIS
                ref.read(quotationFormProvider.notifier).state.unloadingChargeType = val;
              },
            ),

            buildChargeField(
              title: "Packing material charge",
              items: packingMaterialItem,
              selectedValue: packingMaterialLabel,
              controller: packingMaterialController,
              onTextChanged: (val){
                ref.read(quotationFormProvider.notifier).state.packingMaterialCharge = val;
              },
              onChanged: (label) {
                ref.read(quotationFormProvider.notifier).state.packingMaterialCharge = null;
                final val = dropdown.getValueByLabel("packing_charge_type", label ?? "");

                setState(() {
                  selectedPackingMaterialCharge = val;
                });

                /// ✅ ADD THIS
                ref.read(quotationFormProvider.notifier).state.packingMaterialChargeType = val;
              },
            ),



            Row(
              children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Storage charge",
                            style: TextStyles.f12w500Gray7),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: storageController,
                          hintText: "₹",
                          keyboardType: TextInputType.phone,
                          borderRadius: 12,
                          hintStyle: TextStyles.f12w400Gray5,
                          onChanged: (val){
                            ref.read(quotationFormProvider.notifier).state.storageCharge = val;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Car/Bike TPT",
                            style: TextStyles.f12w500Gray7),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: tptController,
                          hintText: "₹",
                          keyboardType: TextInputType.phone,
                          borderRadius: 12,
                          hintStyle: TextStyles.f12w400Gray5,
                          onChanged: (val){
                            ref.read(quotationFormProvider.notifier).state.tptCharge = val;
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            SizedBox(height: 16,),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Miscellaneous charges",
                          style: TextStyles.f12w500Gray7),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: miscController,
                        hintText: "₹",
                        keyboardType: TextInputType.phone,
                        borderRadius: 12,
                        hintStyle: TextStyles.f12w400Gray5,
                        onChanged: (val){
                          ref.read(quotationFormProvider.notifier).state.miscCharge = val;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Other charges",
                          style: TextStyles.f12w500Gray7),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: otherController,
                        hintText: "₹",
                        keyboardType: TextInputType.phone,
                        borderRadius: 12,
                        hintStyle: TextStyles.f12w400Gray5,
                        onChanged: (val){
                          ref.read(quotationFormProvider.notifier).state.otherCharges = val;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16,),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("St Charges",
                          style: TextStyles.f12w500Gray7),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: stChargesController,
                        hintText: "₹",
                        keyboardType: TextInputType.phone,
                        borderRadius: 12,
                        hintStyle: TextStyles.f12w400Gray5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                buildCommonDropdown(
                  title: "Gst",
                  value: selectedGstPercentLabel,
                  items: gstPercentItems,
                  onChanged: (value) {
                    final val = dropdown.getValueByLabel("gst_percent", value ?? "");

                    setState(() {
                      gstSelectedPercentage = val;
                    });

                    /// ✅ ADD THIS
                    ref.read(quotationFormProvider.notifier).state.gstPercent = val;
                  },
                ),
              ],
            ),

            SizedBox(height: 16,),

            Row(
              children: [
                buildCommonDropdown(
                  title: "Gst type",
                  value: selectedGstLabel,
                  items: gstTypeItems,
                  onChanged: (value) {
                    final val = dropdown.getValueByLabel("gst_type", value ?? "");

                    setState(() {
                      gstTypeSelectedPercentage = val;
                    });

                    /// ✅ ADD THIS
                    ref.read(quotationFormProvider.notifier).state.gstType = val;
                  },
                ),
              ],
            ),

           //selectedSurcharges
            SizedBox(height: 16,),
            buildChargeField(
              title: "Surcharge",
              items: surchargeItem,
              selectedValue: surchargeItemLabel,
              controller: surChargesController,
              onTextChanged: (val){
                ref.read(quotationFormProvider.notifier).state.surchargeAmount = val;
              },
              onChanged: (label) {
                ref.read(quotationFormProvider.notifier).state.surchargeAmount = null;
                final val = dropdown.getValueByLabel("surcharge_type", label ?? "");

                setState(() {
                  selectedSurcharge = val;
                });

                /// ✅ ADD THIS
                ref.read(quotationFormProvider.notifier).state.surchargeType = val;
              },

            ),

          ],
        ),
      ),
    );
  }


}



