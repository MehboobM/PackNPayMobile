import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class OrderStatusStepper extends StatelessWidget {
  final int currentStep;

  const OrderStatusStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _StepData("Survey list", "Jan 12, 2026 6:07 pm"),
      _StepData("Quotation", "Jan 14, 2026 11:25 am"),
      _StepData("Order Confirmed", "Jan 16, 2026 4:32 pm"),
      _StepData("LR/Bilty", "Feb 5, 2026 7:08 am"),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ WHITE BACKGROUND
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index <= currentStep;

            return Row(
              children: [

                Column(
                  children: [

                    /// LINE + CIRCLE
                    Row(
                      children: [

                        if (index != 0)
                          Container(
                            width: 40,
                            height: 2,
                            color: isCompleted
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),

                        /// CIRCLE
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: isCompleted
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                              ? Padding(
                            padding: const EdgeInsets.all(6),
                            child: SvgPicture.asset(
                              "assets/icons/stepper_image.svg",
                              fit: BoxFit.contain,
                            ),
                          )
                              : null,
                        ),

                        if (index != steps.length - 1)
                          Container(
                            width: 40,
                            height: 2,
                            color: index < currentStep
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// TITLE
                    Text(
                      steps[index].title,
                      style: TextStyles.f8w600mGray9,
                    ),

                    const SizedBox(height: 2),

                    /// DATE
                    Text(
                      steps[index].date,
                      style: TextStyles.f7w400mGray6,
                    ),

                    const SizedBox(height: 6),

                    /// DOWNLOAD ICON
                    Icon(
                      Icons.download,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _StepData {
  final String title;
  final String date;

  _StepData(this.title, this.date);
}