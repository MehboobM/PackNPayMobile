import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class ShipmentStatusStepper extends StatelessWidget {
  final int currentStep;

  const ShipmentStatusStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        "title": "Shifting Started",
        "date": "Jan 12, 2026 6:07 pm",
      },
      {
        "title": "Pickup Completed",
        "date": "Jan 14, 2026 11:25 am",
      },
      {
        "title": "Shifting Completed",
        "date": "Jan 16, 2026 4:32 pm",
      },
      {
        "title": "Settled",
        "date": "Feb 5, 2026 7:08 am",
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text("Shipment Status", style: TextStyles.f12w600Gray9),

          const SizedBox(height: 16),

          SizedBox(
            height: 80,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final stepWidth = totalWidth / steps.length;

                return Stack(
                  children: [
                    /// 🔥 FULL GREY LINE (center aligned with circles)
                    Positioned(
                      top: 10,
                      left: stepWidth / 2,
                      right: stepWidth / 2,
                      child: Container(
                        height: 2,
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),

                    /// 🔥 ACTIVE BLUE LINE (CENTER → CENTER FIXED)
                    Positioned(
                      top: 10,
                      left: stepWidth / 2,
                      width: stepWidth * currentStep,
                      child: Container(
                        height: 2,
                        color: AppColors.primary,
                      ),
                    ),

                    /// STEPS
                    Row(
                      children: List.generate(steps.length, (index) {
                        return Expanded(
                          child: Column(
                            children: [
                              /// CIRCLE
                              Transform.translate(
                                offset: const Offset(0, -2),
                                child: _buildCircle(index),
                              ),

                              const SizedBox(height: 8),

                              /// TITLE
                              Text(
                                steps[index]["title"]!,
                                textAlign: TextAlign.center,
                                style: TextStyles.f8w600mGray9.copyWith(
                                  color: index <= currentStep
                                      ? AppColors.primary
                                      : Colors.black,
                                ),
                              ),

                              const SizedBox(height: 4),

                              /// DATE
                              Text(
                                steps[index]["date"]!,
                                textAlign: TextAlign.center,
                                style: TextStyles.f7w400mGray6,
                              ),

                              const SizedBox(height: 4),

                              /// 🔥 VIEW ONLY FOR COMPLETED + CURRENT
                              if (index <= currentStep)
                                GestureDetector(
                                  onTap: () {
                                    debugPrint("View clicked: $index");
                                  },
                                  child: Text(
                                    index == currentStep
                                        ? "View"
                                        : "View",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      decoration:
                                      TextDecoration.underline,
                                      decorationColor:
                                      AppColors.primary,
                                      decorationThickness: 1.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(int index) {
    if (index < currentStep) {
      return Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 12, color: Colors.white),
      );
    } else if (index == currentStep) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 5,
          ),
        ),
      );
    } else {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 5,
          ),
        ),
      );
    }
  }
}