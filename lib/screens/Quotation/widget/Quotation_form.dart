import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_widget/custom_textfield.dart';
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

  String? selectedVehicleType = 'Tempo';
  String? selectedLoadType = 'FTL';
  String? selectedLoadMovingPath= 'by_road';

  @override
  void initState() {
    super.initState();

    final data = ref.read(quotationFormProvider);

    quotationNoController =
        TextEditingController(text: data.quotationNo ?? "#PNP0001");

    companyController =
        TextEditingController(text: data.companyName ?? "");

    partyController =
        TextEditingController(text: data.partyName ?? "");

    gstController =
        TextEditingController(text: data.gstNo ?? "");

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
    selectedLoadMovingPath = data.movingPath ?? 'by_road';
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
            "Quotation Details",
            style: TextStyles.f14w600mGray9
          ),

          const SizedBox(height: 10),

          /// QUOTATION NO
          Text("Quotation No.",
            style: TextStyles.f12w500Gray7,
          ),
          const SizedBox(height: 6),
          CustomTextField(
            controller: quotationNoController,
            hintText: "#PNP0001",
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
          Text("Company Name",
            style: TextStyles.f12w500Gray7,),
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
          Text("Party Name",
            style: TextStyles.f12w500Gray7,),
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

          /// GST
          Text("Company or Party GST no.",
            style: TextStyles.f12w500Gray7,),
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
                    Text("Phone No.",
                      style: TextStyles.f12w500Gray7,),
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
                    Text("Email",
                      style: TextStyles.f12w500Gray7,),
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
                    Text("Quotation Date",
                      style: TextStyles.f12w500Gray7,),
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
                    Text("Packing Date",
                      style: TextStyles.f12w500Gray7,),
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
                     Text("Delivery Date",
                      style: TextStyles.f12w500Gray7,),
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
                  title: "Load type",
                  value: loadTypeLabel,
                  items: loadTypeItem,
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
                  title: "Vehicle type",
                  value: vehicleTypeLabel,
                  items: vehicleTypeItem,
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
                  title: "Moving path",
                  value: movingPathLabel,
                  items: movingPathItem,
                  onChanged: (value) {
                   // selectedLoadMovingPath = dropdown.getValueByLabel("moving_path", value ?? "");

                    final val = dropdown.getValueByLabel("moving_path", value ?? "");

                    setState(() {
                      selectedLoadMovingPath = val;
                    });

                    ref.read(quotationFormProvider.notifier)
                        .updateMovingPath(val);
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
  // Future<void> pickDate(
  //     BuildContext context,
  //     TextEditingController controller,
  //     ) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (pickedDate != null) {
  //     controller.text =
  //     "${pickedDate.day.toString().padLeft(2, '0')}/"
  //         "${pickedDate.month.toString().padLeft(2, '0')}/"
  //         "${pickedDate.year}";
  //   }
  // }
}