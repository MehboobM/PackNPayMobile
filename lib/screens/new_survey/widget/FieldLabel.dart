

import 'package:flutter/cupertino.dart';

import '../../../utils/m_font_styles.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.f12w500mGray7,
    );
  }
}
