import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class MenuDropdown extends StatelessWidget {
  final String title;
  final String icon;
  final List<MenuItem> children;

  final bool isExpanded;        // 👈 controlled from parent
  final VoidCallback onTap;     // 👈 toggle from parent

  const MenuDropdown({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// HEADER
        ListTile(
          leading: SvgPicture.asset(
            icon,
            width: 22,
            height: 22,
          ),
          title: Text(
            title,
            style: TextStyles.f14w500mGray7,
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
          ),
          onTap: onTap, // 👈 parent controls this
        ),

        /// EXPANDED ITEMS
        AnimatedCrossFade(
          firstChild: const SizedBox(),
          secondChild: Container(
            color: const Color(0xffF5FAFF),
            child: Column(children: children),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback? onTap;
  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        width: 18,
        height: 18,
      ),
      title: Text(
        title,
          style: TextStyles.f14w500mGray7.copyWith(
            color: AppColors.mGray9
          )
      ),
      onTap:onTap,
    );
  }
}

class MenuSectionHeader extends StatelessWidget {
  final String title;

  const MenuSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyles.f14w600Primary
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Divider(
              thickness: 1,
              color: AppColors.primary,
            ),
          )
        ],
      ),
    );
  }
}