import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// ---------- Shadows ----------
const List<Shadow> mShadow1 = [
  Shadow(
    color: AppColors.mWhite,
    offset: Offset(1, 1),
    blurRadius: 0,
  ),
];

const List<Shadow> mShadow2 = [
  Shadow(
    color: AppColors.mWhite,
    offset: Offset(1.5, 1.5),
    blurRadius: 0,
  ),
];

/// ---------- Text Styles (Google Fonts) ----------
class TextStyles {

  /// Subtitle / Description
  static final TextStyle subtitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xff98A2B3),
  );

  /// Hint text
  static final TextStyle hintText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xff98A2B3),
  );

  static final TextStyle f32w400White = GoogleFonts.interTight(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.mWhite,
    letterSpacing: 0.0,
  );

  static final TextStyle f18w600Black8 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.mBlack8,
    height: 1.3,
  );

  static final TextStyle f14w400White = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.mWhite,
    letterSpacing: 0.0,
  );

  static final TextStyle f14w600Primary = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 0.2,
    color: AppColors.primary,
    letterSpacing: 0.0,
  );

  static final TextStyle f12w400Gray6 =  GoogleFonts.interTight(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mGray6,
  );

  static final TextStyle f12w400Gray6H =  GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mGray6,
    height: 1.0,
  );


  static final TextStyle f12w400Gray5 =  GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mGray5,
  );

  static final TextStyle f12w500PrimaryUnderline = GoogleFonts.interTight(
    fontSize: 12,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500,
    color: AppColors.primarySecond,
  );

  static final TextStyle f10w600PrimarySecond = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.primarySecond,
    height: 1.0,
    decoration: TextDecoration.underline,
  );

  static final TextStyle f10w400Gray6 = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.mGray6,
    height: 1.0,
  );


}
