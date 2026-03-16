import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../global_widget/custom_textfield.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class QuotationDetailsForm extends StatelessWidget {
  QuotationDetailsForm({super.key});

  final quotationNoController = TextEditingController(text: "#PNP0001");
  final companyController = TextEditingController();
  final partyController = TextEditingController();
  final gstController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final quotationDateController = TextEditingController();
  final packingDateController = TextEditingController();
  final deliveryDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: const Color(0xFFF3F3F3),
            textStyle: TextStyles.f12w400Gray5,
          ),

          const SizedBox(height: 16),

          /// COMPANY NAME
          Text("Company or Party Name",
            style: TextStyles.f12w500Gray7,),
          const SizedBox(height: 6),
          CustomTextField(
            controller: companyController,
            hintText: "Enter Name",
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
                      onTap: () => pickDate(context, deliveryDateController),
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
                      onTap: () => pickDate(context, deliveryDateController),
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
                      onTap: () => pickDate(context, deliveryDateController),
                      borderRadius: 12,
                    )
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("Load type",
                       style: TextStyles.f12w500Gray7,),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: TextEditingController(text: "Full load"),
                      hintText: "Full load",
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                      materialIcon: Icons.keyboard_arrow_down,
                      iconSize: 28,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// VEHICLE TYPE + MOVING PATH
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("Vehicle type",
                       style: TextStyles.f12w500Gray7,),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: TextEditingController(),
                      hintText: "Select",
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                      materialIcon: Icons.keyboard_arrow_down,
                      onTap: () {},
                      iconSize: 28,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Moving path",
                      style: TextStyles.f12w500Gray7,),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: TextEditingController(text: "By Road"),
                      hintText: "By Road",
                      borderRadius: 12,
                      hintStyle: TextStyles.f12w400Gray5,
                      iconSize: 28,
                      materialIcon: Icons.keyboard_arrow_down,
                      onTap: () {},
                    ),
                  ],
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
      ) async {
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
}