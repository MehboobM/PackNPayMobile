

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../global_widget/build_common_dropdown.dart';
import '../../../global_widget/custom_button.dart';
import '../../../global_widget/dropdown_widget.dart';
import '../../../notifier/order_detail_notifier.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';
import '../../../utils/toast_message.dart';

class ChangeStatusDialog extends ConsumerStatefulWidget {
  final String uid;
  final List logs;
  final String? shipmenStatus;

  const ChangeStatusDialog({
    super.key,
    required this.uid,
    required this.logs,
    this.shipmenStatus,
  });

  @override
  ConsumerState<ChangeStatusDialog> createState() =>
      _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends ConsumerState<ChangeStatusDialog> {

  final List<String> statusFlow = [
    "Shifting Started",
    "Pickup Completed",
    "Shifting Completed",
    "Settled",
  ];

  final TextEditingController _otpController = TextEditingController();

  /// 🔴 API STATE (DO NOT CHANGE)
  late String currentStatus;

  /// 🔴 USER SELECT
  String? selectedNextStatus;

  @override
  void initState() {
    super.initState();

    if (widget.shipmenStatus != null &&
        widget.shipmenStatus!.isNotEmpty) {
      currentStatus = mapApiToUiStatus(widget.shipmenStatus);
    } else {
      currentStatus = "";
    }
  }

  /// ---------------- MAP ----------------
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
        return "";
    }
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

  /// ---------------- HELPERS ----------------
  int getCurrentIndex() {
    if (currentStatus.isEmpty) return -1;
    return statusFlow.indexOf(currentStatus);
  }

  bool get isFinalStage => currentStatus == "Settled";

  bool get isOtpRequired =>
      (selectedNextStatus ?? getDropdownValue()) == "Shifting Started";

  /// ✅ DEFAULT VALUE (AUTO NEXT)
  String? getDropdownValue() {
    int index = getCurrentIndex();

    if (index == -1) return "Shifting Started";
    if (index == statusFlow.length - 1) return null;

    return statusFlow[index + 1];
  }

  /// ✅ CORE LOGIC (WEB SAME)
  List<DropdownMenuItem<String>> buildDropdownItems() {
    int currentIndex = getCurrentIndex();

    return statusFlow.map((status) {
      int index = statusFlow.indexOf(status);

      bool isEnabled;

      /// NULL → only first clickable
      if (currentIndex == -1) {
        isEnabled = index == 0;
      }
      /// NORMAL → only NEXT clickable
      else {
        isEnabled = index == currentIndex + 1;
      }

      /// FINAL → none clickable
      if (currentIndex == statusFlow.length - 1) {
        isEnabled = false;
      }

      return DropdownMenuItem<String>(
        value: status,
        enabled: isEnabled,
        child: Text(
          status,
          style: TextStyle(
            color: isEnabled ? Colors.black : Colors.grey,
            fontSize: 13,
          ),
        ),
      );
    }).toList();
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {

    final dropdownValue = selectedNextStatus ?? getDropdownValue();

    return Dialog(
      backgroundColor: AppColors.mWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order Status", style: TextStyles.f18w600Black8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// DROPDOWN
            if (!isFinalStage)
              Row(
                children: [
                  Expanded(
                    child: buildStyledDropdown(
                      title: "Change order status",
                      value: dropdownValue,
                      items: buildDropdownItems(),
                      onChanged: (val) {
                        if (val == null) return;

                        setState(() {
                          selectedNextStatus = val;
                          _otpController.clear();
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Column(
                    children: [
                      Text(""),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () async {
                            print(">>>>>>>>>>>>>>uid is ${widget.uid}");
                            final notifier = ref.read(orderDetailProvider.notifier);
                            final message = await notifier.sendShipmentOtp(widget.uid);
                            if (message != null) {
                              ToastHelper.showSuccess(message: message);
                            } else {
                              ToastHelper.showError(
                                message: "Failed to send shipment OTP",
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary, width: 1.5),
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Apply", style: TextStyles.f14w600Primary),
                        ),
                      ),
                    ],
                  )
                ],
              ),

            /// OTP
            if (isOtpRequired) ...[
              const SizedBox(height: 12),
              Text("Enter OTP", style: TextStyles.f12w500Gray7),
              const SizedBox(height: 6),
              Pinput(
                controller: _otpController,
                length: 4,
                keyboardType: TextInputType.number,
              ),
            ],

            const SizedBox(height: 16),

            /// BUTTON
            CustomButton(
              onPressed: () async {

                if (isFinalStage) return;

                final notifier = ref.read(orderDetailProvider.notifier);

                final finalStatus =
                    selectedNextStatus ?? getDropdownValue();

                if (finalStatus == null) return;

                if (isOtpRequired && _otpController.text.length != 4) {
                  ToastHelper.showError(message: "Enter valid OTP");
                  return;
                }

                final result = await notifier.updateOrderStatus(
                  uid: widget.uid,
                  status: mapUiToApiStatus(finalStatus),
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
              text: isFinalStage ? "Completed" : "Change status",
              textStyle: TextStyles.f12w400mWhite,
            ),
          ],
        ),
      ),
    );
  }
}

