import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/m_font_styles.dart';

class FilterSearchSection extends StatelessWidget {
  const FilterSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xffE2E2E2),
          ),
        ),
        child: Row(
          children: [

            /// USER DROPDOWN (GREY BACKGROUND)
            Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: Color(0xffEDEFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "User",
                      style: TextStyles.f12w600Gray9
                  ),
                  const SizedBox(width: 14),
                  SizedBox(height: 10,width: 10,child: SvgPicture.asset("assets/images/arrow_down.svg")),
                ],
              ),
            ),




            /// SEARCH FIELD
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey,size: 16,),
                    const SizedBox(width: 4),
                    Text(
                      "Search",
                      style: TextStyles.f12w400Gray5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}