import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class OrderListItem extends StatelessWidget {
  final String status;
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

  const OrderListItem({
    super.key,
    required this.status,
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// STATUS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status.toUpperCase() == "PENDING"
                      ? Colors.orange.shade100
                      : status.toUpperCase() == "INPROGRESS"
                      ? AppColors.tab
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: status.toUpperCase() == "PENDING"
                        ? Colors.orange
                        : status.toUpperCase() == "INPROGRESS"
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ),
              ),

              /// ROUTE
              Row(
                children: [
                  Text(from, style: TextStyles.f10w400Gray6),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(to, style: TextStyles.f10w400Gray6),
                ],
              ),

              /// ACTION ICONS
              Row(
                children: const [
                  Icon(Icons.visibility_outlined, size: 18),
                  SizedBox(width: 8),
                  Icon(Icons.download_outlined, size: 18),
                  SizedBox(width: 8),
                  Icon(Icons.more_vert, size: 18),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// SECOND ROW (Order + Amount)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// LEFT DETAILS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(orderNo, style: TextStyles.f10w400Gray6),
                      const SizedBox(width: 8),
                      Text(date, style: TextStyles.f10w400Gray6),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(name, style: TextStyles.f10w700mGray9),
                  Text(phone, style: TextStyles.f10w400Gray6),
                ],
              ),

              /// AMOUNT + ADVANCE
              Column(
                children: [
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.redPrimary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "P: $advance",
                      style: TextStyles.f9w500mWhite,
                    ),
                  ),
                ],
              ),

              /// RIGHT CHIPS
              Column(
                children: [
                  _chip("Survey list: $surveyId"),
                  const SizedBox(height: 4),
                  _chip("QAT list: $lrId"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySecond,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyles.f8w500mWhite,
      ),
    );
  }
}