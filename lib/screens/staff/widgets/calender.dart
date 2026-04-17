import 'dart:ui';

import 'package:flutter/material.dart';

class WeekDayHeader extends StatelessWidget {
  final String day;

  const WeekDayHeader(this.day, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
        ),
        child: Text(
          day,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}