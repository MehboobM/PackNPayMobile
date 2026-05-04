

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/m_font_styles.dart';

class PopupMenuModel {
  final String value;
  final String title;
  final String icon;
  final Color? iconColor;

  PopupMenuModel({
    required this.value,
    required this.title,
    required this.icon,
    this.iconColor,
  });
}
Future<void> showGlobalPopupMenu({
  required BuildContext context,
  required Offset tapPosition,
  required List<PopupMenuModel> items,
  required Function(String value) onSelected,
}) async {
  final selected = await showMenu(
    context: context,
    color: Colors.white,
    menuPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 6),
    position: RelativeRect.fromLTRB(
      tapPosition.dx,
      tapPosition.dy,
      tapPosition.dx,
      tapPosition.dy,
    ),
    items: items.map((item) {
      return PopupMenuItem(
        value: item.value,
        height: 9,
        padding: const EdgeInsets.symmetric(vertical:5, horizontal: 2),
        child: Row(
          children: [
            SvgPicture.asset(item.icon,fit: BoxFit.contain,),
            const SizedBox(width: 8),
            Text(item.title,style: TextStyles.f12w400Gray9,),
          ],
        ),
      );
    }).toList(),
  );

  if (selected != null) {
    onSelected(selected);
  }
}