import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class CustomExpansionSection extends StatefulWidget {
  final String title;
  final List<Widget> children;
  Widget? titleWidget;

   CustomExpansionSection({
    super.key,
    required this.title,
    required this.children,
     this.titleWidget,
  });

  @override
  State<CustomExpansionSection> createState() => _CustomExpansionSectionState();
}

class _CustomExpansionSectionState extends State<CustomExpansionSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _handleTap() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Title row with dropdown icon
            InkWell(
              onTap: _handleTap,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child:
                Row(
                  children: [
                    Expanded( // 👈 THIS is the correct place for Expanded
                      child: widget.titleWidget ?? Text(widget.title, style: TextStyles.f12w600Gray9),
                    ),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.black54,
                    ),
                  ],
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //    widget.titleWidget ?? Text(widget.title, style: TextStyles.f12w600Gray9),
                //     Icon(
                //       _expanded ? Icons.expand_less : Icons.expand_more,
                //       color: Colors.black54,
                //     ),
                //   ],
                // ),
              ),
            ),

            SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ),
              axisAlignment: -1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}