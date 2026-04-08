import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class MoneyReceiptListItem extends StatelessWidget {
  final String id;
  final String date;
  final String name;
  final String phone;
  final String from;
  final String to;
  final String amount;

  final VoidCallback? onTapView;
  final VoidCallback? onTapDownload;
  final Function(TapDownDetails)? onTapMenu;

  const MoneyReceiptListItem({
    super.key,
    required this.id,
    required this.date,
    required this.name,
    required this.phone,
    required this.from,
    required this.to,
    required this.amount,
    this.onTapView,
    this.onTapDownload,
    this.onTapMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [

          /// LEFT SECTION (DETAILS)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#$id", style: TextStyles.f10w400Gray6),
                const SizedBox(height: 4),
                Text(date, style: TextStyles.f10w400Gray6),
                const SizedBox(height: 8),
                Text(name, style: TextStyles.f10w700mGray9),
                const SizedBox(height: 4),
                Text(phone, style: TextStyles.f10w400Gray6),
              ],
            ),
          ),

          /// MIDDLE SECTION (LOCATION + PRICE)
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ROUTE
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(from, style: TextStyles.f10w500Gray7),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(to, style: TextStyles.f10w500Gray7),
                  ],
                ),

                const SizedBox(height: 8),

                /// AMOUNT BOX
                Align(
                  alignment: Alignment.center, // 👈 this centers it horizontally
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tab,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "₹$amount",
                      style: TextStyles.f10w500primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT SECTION (ACTIONS)
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // push to right
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: onTapView,
                    child: SvgPicture.asset(
                      "assets/icons/view_icon.svg",
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Flexible(
                  child: GestureDetector(
                    onTap: onTapDownload,
                    child: SvgPicture.asset(
                      "assets/icons/download_icon.svg",
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Flexible(
                  child: GestureDetector(
                    onTapDown: onTapMenu,
                    child: SvgPicture.asset(
                      "assets/icons/more_icon.svg",
                      width: 18,
                      height: 18,
                    ),
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