
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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






