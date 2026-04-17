import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/orders/widgets/change_status_dialog.dart';
import 'package:pack_n_pay/screens/orders/widgets/expansion_section.dart';

import 'package:pack_n_pay/screens/orders/widgets/order_status_stepper.dart';
import 'package:pack_n_pay/screens/orders/widgets/shipment_staus.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../Quotation/widget/gradient_title_widget.dart';
import '../Quotation/widget/orange_devider.dart';  // <-- make sure this path is correct

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodysecondry,

      appBar: AppBar(
        surfaceTintColor: AppColors.mWhite,
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
              OrderStatusStepper(currentStep: 0),
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
                          showDialog(
                            context: context,
                            builder: (_) => const ChangeStatusDialog(),
                          );
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

              //Quotation Details
              CustomExpansionSection(
                title: "Quotation Details",
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double itemWidth = (constraints.maxWidth - 12) / 2; // 2 columns

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _itemWrapper(itemWidth, _quotationItem("Quotation No.", "#PNP0001")),
                          _itemWrapper(itemWidth, _quotationItem("Company or Party Name", "Abc organization")),
                          _itemWrapper(itemWidth, _quotationItem("Party Name", "Abc organization")),
                          _itemWrapper(itemWidth, _quotationItem("Company or Party GST No.", "Asxdtrfdsuu")),

                          const SizedBox(
                            width: double.infinity,
                            child: Divider(thickness: 1),
                          ),

                          _itemWrapper(itemWidth, _quotationItem("Party Name", "Abc organization")),
                          _itemWrapper(itemWidth, _quotationItem("Quotation date", "00/00/0000")),
                          _itemWrapper(itemWidth, _quotationItem("Load type", "Full Load")),

                          _itemWrapper(itemWidth, _quotationItem("Phone No.", "+91 00000000")),
                          _itemWrapper(itemWidth, _quotationItem("Packaging Date", "00/00/0000")),
                          _itemWrapper(itemWidth, _quotationItem("Vehicle type", "Vehicle type")),

                          _itemWrapper(itemWidth, _quotationItem("Email", "abc@email.com")),
                          _itemWrapper(itemWidth, _quotationItem("Delivery date", "00/00/0000")),
                          _itemWrapper(itemWidth, _quotationItem("Moving Path", "By Road")),
                        ],
                      );
                    },
                  ),
                ],
              ),

              CustomExpansionSection(
                 title:"",
                titleWidget: Row(
                  children: [
                    GradientTitleWidget(title: 'Pickup Details                  '),
                    Expanded( // ✅ NOW safe (because parent is bounded)
                      child: Container(
                        height: 1,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double maxWidth = constraints.maxWidth;

                      int columns = 3;


                      double spacing = 14;
                      double itemWidth = (maxWidth - (spacing * (columns - 1))) / columns;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _itemWrapper(itemWidth, _quotationItem("Shifting/Moving Date", "00/00/00")),
                          _itemWrapper(itemWidth, _quotationItem("State", "Karnataka")),
                          _itemWrapper(itemWidth, _quotationItem("Lift", "Service lift")),
                          _itemWrapper(itemWidth, _quotationItem("Contact Details", "9918881974")),
                          _itemWrapper(itemWidth, _quotationItem("City", "Hsr")),
                          _itemWrapper(itemWidth, _quotationItem("Address", "Asxdtrfdsuu jekr fweuf ewf sd sjdf ")),

                        ],
                      );
                    },
                  ),
                ],
              ),


              CustomExpansionSection(
                title:"",
                titleWidget: Row(
                  children: [
                    GradientTitleWidget(title: 'Delivery Details                  '),
                    Expanded( // ✅ NOW safe (because parent is bounded)
                      child: Container(
                        height: 1,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double maxWidth = constraints.maxWidth;

                      int columns = 3;


                      double spacing = 14;
                      double itemWidth = (maxWidth - (spacing * (columns - 1))) / columns;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _itemWrapper(itemWidth, _quotationItem("Shifting/Moving Date", "00/00/00")),
                          _itemWrapper(itemWidth, _quotationItem("State", "Karnataka")),
                          _itemWrapper(itemWidth, _quotationItem("Lift", "Yes")),
                          _itemWrapper(itemWidth, _quotationItem("Contact Details", "9918881974")),
                          _itemWrapper(itemWidth, _quotationItem("City", "Hsr")),
                          _itemWrapper(itemWidth, _quotationItem("Company or Party GST No.", "Asxdtrfdsuu")),

                        ],
                      );
                    },
                  ),
                ],
              ),

              CustomExpansionSection(
                title:"",
                titleWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Item 03",style: TextStyles.f12w600Gray9),

                    Text("Edit Item",style: TextStyles.f12w600Gray9.copyWith(// this should button but ui same
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary, // 👈 match color
                      decorationThickness: 1.5, // 👈 control thickness
                    ),),

                  ],
                ),
                children: [
                  _ItemsHeaderRow(),
                  const SizedBox(height: 4),

                  // Items list
                  ListView.separated(
                    itemCount: 3,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => Container(height: 1,color: AppColors.mGray4,),
                    itemBuilder: (_, index) => _ItemRow(index: index),
                  ),
                  //  const SizedBox(height: 24),
                ],
              ),

              CustomExpansionSection(
                title:"",
                titleWidget: Row(
                  children: [
                    GradientTitleWidget(title: 'Insurance Details                '),
                    Expanded( // ✅ NOW safe (because parent is bounded)
                      child: Container(
                        height: 1,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double maxWidth = constraints.maxWidth;
                      int columns = 3;
                      double spacing = 14;
                      double itemWidth = (maxWidth - (spacing * (columns - 1))) / columns;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _itemWrapper(itemWidth, _quotationItem("Insurance type", "Optional")),
                          _itemWrapper(itemWidth, _quotationItem("Insurance charge(%)", "3%(GST)")),
                          SizedBox(
                            width: maxWidth,
                            child: _quotationItem(
                              "Declaration of goods",
                              "Lorem ipsum dolor sit ametconsectetur. Id a morbi euismod odio id viverra morbi vitae sed.",
                               3,
                            ),
                          ),
                        //why is not going in three line automaticlly
                        ],
                      );
                    },
                  ),
                ],
              ),

              CustomExpansionSection(
                title:"",
                titleWidget: Row(
                  children: [
                    GradientTitleWidget(title: 'Other Details                    '),
                    Expanded( // ✅ NOW safe (because parent is bounded)
                      child: Container(
                        height: 1,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: _quotationItem(
                      "IS THERE EASY ACCESS FOR LOAD & UNLOADING AT ORIGIN & DESTINATION(क्या लोड और अनलोडिंग आसान है?",
                      "Available",
                      3,
                      2
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: _quotationItem(
                        "SHOULD ANY ITEMS BE GOT DOWN THROUGH BALCONY ETC.(क्या किसी सामान को बालकनी से नीचे उतारना है?)",
                        "Almirah",
                        3,
                        2
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: _quotationItem(
                        "ARE THERE ANY RESTRICTIONS FOR LOADING/UNLOADING AT ORIGIN/DESTINATION (क्या लोडिंग/अनलोडिंग वाले स्थान पर कोई रोकेटोक है?)",
                        "Yes",
                        1,
                        2
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: _quotationItem(
                        "ARE THERE ANY RESTRICTIONS FOR LOADING/UNLOADING AT ORIGIN/DESTINATION (क्या लोडिंग/अनलोडिंग वाले स्थान पर कोई रोकेटोक है?)",
                        "No",
                        1,
                        2
                    ),
                  ),

                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: _quotationItem(
                        "DO YOU HAVE ANY SPECIAL NEEDS OR CONCERNT(अन्य जरूरी आवश्यकताएं?)",
                        "No",
                        1,
                        2
                    ),
                  ),
                ],
              ),

              CustomExpansionSection(
                title:"",
                titleWidget: Row(
                  children: [

                    GradientTitleRowWidget(
                      titleWidget: Row(
                       children: [
                         Text(
                           "Payment Details",
                           style: TextStyles.f10w500mWhite,
                         ),
                         SizedBox(width: 10,),
                         Text(
                           "Total Amount: ₹34000",
                           style: TextStyles.f10w700mBlack,
                         ),
                       ],
                      ),),
                    Expanded( // ✅ NOW safe (because parent is bounded)
                      child: Container(
                        height: 1,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
                children: [
                  PaymentRowItem(title: "Freight Charge", amount: "2000"),
                  PaymentRowItem(title: "Advance Paid", amount: "2000"),
                  PaymentRowItem(title: "Packing Charge", amount: "2000"),
                  PaymentRowItem(title: "Unpacking Charge", amount: "2000"),
                  PaymentRowItem(title: "Loading Charge", amount: "2000"),
                  PaymentRowItem(title: "Unloading Charge", amount: "2000"),
                  PaymentRowItem(title: "Packing material charge", amount: "2000"),
                ],
              ),

              CustomExpansionSection(
                title:"",
                titleWidget: Row(
                  children: [

                    GradientTitleRowWidget(
                      titleWidget: Row(
                        children: [
                          Text(
                            "Expenses",
                            style: TextStyles.f10w500mWhite,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "Total Amount: ₹34000",
                            style: TextStyles.f10w700mBlack,
                          ),
                        ],
                      ),),
                    Expanded( // ✅ NOW safe (because parent is bounded)
                      child: Container(
                        height: 1,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
                children: [
                  PaymentRowItem(title: "Freight Charge", amount: "2000",onPressed: (){

                  },),

                  PaymentRowItem(title: "Advance Paid", amount: "2000",onPressed: (){},),
                  PaymentRowItem(title: "Packing Charge", amount: "2000",onPressed: (){},),
                  PaymentRowItem(title: "Unpacking Charge", amount: "2000",onPressed: (){},),

                ],
              ),


              CustomExpansionSection(
                title:"",
                titleWidget: Row(
                  children: [
                    GradientTitleWidget(title: 'Payment Summary                    '),
                    Expanded( // ✅ NOW safe (because parent is bounded)
                      child: Container(
                        height: 1,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Base Fare",style: TextStyles.f10w400Gray9),
                      Text("₹ 5,000",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.mBlack)),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Base Fare",style: TextStyles.f10w400Gray9),
                      Text("₹ 1,000",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.mBlack)),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Base Fare",style: TextStyles.f10w400Gray9),
                      Text("₹ -2,000",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.darkOrange)),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Base Fare",style: TextStyles.f10w400Gray9),
                      Text("₹ -2,000",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.darkOrange)),
                    ],
                  ),
                  Container(height: 1,color: AppColors.mGray4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount to pay",style: TextStyles.f12w600Gray9),
                      Text("₹ 2,000",style: TextStyles.f12w700pinkish.copyWith(color: AppColors.primary)),
                    ],
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

  Widget _itemWrapper(double width, Widget child) {
    return SizedBox(
      width: width,
      child: child,
    );
  }


  Widget _quotationItem(String label, String value,[int? maxLine,int? maxTitleLine]) {
    if (label.isEmpty) return const SizedBox();
    bool isAddress = label.toLowerCase() == "address";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyles.f10w500Gray7,
          maxLines:maxTitleLine ?? 1, // 👈 important
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyles.f12w400Gray6H,
          maxLines: isAddress ? 2 : maxLine ?? 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class PaymentRowItem extends StatelessWidget {
  final String title;
  final String amount;
  final VoidCallback? onPressed;

  const PaymentRowItem({
    super.key,
    required this.title,
    required this.amount,
     this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Left Title
          Text(
            title,
            style: TextStyles.f11w500Gray7,
          ),

          const SizedBox(width: 10),

          // Line Divider
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 1,
              color: Colors.grey.shade400,
            ),
          ),

          // Amount
          Text(
            "₹$amount",
            style: TextStyles.f11w400Gray5,
          ),
          if(onPressed!=null)
          InkWell(onTap: onPressed, child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: SvgPicture.asset("assets/images/x.svg"),
          ))
        ],
      ),
    );
  }
}

class _ItemsHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4)
      ),
      padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'ITEM',
              style: TextStyles.f10w500Gray6.copyWith(color: AppColors.mWhite),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'QTY.',
              style: TextStyles.f10w500Gray6.copyWith(color: AppColors.mWhite),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Value(rupee)',
              textAlign: TextAlign.center,
              style: TextStyles.f10w500Gray6.copyWith(color: AppColors.mWhite),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Remarks',
              textAlign: TextAlign.center,
              style: TextStyles.f10w500Gray6.copyWith(color: AppColors.mWhite),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final int index;
  const _ItemRow({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // ✅ FIX
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart TV',
                  style: TextStyles.f10w400Gray6,
                ),
              ],
            ),
          ),

          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '01',
                    style: TextStyles.f10w700mGray9,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                '₹500',
                style: TextStyles.f10w400Gray6,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child:  Center(
              child: Text(
                'Electronic Accesories',
                style: TextStyles.f10w400Gray6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}