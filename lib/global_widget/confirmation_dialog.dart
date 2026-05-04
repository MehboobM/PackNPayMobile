
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CommonConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final String yesText;
  final String noText;
  final VoidCallback onYes;
  final VoidCallback onNo;
  final IconData iconData;

  const CommonConfirmDialog({
    super.key,
    this.title = "Confirmation",
    required this.description,
    required this.onYes,
    required this.onNo,
    this.yesText = "Yes",
    this.noText = "Cancel",
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.mWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔴 ICON (DELETE / WARNING STYLE)
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppColors.redPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:  Icon(
                iconData,
                color: AppColors.redPrimary,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            /// TITLE
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.mBlack8,
              ),
            ),

            const SizedBox(height: 8),

            /// DESCRIPTION
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.mGray6,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            Row(
              children: [
                /// CANCEL
                Expanded(
                  child: OutlinedButton(
                    onPressed: onNo,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.mGray7,
                      side: const BorderSide(color: AppColors.mGray3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(noText),
                  ),
                ),

                const SizedBox(width: 12),

                /// YES / DELETE
                Expanded(
                  child: ElevatedButton(
                    onPressed: onYes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redPrimary,
                      foregroundColor: AppColors.mWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(yesText),
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