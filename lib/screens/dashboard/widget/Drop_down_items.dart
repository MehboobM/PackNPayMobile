import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class MenuDropdown extends StatefulWidget {
  final String title;
  final String icon;
  final List<MenuItem> children;

  const MenuDropdown({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  State<MenuDropdown> createState() => _MenuDropdownState();
}

class _MenuDropdownState extends State<MenuDropdown> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// HEADER
        ListTile(
          leading: SvgPicture.asset(
            widget.icon,
            width: 22,
            height: 22,
          ),
          title: Text(
            widget.title,
            style: TextStyles.f14w500mGray7
          ),
          trailing: Icon(
            expanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
          ),
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
        ),

        /// EXPANDED ITEMS
        if (expanded && widget.children.isNotEmpty)
          Container(
            color: const Color(0xffF5FAFF),
            child: Column(
              children: widget.children,
            ),
          ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String icon;

  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
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
      onTap: () {},
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