import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class AutoScrollBanner extends StatefulWidget {
  const AutoScrollBanner({super.key});

  @override
  State<AutoScrollBanner> createState() => _AutoScrollBannerState();
}

class _AutoScrollBannerState extends State<AutoScrollBanner> {
  final ScrollController _controller = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_controller.hasClients) {
        double max = _controller.position.maxScrollExtent;
        double offset = _controller.offset + 2.5;

        if (offset >= max) {
          _controller.jumpTo(0);
        } else {
          _controller.jumpTo(offset);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.red,
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:  Text(
          "Different variant main layer. Flatten mask arrange font strikethrough component example scrolling text here...",
          style: TextStyles.f12w400mWhi
        ),
      ),
    );
  }
}