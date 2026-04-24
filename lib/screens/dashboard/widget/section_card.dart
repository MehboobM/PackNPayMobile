import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class StatsSection extends StatelessWidget {
  final String title;
  final String total;
  final List<StatItem> items;
  final int crossAxisCount;

  const StatsSection({
    super.key,
    required this.title,
    required this.total,
    required this.items,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.f12w600Gray9
                ),
                Text(
                  total,
                  style: TextStyles.f12w600Gray9.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700
                  )
                ),
              ],
            ),


            const SizedBox(height: 10), // 🔥 reduce to 4 (or even 2)

            GridView.builder(
              padding: EdgeInsets.zero, // 🔥 VERY IMPORTANT FIX
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 60,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xffE5E7EB)),
                    color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.f10w400Gray6.copyWith(
                          color: AppColors.mGray9,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.value,
                        style: TextStyles.f12w600Gray9.copyWith(
                          fontWeight: FontWeight.w700,
                          color: item.color ?? Colors.black,
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
          ],
        )
      ),
    );
  }
}

class StatItem {
  final String title;
  final String value;
  final Color? color;

  StatItem(
      this.title,
      this.value, {
        this.color,
      });
}