

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../global_widget/build_common_dropdown.dart';
import '../../../global_widget/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';
import '../../../utils/toast_message.dart';

class ChangeStatusDialog extends StatefulWidget {
  const ChangeStatusDialog({super.key});

  @override
  State<ChangeStatusDialog> createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends State<ChangeStatusDialog> {

  final List<String> statusList = [
    "Shifting Started",
    "Pickup Completed",
    "Shifting Completed",
    "Settled",
  ];

  String? selectedStatus = "Shifting Started";

  final TextEditingController _otpController = TextEditingController();

  bool get isOtpRequired => selectedStatus == "Shifting Started";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.mWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order Status", style: TextStyles.f18w600Black8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment: AlignmentGeometry.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),


            /// DROPDOWN + APPLY
            Row(
              children: [
                buildCommonDropdown(
                  title: "Change order status",
                  value: selectedStatus,
                  items: statusList,
                  onChanged: (val) {
                    setState(() {
                      selectedStatus = val;
                      _otpController.clear();
                    });
                  },
                ),

                const SizedBox(width: 10),

                Column(
                  children: [
                    Text(""),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary, width: 1.5),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Apply",
                            style: TextStyles.f14w600Primary),
                      ),
                    ),
                  ],
                )
              ],
            ),



            /// OTP INFO TEXT
            if (isOtpRequired)...[
              const SizedBox(height: 12),
              Text(
                "Enter OTP",
                style: TextStyles.f12w500Gray7,
              ),
              const SizedBox(height: 6),
              Pinput(
                controller: _otpController,
                length: 4,
                preFilledWidget: Text(
                  "0",
                  style: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
                showCursor: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                defaultPinTheme: PinTheme(
                  width: 54,
                  height: 42,
                  textStyle: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400]!,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mWhite,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                ),

                focusedPinTheme: PinTheme(
                  width: 54,
                  height: 54,
                  textStyle: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),

                submittedPinTheme: PinTheme(
                  width: 54,
                  height: 54,
                  textStyle: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mBlack9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ],



            const SizedBox(height: 16),

            /// BUTTON
            Padding(
              padding: const EdgeInsets.only(top: 12.0,bottom: 10),
              child: CustomButton(
                onPressed: () {

                  /// ✅ VALIDATION
                  if (isOtpRequired && _otpController.text.length != 4) {
                    ToastHelper.showError(message: "Enter valid OTP");
                    return;
                  }

                  /// 👉 API CALL HERE
                  print("Status: $selectedStatus");
                  print("OTP: ${_otpController.text}");

                  Navigator.pop(context);
                },
                borderRadius: 6,
                backgroundColor: AppColors.primary,
                text: "Change status",
                textStyle: TextStyles.f12w400mWhite,
              ),
            ),

          ],
        ),
      ),
    );
  }
}