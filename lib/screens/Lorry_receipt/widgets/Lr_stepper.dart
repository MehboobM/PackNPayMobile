import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class LRStepper extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepTapped;

  const LRStepper({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  Widget circle(int index) {
    bool completed = index < currentStep;
    bool active = index == currentStep;

    if (completed) {
      return Container(
        height: 22,
        width: 22,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }

    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: active ? AppColors.primary : Colors.grey,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          "${index + 1}",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget step(int index, String text) {
    return Expanded(
      child: InkWell(
        onTap: () => onStepTapped(index),
        child: Column(
          children: [
            circle(index),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: index == currentStep
                    ? AppColors.primary
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget line(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? AppColors.primary : Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              step(0, "LR Details"),
              line(currentStep > 0),
              step(1, "Consignor"),
              line(currentStep > 1),
              step(2, "Package "),
              line(currentStep > 2),
              step(3, "Insurance"),
            ],
          ),

        ],
      ),
    );
  }
}