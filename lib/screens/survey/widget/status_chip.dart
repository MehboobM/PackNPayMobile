import 'package:flutter/cupertino.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class StatusChip extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const StatusChip({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ?AppColors.tab // active
              : const Color(0xFFF5F5F7), // inactive
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
            text,
            style: TextStyles.f10w500primary
        ),
      ),
    );
  }
}