import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage("assets/images/backg_img.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "45",
                    style: TextStyles.f24w600White
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Days left to renew",
                    style: TextStyles.f12w400mWhiteO8
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  // renew plan action
                },
                child: Image.asset(
                  "assets/images/renew_button.png",
                  height: 42,
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          /// BOTTOM INFO
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoColumn("PLAN", "Professional"),
              InfoColumn("PURCHASED ON", "Feb 15, 2026"),
              InfoColumn("VALID TILL", "Mar 15, 2026"),
            ],
          )
        ],
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const InfoColumn(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
      style: TextStyles.f11w400WhiteO9

      ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyles.f11w600mWhite
        ),
      ],
    );
  }
}