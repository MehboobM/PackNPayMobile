import 'package:flutter/material.dart';
import 'filter_section.dart';
import 'header_section.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      /// pushes content below status bar
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),

      child: const Column(
        children: [

          /// HEADER
          HeaderSection(),



          /// FILTER + SEARCH
          FilterSearchSection(),

          SizedBox(height: 8),
        ],
      ),
    );
  }
}