import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xffE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          _buildItem(
            index: 0,
            label: "Home",
            iconPath: "assets/images/home_icon.svg",
          ),
          _buildItem(
            index: 1,
            label: "Survey list",
            iconPath: "assets/images/services_icon.svg",
          ),
          _buildItem(
            index: 2,
            label: "Menu",
            iconPath: "assets/images/grid_icon.svg",
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,
    required String iconPath,
  }) {
    final bool isSelected = selectedIndex == index;
    final bool isSvg = iconPath.toLowerCase().endsWith('.svg');
    final bool isHome = index == 0;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffDADFFF),
                Colors.white,
              ],
            )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// ICON
              isSvg
                  ? SvgPicture.asset(
                iconPath,
                height: 24,
                colorFilter: isSelected ? ( const ColorFilter.mode(Color(0xff2E3192), BlendMode.srcIn,))

                    : const ColorFilter.mode(Colors.grey, BlendMode.srcIn,),
              )
                  : Image.asset(
                iconPath,
                height: 24,
                color: isSelected
                    ? (isHome
                    ? null // 🔥 Home active → original
                    : const Color(0xff2E3192))
                    : Colors.grey,
              ),

              const SizedBox(height: 4),

              /// LABEL
              Text(
                label,
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xff2E3192)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}