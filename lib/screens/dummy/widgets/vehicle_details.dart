import 'package:flutter/material.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class VehicleDetailsPopup extends StatefulWidget {
  const VehicleDetailsPopup({super.key});

  @override
  State<VehicleDetailsPopup> createState() =>
      _VehicleDetailsPopupState();
}

class _VehicleDetailsPopupState extends State<VehicleDetailsPopup> {

  /// Controllers (Same pattern as your MovingDetailsForm)
  final TextEditingController vehicleNoController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverMobileController = TextEditingController();
  final TextEditingController driverLicenseController = TextEditingController();

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
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Vehicle: ${vehicleNoController.text}");
                  debugPrint("Driver: ${driverNameController.text}");
                  debugPrint("Mobile: ${driverMobileController.text}");
                  debugPrint("License: ${driverLicenseController.text}");

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
            ),
          ],
        ),
      ),
    );
  }
}