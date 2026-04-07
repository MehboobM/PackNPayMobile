
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

extension ResponsiveExt on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  double height(double fraction) => screenHeight * fraction;
  double width(double fraction) => screenWidth * fraction;

  // Safe area padding
  EdgeInsets get safePadding => MediaQuery.of(this).padding;
}

String bilingualText(BuildContext context, String enKey, String hiKey, {bool nextLine = false}) {
  if (context.locale.languageCode == "hi") {
    return nextLine ? "${tr(enKey)}\n${tr(hiKey)}" : "${tr(enKey)} (${tr(hiKey)})";
  } else {
    return tr(enKey);
  }
}


class StatusStyle {
  final Color bgColor;
  final Color textColor;
  StatusStyle({required this.bgColor, required this.textColor});
}
StatusStyle getStatusStyle(String status) {
  switch (status) {
    case "Pending":
      return StatusStyle(
        bgColor: const Color(0xFFFFFAEB),
        textColor: const Color(0xFFFDB022),
      );

    case "Submitted":
      return StatusStyle(
        bgColor: const Color(0xFFDCEFFF),
        textColor: const Color(0xFF007AFF), // primary color
      );

    case "Unassigned":
      return StatusStyle(
        bgColor: const Color(0xFFF9F5FF),
        textColor: const Color(0xFF9E77ED),
      );

    case "In Progress":
      return StatusStyle(
        bgColor: Colors.blue.shade50,
        textColor: Colors.blue,
      );

    case "Shifting Started":
      return StatusStyle(
        bgColor: Colors.pink.shade50,
        textColor: Colors.pink,
      );

    default:
      return StatusStyle(
        bgColor: Colors.grey.shade200,
        textColor: Colors.grey,
      );
  }
}



void showLoader(BuildContext context) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CupertinoActivityIndicator(radius: 16,color: AppColors.primary,),
    ),
  );
}

void hideLoader(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}







