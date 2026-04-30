import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../../notifier/dashboard_notifier.dart';
import '../../../routes/route_names_const.dart';

class SubscriptionCard extends ConsumerWidget {
  final String? navigateTo; // 👈 ADD THIS

  const SubscriptionCard({super.key, this.navigateTo});


  String formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return "${d.day}-${d.month}-${d.year}";
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(dashboardProvider).subscription;

    if (subscription == null) {
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
                    Text("0", style: TextStyles.f24w600White),
                    const SizedBox(height: 4),
                    Text(
                      "No Active Plan",
                      style: TextStyles.f12w400mWhiteO8,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      navigateTo ?? SubscriptionRoute,
                    );
                  },
                  child: Image.asset(
                    "assets/images/renew_button.png",
                    height: 42,
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            /// BOTTOM
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoColumn("PLAN", "N/A"),
                InfoColumn("PURCHASED ON", "--"),
                InfoColumn("VALID TILL", "--"),
              ],
            ),
          ],
        ),
      );
    }

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
                    subscription.daysLeft.toString(),
                    style: TextStyles.f24w600White,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Days left to renew",
                    style: TextStyles.f12w400mWhiteO8,
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    navigateTo ?? SubscriptionRoute,
                  );
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoColumn("PLAN", subscription.name),
              InfoColumn(
                "PURCHASED ON",
                formatDate(subscription.startDate),
              ),
              InfoColumn(
                "VALID TILL",
                formatDate(subscription.endDate),
              ),
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