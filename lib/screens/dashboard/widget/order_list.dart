import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_item.dart';


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
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,

                ),
              ),
               Text(
                "See all",
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF2A3582)

                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TABLE HEADER
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xffE9ECF6),
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
      style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2A3582)

      ),
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
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  model.orderNo,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,

                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  model.date,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                  ),
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
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  model.phone,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                  ),
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
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,

                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.arrow_forward,
                        size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      model.to,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                      ),
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
                size: 20, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}