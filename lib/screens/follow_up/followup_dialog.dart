
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/global_widget/custom_button.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/toast_message.dart';

import '../../notifier/follow_up_notifier.dart';
import '../../utils/m_font_styles.dart';


Future<void> showFollowUpDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String sourceType,
  required String sourceId,
}) async {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          final isLoading = ref.watch(followUpProvider).isLoading;

          return Dialog(
            backgroundColor: AppColors.mWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom:  20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Schedule Follow-up",
                          style: TextStyles.f18w600Black8,
                        ),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// DATE
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "Follow-up Date ",
                          style: TextStyles.f14w500Gray9,
                          children: const [
                            TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.red))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      style: TextStyles.f14w500Gray9,
                      decoration: InputDecoration(
                        hintText: "dd/mm/yyyy",
                        hintStyle: TextStyles.hintText,
                        suffixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          initialDate: DateTime.now(),
                        );

                        if (date != null) {
                          selectedDate = date;
                          dateController.text =
                          "${date.day}/${date.month}/${date.year}";
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    /// TIME
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "Follow-up Time ",
                          style: TextStyles.f14w500Gray9,
                          children: const [
                            TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.red))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: timeController,
                      readOnly: true,
                      style: TextStyles.f14w500Gray9,
                      decoration: InputDecoration(
                        hintText: "--:-- --",
                        hintStyle: TextStyles.hintText,
                        suffixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time != null) {
                          selectedTime = time;
                          timeController.text = time.format(context);
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    /// REMARK
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Remark",
                        style: TextStyles.f14w500Gray9,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: remarkController,
                      maxLines: 3,
                      style: TextStyles.f14w500Gray9,
                      decoration: InputDecoration(
                        hintText: "Enter remark",
                        hintStyle: TextStyles.hintText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize:
                              const Size(double.infinity, 42),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                  color: AppColors.primary),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyles.f14w600Primary,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: CustomButton2(
                            height: 42,
                            onPressed: isLoading
                                ? null
                                : () async {
                              if (selectedDate == null || selectedTime == null) {
                                ToastHelper.showError(message:"Select date & time");
                                return;
                              }

                              final DateTime finalDateTime =
                              DateTime(
                                selectedDate!.year,
                                selectedDate!.month,
                                selectedDate!.day,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              );

                              final body = {
                                "source_type": sourceType,
                                "source_id": sourceId,
                                "remark":
                                remarkController.text,
                                "trigger_on":
                                finalDateTime
                                    .toString()
                                    .replaceFirst(
                                    "T", " "),
                              };

                              final result = await ref.read(
                                  followUpProvider.notifier).setFollowUp(body);

                              final success =
                              result['success'];
                              final message =
                              result['message'];

                              if (success) {
                                Navigator.pop(context);
                                ToastHelper.showSuccess(
                                    message: message);
                              } else {
                                ToastHelper.showError(message: message);
                              }
                            },
                            backgroundColor:
                            AppColors.primary,
                            textWidget: isLoading
                                ? const CupertinoActivityIndicator(
                              radius: 12,
                              color: Colors.white,
                            )
                                : Text(
                              "Submit",
                              style: TextStyles
                                  .f12w400mWhite,
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
        },
      );
    },
  );
}

Future<void> showFollowUpDialogss({
  required BuildContext context,
  required WidgetRef ref,
  required String sourceType, // Survey / Quotation / Order
  required String sourceId,
}) async {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final isLoading = ref.watch(followUpProvider).isLoading;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Schedule Follow-up",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// DATE FIELD
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    text: "Follow-up Date ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "*", style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "dd/mm/yyyy",
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );

                  if (date != null) {
                    selectedDate = date;
                    dateController.text =
                    "${date.day}/${date.month}/${date.year}";
                  }
                },
              ),

              const SizedBox(height: 16),

              /// TIME FIELD
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    text: "Follow-up Time ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "*", style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "--:-- --",
                  suffixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (time != null) {
                    selectedTime = time;
                    timeController.text = time.format(context);
                  }
                },
              ),

              const SizedBox(height: 16),

              /// REMARK
              Align(
                alignment: Alignment.centerLeft,
                child: const Text("Remark"),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: remarkController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter remark",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 42), // ✅ height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // ✅ radius
                        ),
                        side: BorderSide(color: AppColors.primary),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton2(
                      height: 42,
                      onPressed: isLoading
                          ? null // disable click while loading
                          : () async {
                        if (selectedDate == null || selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Select date & time")),
                          );
                          return;
                        }

                        final DateTime finalDateTime = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );

                        final body = {
                          "source_type": sourceType,
                          "source_id": sourceId,
                          "remark": remarkController.text,
                          "trigger_on":
                          finalDateTime.toString().replaceFirst("T", " "),
                        };

                        final result = await ref
                            .read(followUpProvider.notifier)
                            .setFollowUp(body);

                        final success = result['success'];
                        final message = result['message'];

                        if (success) {
                          Navigator.pop(context);
                          ToastHelper.showSuccess(message: message);
                        } else {
                          ToastHelper.showError(message: message);
                        }
                      },
                      backgroundColor: AppColors.primary,
                      textWidget: isLoading
                          ? const CupertinoActivityIndicator(radius: 14,color: Colors.white,)
                          : const Text("Submit"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}