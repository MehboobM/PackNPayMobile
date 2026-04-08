

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/m_font_styles.dart';

Widget formLabel(String text, {bool isRequired = false}) {
  return RichText(
    text: TextSpan(
      text: text,
      style: TextStyles.f12w500Gray7,
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