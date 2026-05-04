

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class CommonResumeDialog extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onNew;

  const CommonResumeDialog({
    super.key,
    required this.onContinue,
    required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restore,
                color: AppColors.primary,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            /// TITLE
            Text(
              "Resume Draft",
              style: TextStyles.f16w600mGray9,
            ),

            const SizedBox(height: 8),

            /// DESCRIPTION
            Text(
              "Do you want to continue with your saved form or start a new quotation?",
              textAlign: TextAlign.center,
              style: TextStyles.f14w500mGray7,
            ),

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              children: [

                /// CONTINUE
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onContinue,
                    child: Text(
                      "Continue",
                      style: TextStyles.f8w500mWhite.copyWith(
                          color: AppColors.primary,
                          fontSize: 12
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// NEW
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onNew,
                    child: Text(
                      "Reset",
                      style: TextStyles.f12w500White,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
