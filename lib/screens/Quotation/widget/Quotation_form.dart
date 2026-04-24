import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/quotation_form_notifier.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';
import 'insurance_and_other_form.dart';

class QuotationDetailsForm extends ConsumerStatefulWidget {
  const QuotationDetailsForm({super.key});

  @override
  ConsumerState<QuotationDetailsForm> createState() => _QuotationDetailsFormState();
}

class _QuotationDetailsFormState extends ConsumerState<QuotationDetailsForm> {

  late TextEditingController quotationNoController;
  late TextEditingController companyController;
  late TextEditingController partyController;
  late TextEditingController gstController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController quotationDateController;
  late TextEditingController packingDateController;
  late TextEditingController deliveryDateController;

  String? selectedVehicleType = '';
  String? selectedLoadType = '';
  String? selectedLoadMovingPath= null;

  @override
  void initState() {
    super.initState();

    final data = ref.read(quotationFormProvider);

    quotationNoController = TextEditingController(text: data.quotationNo ?? "");

    companyController = TextEditingController(text: data.companyName ?? "");

    partyController =
        TextEditingController(text: data.partyName ?? "");

    gstController = TextEditingController(text: data.gstNo ?? "");

    phoneController =
        TextEditingController(text: data.phone ?? "");

    emailController =
        TextEditingController(text: data.email ?? "");

    quotationDateController =
        TextEditingController(text: data.quotationDate ?? "");

    packingDateController =
        TextEditingController(text: data.packingDate ?? "");

    deliveryDateController =
        TextEditingController(text: data.deliveryDate ?? "");

    /// DROPDOWN INIT
    selectedVehicleType = data.vehicleType ?? 'tempo';
    selectedLoadType = data.loadType ?? 'ftl';
    selectedLoadMovingPath = data.movingPath ?? null;
  }


  @override
  Widget build(BuildContext context) {

    final dropdown = ref.read(dropdownProvider.notifier);

    final vehicleTypeItem = dropdown.getLabels("vehicle_type");
    final vehicleTypeLabel = dropdown.getLabelByValue("vehicle_type", selectedVehicleType);

    final loadTypeItem = dropdown.getLabels("load_type");
    final loadTypeLabel = dropdown.getLabelByValue("load_type", selectedLoadType);

    final movingPathItem = dropdown.getLabels("moving_path");
    final movingPathLabel = dropdown.getLabelByValue("moving_path", selectedLoadMovingPath);


    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
              "quotation.quotationDetails".tr(),
            style: TextStyles.f14w600mGray9
          ),

          const SizedBox(height: 10),

          /// QUOTATION NO  quotationNo

          formLabel("quotation.quotationNo".tr(), isRequired: true),
          const SizedBox(height: 6),
          CustomTextField(
            controller: quotationNoController,
            hintText: "#PNP0001",
            isEnable: false,
            borderRadius: 12,
            onChanged: (val) {
              ref.read(quotationFormProvider.notifier)
                  .updateQuotationNo(val);
            },
            backgroundColor: const Color(0xFFF3F3F3),
            textStyle: TextStyles.f12w400Gray5,
          ),

          const SizedBox(height: 16),

          /// COMPANY NAME
          formLabel("quotation.companyName".tr(), isRequired: true),
          const SizedBox(height: 6),
          CustomTextField(
            controller: companyController,
            hintText: "Enter Name",
            onChanged: (val){
              ref.read(quotationFormProvider.notifier).updateCompany(val);
            },
            borderRadius: 12,
            hintStyle: TextStyles.f12w400Gray5,
          ),

          const SizedBox(height: 16),

          /// PARTY NAME
          formLabel("quotation.partyName".tr(), isRequired: true),
          const SizedBox(height: 6),
          CustomTextField(
            controller: partyController,
            hintText: "Enter Name",
            onChanged: (val) {
              ref.read(quotationFormProvider.notifier).state.partyName = val;
            },
            borderRadius: 12,
            hintStyle: TextStyles.f12w400Gray5,
          ),

          const SizedBox(height: 16),

          /// GST companyGst
          formLabel("quotation.companyGst".tr(), isRequired: false),
          const SizedBox(height: 6),
          CustomTextField(
            controller: gstController,
            hintText: "GSTIN no.",
            keyboardType: TextInputType.number,
            onChanged: (val) {
              ref.read(quotationFormProvider.notifier).state.gstNo = val;
            },
            borderRadius: 12,
            hintStyle: TextStyles.f12w400Gray5,
          ),

          const SizedBox(height: 16),

          /// PHONE + EMAIL
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//phoneNo
                    formLabel("quotation.phoneNo".tr(), isRequired: true),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: phoneController,
                      hintText: "Enter phone no.",
                      keyboardType: TextInputType.phone,
                      onChanged: (val) {
                        ref.read(quotationFormProvider.notifier)
                            .state.phone = val;
                      },
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    formLabel("quotation.email".tr(), isRequired: true),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: emailController,
                      hintText: "Enter email",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) {
                        ref.read(quotationFormProvider.notifier).state.email = val;
                      },
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// QUOTATION DATE + PACKING DATE
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    formLabel("quotation.quotationDate".tr(), isRequired: true),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: quotationDateController,
                      hintText: "00/00/0000",
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                      materialIcon: Icons.calendar_today_outlined,
                        onTap: () => pickDate(context, quotationDateController, "quotation"),
                        onChanged: (val) {
                          ref.read(quotationFormProvider.notifier).state.quotationDate = val;
                        }
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    formLabel("quotation.packingDate".tr(), isRequired: true),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: packingDateController,
                      hintText: "00/00/0000",
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                      materialIcon: Icons.calendar_today_outlined,
                      onTap: () => pickDate(context, packingDateController, "packing"),
                      onChanged: (val) {
                        ref.read(quotationFormProvider.notifier).state.packingDate = val;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// DELIVERY + LOAD TYPE
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    formLabel("quotation.deliveryDate".tr(), isRequired: true),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: deliveryDateController,
                      hintText: "00/00/0000",
                      hintStyle: TextStyles.f12w400Gray5,
                      materialIcon: Icons.calendar_today_outlined,
                      onTap: () => pickDate(context, deliveryDateController, "delivery"),
                      onChanged: (val) {
                        ref.read(quotationFormProvider.notifier).state.deliveryDate = val;
                      },
                      borderRadius: 12,
                    )
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: reusableDropdown(
                  title: "quotation.loadType".tr(),
                  value: loadTypeLabel,
                  items: loadTypeItem,
                  isRequired: true,
                  onChanged: (value) {
                   // selectedLoadType = dropdown.getValueByLabel("load_type", value ?? "");
                    final val = dropdown.getValueByLabel("load_type", value ?? "");

                    setState(() {
                      selectedLoadType = val;
                    });
                    ref.read(quotationFormProvider.notifier).updateLoadType(val);
                  },
                ),

              ),
            ],
          ),

          const SizedBox(height: 16),

          /// VEHICLE TYPE + MOVING PATH
          Row(
            children: [
              Expanded(
                child: reusableDropdown(
                  title: "quotation.vehicleType".tr(),
                  value: vehicleTypeLabel,
                  items: vehicleTypeItem,
                  isRequired: true,
                  onChanged: (value) {
                  //  selectedVehicleType = dropdown.getValueByLabel("vehicle_type", value ?? "");
                    final val = dropdown.getValueByLabel("vehicle_type", value ?? "");

                    setState(() {
                      selectedVehicleType = val;
                    });

                    ref.read(quotationFormProvider.notifier).updateVehicleType(val);
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: reusableDropdown(
                  title: "quotation.movingPath".tr(),
                  isRequired: true,
                  value: movingPathLabel,
                  items: movingPathItem,
                  onChanged: (value) {
                   // selectedLoadMovingPath = dropdown.getValueByLabel("moving_path", value ?? "");

                    final val = dropdown.getValueByLabel("moving_path", value ?? "");

                    setState(() {
                      selectedLoadMovingPath = val;
                    });

                    ref.read(quotationFormProvider.notifier).updateMovingPath(val);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> pickDate(
      BuildContext context,
      TextEditingController controller,
      String type,
      ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";

      /// ✅ UPDATE UI
      controller.text = formattedDate;

      /// ✅ UPDATE PROVIDER (THIS WAS MISSING)
      final notifier = ref.read(quotationFormProvider.notifier);

      if (type == "quotation") {
        notifier.state.quotationDate = formattedDate;
      } else if (type == "packing") {
        notifier.state.packingDate = formattedDate;
      } else if (type == "delivery") {
        notifier.state.deliveryDate = formattedDate;
      }
    }
  }
}