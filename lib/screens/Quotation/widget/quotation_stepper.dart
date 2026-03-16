import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class QuotationStepper extends StatelessWidget {
  final int currentStep;

  const QuotationStepper({super.key, required this.currentStep});

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

  Widget title(int index, String text) {
    bool active = index == currentStep;
    bool completed = index < currentStep;

    return Text(
      text,
      style: TextStyles.f9w500mWhite.copyWith(
        color: completed
            ? AppColors.mGray9   // completed step color
            : active
            ? AppColors.primary
            : Colors.grey,
        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget step(int index, String text) {
    return Expanded(
      child: Column(
        children: [
          circle(index),
          const SizedBox(height: 14),
          title(index, text),
        ],
      ),
    );
  }

  Widget line(bool active) {
    return Expanded(
      child: Center(
        child: Container(
          height: 2,
          width: 43, // make line shorter
          color: active ? AppColors.primary : Colors.grey.shade300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// LINES BETWEEN CIRCLES & TITLES
          Positioned(
            top: 25,
            left: 46,
            right: 36,
            child: Row(
              children: [
                line(currentStep >= 1),
                line(currentStep >= 2),
                line(currentStep >= 3),
              ],
            ),
          ),

          /// STEPS
          Row(
            children: [
              step(0, "Qat. Details"),
              step(1, "Moving Details"),
              step(2, "Payment Details"),
              step(3, "Insurance & Oth."),
            ],
          ),
        ],
      ),
    );
  }
}