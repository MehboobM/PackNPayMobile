import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffProfitSection extends StatelessWidget {
  const StaffProfitSection({super.key});

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
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "Staff wise Profit/loss",
                   style: GoogleFonts.inter(
                     fontSize: 12,
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

            const SizedBox(height: 12),

            /// STAFF LIST
            const StaffProfitTile(
              name: "Rakesh singh",
              manager: true,
              amount: "+₹2,420",
              isProfit: true,
            ),

            const Divider(height: 20),

            const StaffProfitTile(
              name: "Rakesh singh",
              manager: true,
              amount: "+₹2,420",
              isProfit: false,
            ),
          ],
        ),
      ),
    );
  }
}
class StaffProfitTile extends StatelessWidget {
  final String name;
  final bool manager;
  final String amount;
  final bool isProfit;

  const StaffProfitTile({
    super.key,
    required this.name,
    required this.manager,
    required this.amount,
    required this.isProfit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        /// AVATAR
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xffF3F4F6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            size: 18,
            color: Colors.redAccent,
          ),
        ),

        const SizedBox(width: 10),

        /// NAME + ROLE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,

                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Staff ID: ${manager ? "Manager" : "Staff"}",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,

                ),
              ),
            ],
          ),
        ),

        /// AMOUNT BADGE
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isProfit
                ? const Color(0xffE6F4EA)
                : const Color(0xffFDE8E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            amount,
    style: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
              color: isProfit
                  ? const Color(0xff1E8E3E)
                  : const Color(0xffD93025),
            ),
          ),
        ),
      ],
    );
  }
}