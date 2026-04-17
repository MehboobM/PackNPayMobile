

import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../utils/m_font_styles.dart';

class GradientTitleRowWidget extends StatelessWidget {
  Widget? titleWidget;
  GradientTitleRowWidget({super.key, required this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(0),left: Radius.circular(8)),
        gradient: const LinearGradient(
            colors: [
              Color(0xff026BC9),
              Color(0xfffffff),
            ],
            stops: [
              0.0,
              1.0,
            ],
            begin:AlignmentGeometry.centerLeft,
            end: AlignmentGeometry.centerRight
        ),
      ),
      child:titleWidget
      // Text(
      //   title,
      //   style: TextStyles.f10w500mWhite,
      // ),
    );
  }
}

class GradientTitleWidget extends StatelessWidget {
  String title;
  GradientTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(0),left: Radius.circular(8)),
        gradient: const LinearGradient(
          colors: [
            Color(0xff026BC9),
            Color(0xfffffff),
          ],
            stops: [
              0.0,
              1.0,
            ],
          begin:AlignmentGeometry.centerLeft,
          end: AlignmentGeometry.centerRight
        ),
      ),
      child:  Text(
        title,
        style: TextStyles.f10w500mWhite,
      ),
    );
  }
}

// Color(0xffBBD3F8),