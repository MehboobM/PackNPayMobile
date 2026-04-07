import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/orders/widgets/expansion_section.dart';

import 'package:pack_n_pay/screens/orders/widgets/order_status_stepper.dart';
import 'package:pack_n_pay/screens/orders/widgets/shipment_staus.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';  // <-- make sure this path is correct

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodysecondry,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Orders",
          style: TextStyles.f16w600mGray9,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/pdf.svg",
              width: 22,
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/expense.svg",
              width: 22,
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.more_vert,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              OrderStatusStepper(currentStep: 1),
              const SizedBox(height: 16),
              ShipmentStatusStepper(currentStep: 1),
              const SizedBox(height: 10),

              CustomExpansionSection(
                title: "Order Details",
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            "Order No.",
                            style: TextStyles.f10w400Gray6,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "#PNP0001",
                            style: TextStyles.f12w600Gray5,
                          ),
                        ],
                      ),
                      const SizedBox(width: 24), // spacing between columns
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            "Quotation No.",
                            style: TextStyles.f10w400Gray6,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "#PNP0001",
                            style: TextStyles.f12w600Gray5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              CustomExpansionSection(
                title: "Order Status",
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        "Shifting Started",
                        style: TextStyles.f12w700pinkish
                      ),
                      TextButton(
                        onPressed: () {
                          // Your change status logic here
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerRight,
                        ),
                        child:  Text(
                          "Change Status",
                          style: TextStyles.f12w600Gray9.copyWith(
                            color: AppColors.primary, // Primary color
                            decoration: TextDecoration.underline, // Underline


                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              CustomExpansionSection(
                title: "Staff",
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Staff info
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "Rakesh singh\n",
                            style: TextStyles.f12w700primary,
                            children:  [
                              TextSpan(
                                text: "Staff ID: ",
                                style: TextStyles.f9w400mGray5
                              ),
                              TextSpan(
                                text: "Manager",
                                style: TextStyles.f9w400mGray5.copyWith(
                                  color: AppColors.mGray9
                                )
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Remove button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC6C6), // reddish background
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Remove",
                          style: TextStyle(
                            color: Color(0xFFD92E2E), // red text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              CustomExpansionSection(
                title: "Labours",
                children: [
                  _labourItem(1, "Rakesh Singh"),
                  _labourItem(2, "David Elson", addDivider: false), // last item, no divider
                ],
              ),

          CustomExpansionSection(
            title: "Vehicle Details",
            children: [

              /// ROW 1
              Row(
                children: [
                  Expanded(
                    child: _vehicleItem(
                      "Vehicle No.",
                      "XXX-XXXX-XXXXX",
                    ),
                  ),
                  Expanded(
                    child: _vehicleItem(
                      "Driver's mobile no.",
                      "+91 0000000000",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// ROW 2
              Row(
                children: [
                  Expanded(
                    child: _vehicleItem(
                      "Driver name",
                      "Rakesh Singh",
                    ),
                  ),
                  Expanded(
                    child: _vehicleItem(
                      "Driver license no.",
                      "XXX-XXXX-XXXXX",
                    ),
                  ),
                ],
              ),
            ],
          ),
              CustomExpansionSection(
                title: "Packing Details",
                children: [
                   Text(
                    "Remarks",
                    style: TextStyles.f12w500Gray7,
                  ),
                  const SizedBox(height: 6),
                   Text(
                    "Lorem ipsum dolor sit amet consectetur. In phasellus sollicitudin nulla pretium porttitor vel pulvinar eget. Erat orci donec iaculis morbi nam id ipsum. Tempor a sit facilisi in. At ac sit tincidunt tincidunt sapien imperdiet ac elit viverra.",
                    style: TextStyles.f11w400Gray9,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=70&q=80",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              CustomExpansionSection(
                title: "Unpacking Details",
                children: [
                   Text(
                    "Remarks",
                    style: TextStyles.f12w500Gray7,
                  ),
                  const SizedBox(height: 6),
                   Text(
                    "Lorem ipsum dolor sit amet consectetur. In phasellus sollicitudin nulla pretium porttitor vel pulvinar eget. Erat orci donec iaculis morbi nam id ipsum. Tempor a sit facilisi in. At ac sit tincidunt tincidunt sapien imperdiet ac elit viverra.",
                    style: TextStyles.f11w400Gray9,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=70&q=80",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labourItem(int number, String name, {bool addDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: "$number  ",
                    style: TextStyles.f14w600mGray9
                        .copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyles.f12w700primary,
                      ),
                       TextSpan(
                        text: "\nStaff ID: ",
                        style: TextStyles.f10w400Gray6
                      ),
                       TextSpan(
                        text: "Labour",
                        style: TextStyles.f10w400Gray6.copyWith(
                          color: AppColors.mGray9
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC6C6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  "assets/icons/Trash.svg", // 🔥 your SVG path here
                  height: 20,
                  width: 20,
                   // optional (if SVG supports color)
                ),
              ),
            ],
          ),
        ),
        // Divider line
        if (addDivider)
          const Divider(
            color: Color(0xFFE0E0E0),
            thickness: 1,
            height: 1,
          ),
      ],
    );
  }

  Widget _vehicleItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  TextStyles.f10w500Gray7
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style:  TextStyles.f12w400Gray6H
        ),
      ],
    );
  }
}