

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/m_font_styles.dart';

Widget formLabel(String text, {bool isRequired = false,TextStyle? textStyle}) {
  return RichText(
    text: TextSpan(
      text: text,
      style: textStyle ?? TextStyles.f12w500Gray7,
      children: [
        if (isRequired)
          const TextSpan(
            text: " *",
            style: TextStyle(color: Colors.red),
          ),
      ],
    ),
  );
}