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
  static final TextStyle f16w600mGray9 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.mGray9,
  );



  /// Hint text
  static final TextStyle hintText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xff98A2B3),
  );
  static final TextStyle f16w600mBlack8 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.mBlack8,
    height: 0.24,
  );



  static final TextStyle f32w400White = GoogleFonts.interTight(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.mWhite,
    letterSpacing: 0.0,
  );
  static final TextStyle f24w600White = GoogleFonts.interTight(
    fontSize: 24,
    fontWeight: FontWeight.w600,
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
  static final TextStyle f16w600Black8 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.mBlack8,
    height: 2.4,
  );

  static final TextStyle f14w400White = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.mWhite,
    letterSpacing: 0.0,
  );
  static final TextStyle f14w500mGray7 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 2.4,
    color: AppColors.mGray7,
    letterSpacing: 0.0,
  );

  static final TextStyle f12w500mGray7 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.18,
    color: AppColors.mGray7,
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
  static final TextStyle f12w600Gray9 =  GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mGray9,
    height: 1.0,
  );


  static final TextStyle f12w400Gray5 =  GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mGray5,
  );
  static final TextStyle f12w400mWhite =  GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mWhite,
    height: 0.2
  );
  static final TextStyle f12w400mWhiteO8 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mWhite.withOpacity(0.8),
    height: 0.2,
  );
  static final TextStyle f11w400Gray6 =  GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.mGray6,
    height: 0.2,
  );
  static final TextStyle f11w400WhiteO9 =  GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.mWhite.withOpacity(0.9),
    height: 0.2,
  );
  static final TextStyle f11w600mWhite =  GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.mWhite,
    height: 1.8,
  );
  static final TextStyle f11w500primary =  GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.8,
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
  static final TextStyle f10w400Gray9 = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.mGray9,
    height: 1.0,
  );
  static final TextStyle f10w500primary = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.0,
  );
  static final TextStyle f10w700mGray9 = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.mGray9,
    height: 1.0,
  );
  static final TextStyle f8w500mWhite = GoogleFonts.inter(
    fontSize: 8,
    fontWeight: FontWeight.w500,
    color: AppColors.mWhite,
    height: 1.0,
  );

  static final TextStyle f10w500Primary = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static final TextStyle f12w500White = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.mWhite,
  );


}
