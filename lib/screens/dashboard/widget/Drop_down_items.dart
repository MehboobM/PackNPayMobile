import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          leading: Image.asset(widget.icon, height: 22),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          trailing: Icon(
            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
      leading: Image.asset(icon, height: 18),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13),
      ),
      onTap: () {},
    );
  }
}