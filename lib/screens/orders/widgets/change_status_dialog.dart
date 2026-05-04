

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../global_widget/build_common_dropdown.dart';
import '../../../global_widget/custom_button.dart';
import '../../../notifier/order_detail_notifier.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';
import '../../../utils/toast_message.dart';

class ChangeStatusDialog extends ConsumerStatefulWidget {
  final String uid;
  final List logs;

  const ChangeStatusDialog({
    super.key,
    required this.uid,
    required this.logs,
  });

  @override
  ConsumerState<ChangeStatusDialog> createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends ConsumerState<ChangeStatusDialog> {

  final List<String> statusList = [
    "Shifting Started",
    "Pickup Completed",
    "Shifting Completed",
    "Settled",
  ];



  final TextEditingController _otpController = TextEditingController();

  bool get isOtpRequired => selectedStatus == "Shifting Started";

  late String selectedStatus;

  String mapApiToUiStatus(String? apiStatus) {
    switch (apiStatus) {
      case "SHIFTING_STARTED":
        return "Shifting Started";
      case "PICKUP_COMPLETED":
        return "Pickup Completed";
      case "SHIFTING_COMPLETED":
        return "Shifting Completed";
      case "SETTLED":
        return "Settled";
      default:
        return "Shifting Started";
    }
  }

  @override
  void initState() {
    super.initState();

    /// 👉 Get latest SHIPMENT status
    final shipmentLogs = widget.logs
        .where((e) => e.statusType == "SHIPMENT")
        .toList();

    shipmentLogs.sort(
            (a, b) => b.changedAt.compareTo(a.changedAt));

    final latestStatus =
    shipmentLogs.isNotEmpty ? shipmentLogs.first.status : null;

    selectedStatus = mapApiToUiStatus(latestStatus);
  }

  String mapUiToApiStatus(String uiStatus) {
    switch (uiStatus) {
      case "Shifting Started":
        return "SHIFTING_STARTED";
      case "Pickup Completed":
        return "PICKUP_COMPLETED";
      case "Shifting Completed":
        return "SHIFTING_COMPLETED";
      case "Settled":
        return "SETTLED";
      default:
        return "SHIFTING_STARTED";
    }
  }



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
                      selectedStatus = val ?? selectedStatus;
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
                onPressed: () async {

                  /// ✅ VALIDATION
                  // if (isOtpRequired && _otpController.text.length != 4) {
                  //   ToastHelper.showError(message: "Enter valid OTP");
                  //   return;
                  // }
                  //
                  // /// 👉 API CALL HERE
                  // print("Status: $selectedStatus");
                  // print("OTP: ${_otpController.text}");

                  final notifier = ref.read(orderDetailProvider.notifier);

                  /// ✅ VALIDATION
                  if (isOtpRequired && _otpController.text.length != 4) {
                    ToastHelper.showError(message: "Enter valid OTP");
                    return;
                  }

                  final result = await notifier.updateOrderStatus(
                    uid: widget.uid,
                    status: mapUiToApiStatus(selectedStatus),
                    otp: isOtpRequired ? _otpController.text : null,
                  );

                  if (result != null) {
                    ToastHelper.showSuccess(message: result);
                    Navigator.pop(context);
                  } else {
                    ToastHelper.showError(message: "Failed to update status");
                  }


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