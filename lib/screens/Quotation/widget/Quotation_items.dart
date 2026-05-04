import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class QuotationListItem extends StatelessWidget {
  final String orderNo;
  final String date;
  final String name;
  final String phone;
  final String from;
  final String to;
  final String amount;
  final String advance;
  final String surveyId;
  final String lrId;
  final String orderId;
  final VoidCallback onTapView;
  final VoidCallback onTapDownload;
  final Function(TapDownDetails)? onTapMenu;


   QuotationListItem({
    super.key,
    required this.orderNo,
    required this.date,
    required this.name,
    required this.phone,
    required this.from,
    required this.to,
    required this.amount,
    required this.advance,
    required this.surveyId,
    required this.lrId,
    required this.orderId,
    required this.onTapView,
    required this.onTapDownload,
    required this.onTapMenu,
  });

  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// DETAILS
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  orderNo,
                  style: TextStyles.f10w400Gray6,
                ),
                const SizedBox(height: 6),

                Text(
                  date,
                  style: TextStyles.f10w400Gray6,
                ),

                const SizedBox(height: 10),

                Text(
                  name,
                  style: TextStyles.f10w700mGray9,
                ),
                const SizedBox(height: 6),

                Text(
                  phone,
                  style: TextStyles.f10w400Gray6,
                ),
              ],
            ),
          ),

          /// LOCATION & FREIGHT
          Expanded(
            flex: 3,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // ✅ center horizontally
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // ✅ center the row
                    children: [
                      Text(
                        from,
                        style: TextStyles.f10w400Gray6,
                      ),

                      const SizedBox(width: 4),

                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        to,
                        style: TextStyles.f10w400Gray6,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// FREIGHT
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tab,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      amount,
                      style: TextStyles.f10w500primary.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// ADVANCE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.redPrimary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFA10D02),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "P: $advance",
                      style: TextStyles.f9w500mWhite,
                    ),
                  ),
                ],
              ),
            ),


          /// ACTION
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:  [
                    InkWell(
                        onTap: onTapView,
                        child: Icon(Icons.visibility_outlined, size: 20)),
                    SizedBox(width: 10),
                    InkWell(
                        onTap: onTapDownload,
                        child: Icon(Icons.download_outlined, size: 20)),
                    SizedBox(width: 10),
                    GestureDetector(
                        onTapDown: (details) {
                          onTapMenu?.call(details);
                        },
                        child: Icon(Icons.more_vert, size: 20)),

                  ],
                ),

                const SizedBox(height: 6),

                _actionChip("SRV list: $surveyId"),
                const SizedBox(height: 2),

                _actionChip("LR list: $lrId"),
                const SizedBox(height: 2),

                _actionChip("ODR list: $orderId"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _actionChip(String text) {
    return SizedBox(
      width: 110, // same width for all chips
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: AppColors.primarySecond,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyles.f8w500mWhite,
        ),
      ),
    );
  }
}