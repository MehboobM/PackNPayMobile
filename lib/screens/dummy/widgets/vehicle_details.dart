import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../notifier/order_detail_notifier.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';
import '../../../utils/toast_message.dart';

class VehicleDetailsPopup extends StatefulWidget {
  final int? orderId;
  final String? quotationId;

  final String? vehicleNo;
  final String? driverName;
  final String? driverPhone;
  final String? driverLicense;

  final List<Map<String, dynamic>>? staff;    // ✅ ADD
  final List<Map<String, dynamic>>? labour;    // ✅ ADD
  final List<Map<String, dynamic>>? expenses;    // ✅ ADD

   VehicleDetailsPopup({
    super.key,
    this.orderId,
    this.quotationId,
    this.vehicleNo,
    this.driverName,
    this.driverPhone,
    this.driverLicense,
     this.staff,
     this.labour,
     this.expenses,
  });

  @override
  State<VehicleDetailsPopup> createState() => _VehicleDetailsPopupState();
}

class _VehicleDetailsPopupState extends State<VehicleDetailsPopup> {

  /// Controllers (Same pattern as your MovingDetailsForm)
  final TextEditingController vehicleNoController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverMobileController = TextEditingController();
  final TextEditingController driverLicenseController = TextEditingController();


  @override
  void initState() {
    super.initState();

    vehicleNoController.text = widget.vehicleNo ?? "";
    driverNameController.text = widget.driverName ?? "";
    driverMobileController.text = widget.driverPhone ?? "";
    driverLicenseController.text = widget.driverLicense ?? "";
  }

  @override
  void dispose() {
    vehicleNoController.dispose();
    driverNameController.dispose();
    driverMobileController.dispose();
    driverLicenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 420,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Vehicle Details", style: TextStyles.f14w600Gray9),
                IconButton(
                  icon: const Icon(Icons.close,color: Colors.grey,size: 18,),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            /// VEHICLE NO
            formLabel("Vehicle No.", isRequired: true),
            const SizedBox(height: 6),
            CustomTextField(
              controller: vehicleNoController,
              hintText: "Enter no.",
              borderRadius: 12,
              hintStyle: TextStyles.f12w400Gray5,
            ),

            const SizedBox(height: 12),

            /// DRIVER DETAILS TITLE + LINE
            Row(
              children: [
                Text("Driver Details",
                    style: TextStyles.f12w600primary),
                const SizedBox(width: 8),
                const Expanded(
                  child: Divider(thickness: 1),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// DRIVER NAME
            formLabel("Driver name", isRequired: true),
            const SizedBox(height: 6),
            CustomTextField(
              controller: driverNameController,
              hintText: "Enter no.",
              borderRadius: 12,
              hintStyle: TextStyles.f12w400Gray5,
            ),

            const SizedBox(height: 12),

            /// DRIVER MOBILE
            formLabel("Driver’s mobile no.", isRequired: true),
            const SizedBox(height: 6),
            CustomTextField(
              controller: driverMobileController,
              hintText: "+91",
              keyboardType: TextInputType.phone,
              borderRadius: 12,
              hintStyle: TextStyles.f12w400Gray5,
            ),

            const SizedBox(height: 12),

            /// DRIVER LICENSE
            formLabel("Driver license no.", isRequired: true),
            const SizedBox(height: 6),
            CustomTextField(
              controller: driverLicenseController,
              hintText: "XXXX-XXXXX-XXXX",
              borderRadius: 12,
              hintStyle: TextStyles.f12w400Gray5,
            ),

            const SizedBox(height: 16),

            /// SAVE BUTTON
            Consumer(
              builder: (context, ref, child){
                return SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(

                    onPressed: () async {
                      final notifier = ref.read(orderDetailProvider.notifier);

                      final message = await notifier.updateOrder(
                        id: widget.orderId!,
                        uid: widget.quotationId ?? "",
                        vehicleNo: vehicleNoController.text,
                        driverName: driverNameController.text,
                        driverPhone: driverMobileController.text,
                        driverLicense: driverLicenseController.text,
                        staff: widget.staff,
                        labour:widget.labour,
                        expenses: widget.expenses
                      );

                      if (message == "Order updated successfully") {
                        ToastHelper.showSuccess(message: message!);
                      } else {
                        ToastHelper.showError(message: message ?? "Error occurred");
                      }

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F3A8F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyles.f12w500White
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}



class UpdateOrderRequest {
  String? quotationId;
  String? vehicleNo;
  String? driverName;
  String? driverPhone;
  String? driverLicense;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "quotation_id": quotationId,
      "staff": [],
      "labour": [],
      "expenses": [],
    };

    if (vehicleNo != null && vehicleNo!.isNotEmpty) {
      data["vehicle_no"] = vehicleNo;
    }
    if (driverName != null && driverName!.isNotEmpty) {
      data["driver_name"] = driverName;
    }
    if (driverPhone != null && driverPhone!.isNotEmpty) {
      data["driver_phone"] = driverPhone;
    }
    if (driverLicense != null && driverLicense!.isNotEmpty) {
      data["driver_license"] = driverLicense;
    }

    return data;
  }
}