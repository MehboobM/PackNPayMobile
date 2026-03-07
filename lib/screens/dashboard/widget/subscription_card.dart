import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white

                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Days left to renew",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70

                    ),
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
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Colors.white70
      )

      ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white

          ),
        ),
      ],
    );
  }
}