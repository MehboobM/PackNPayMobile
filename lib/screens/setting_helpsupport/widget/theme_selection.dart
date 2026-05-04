import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class ThemeSelectionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isApplied;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onApply;

  const ThemeSelectionCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isApplied,
    required this.isSelected,
    required this.onTap,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.grey
                : isApplied
                ? AppColors.primary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              if (isSelected)
                Container(
                  height: 180,
                  color: Colors.black.withOpacity(0.45),
                ),

              /// APPLIED Badge
              if (isApplied && !isSelected)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "APPLIED",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              /// APPLY Button
              if (isSelected && !isApplied)
                ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "APPLY",
                    style: TextStyles.f12w700primary,
                  ),
                ),

              /// Title
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyles.f12w500White,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}