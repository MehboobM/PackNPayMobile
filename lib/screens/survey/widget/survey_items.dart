import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

import '../../../utils/m_font_styles.dart';

class SurveyListItem extends StatelessWidget {

  final String status;
  final String orderNo;
  final String date;
  final String name;
  final String phone;
  final String from;
  final String to;
  final String itemNo;
  final String actionText;

  const SurveyListItem({
    super.key,
    required this.status,
    required this.orderNo,
    required this.date,
    required this.name,
    required this.phone,
    required this.from,
    required this.to,
    required this.itemNo,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {

    bool isPending = status == "Pending";

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [

          /// DETAILS
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isPending
                        ? Colors.orange.shade50
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyles.f10w500primary.copyWith(
                      color: isPending ? const Color(0xFFFDB022) : AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  orderNo,
                  style: TextStyles.f10w400Gray6
                ),
                const SizedBox(height: 4),

                Text(
                  date,
                    style: TextStyles.f10w400Gray6
                ),
              ],
            ),
          ),

          /// CUSTOMER
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  name,
                  style: TextStyles.f10w700mGray9
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                    style: TextStyles.f10w400Gray6
                ),
                const SizedBox(height: 4),

                Text(
                  "$from → $to",
                    style: TextStyles.f10w400Gray6
                ),
              ],
            ),
          ),

          /// ITEM NO
          Expanded(
            child: Text(
              itemNo,
                style: TextStyles.f10w700mGray9
            ),
          ),
          /// ACTION
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TOP ICON ROW
                Row(
                  children: const [
                    Icon(Icons.visibility_outlined, color: Colors.grey, size: 20),
                    SizedBox(width: 12),
                    Icon(Icons.download_outlined, color: Colors.grey, size: 20),
                    SizedBox(width: 12),
                    Icon(Icons.more_vert, color: Colors.grey, size: 20),
                  ],
                ),

                const SizedBox(height: 8),

                /// QUOTATION BUTTON
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3582),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      Icon(
                        Icons.remove_red_eye,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Quotation",
                        style: TextStyles.f10w500primary.copyWith(
                          color: AppColors.mWhite,
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class SurveyListHeader extends StatelessWidget {
  const SurveyListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3582),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [

          /// DETAILS
          Expanded(
            flex: 2,
            child: Text(
              "DETAILS",
              style: TextStyles.f10w500primary.copyWith(
                color: AppColors.mWhite,
              ),
            ),
          ),

          /// CUSTOMER
          Expanded(
            flex: 3,
            child: Text(
              "CUSTOMER",
              style: TextStyles.f10w500primary.copyWith(
                color: AppColors.mWhite,
              ),
            ),
          ),

          /// ITEM NO
          Expanded(
            flex: 2, // increased width
            child: Text(
              "ITEM NO.",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.f10w500primary.copyWith(
                color: AppColors.mWhite,
              ),
            ),
          ),

          /// ACTION
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "ACTION",
                style: TextStyles.f10w500primary.copyWith(
                  color: AppColors.mWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}