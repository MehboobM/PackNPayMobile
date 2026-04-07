import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_item.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';


class OrdersListSection extends StatelessWidget {
  final String title;
  final List<OrderItemModel> items;
  final bool isUpcoming;

  const OrdersListSection({
    super.key,
    required this.title,
    required this.items,
    this.isUpcoming = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyles.f14w600Primary.copyWith(
                  color: AppColors.mGray9,
                )
              ),
               Text(
                "See all",
                   style: TextStyles.f11w400Gray6.copyWith(
                     color: AppColors.primary,
                   )
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TABLE HEADER
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.tab,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: const [
                Expanded(flex: 2, child: HeaderText("ORDER NO")),
                Expanded(flex: 3, child: HeaderText("DETAILS")),
                Expanded(flex: 3, child: HeaderText("LOCATION")),
                Expanded(flex: 1, child: HeaderText("ACTION")),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// LIST ITEMS
          Column(
            children: items
                .map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OrderTile(
                model: e,
                isUpcoming: isUpcoming,
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.f10w500primary
    );
  }
}
class OrderTile extends StatelessWidget {
  final OrderItemModel model;
  final bool isUpcoming;

  const OrderTile({
    super.key,
    required this.model,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [

          /// ORDER NO
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUpcoming)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF4E5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Pending",
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.orangeStatus,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  model.orderNo,
                  style: TextStyles.f10w500primary.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.mGray9,

                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  model.date,
                  style: TextStyles.f10w400Gray9
                ),
              ],
            ),
          ),

          /// DETAILS
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyles.f10w400Gray9.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  model.phone,
                    style: TextStyles.f10w400Gray6
                ),
              ],
            ),
          ),

          /// LOCATION
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.from,
                    style: TextStyles.f10w400Gray6
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.arrow_forward,
                        size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      model.to,
                        style: TextStyles.f10w400Gray6
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ACTION
          const Expanded(
            flex: 1,
            child: Icon(Icons.remove_red_eye_outlined,
                size: 20, color: AppColors.mGray6),
          ),
        ],
      ),
    );
  }
}