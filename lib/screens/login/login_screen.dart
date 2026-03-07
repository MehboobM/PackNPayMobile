
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/route_names_const.dart';
import '../../utils/app_colors.dart';
import '../../utils/common_funtion.dart';
import '../../global_widget/custom_button.dart';
import '../../utils/m_font_styles.dart';
import '../chnage_langauge/change_laguage_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.mWhite,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.width(0.07)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Spacer(),
              Image.asset(
                "assets/images/logomark_one.png",
                width: context.width(0.2),
                fit: BoxFit.contain,
              ),

              SizedBox(height: 18),
              Text(
                bilingualText(context, "welcome", "welcome_hi"),
                style: TextStyles.f18w600Black8,
              ),
              SizedBox(height: 8),
              Text(
                bilingualText(context, "enter_mobile", "enter_mobile_hi", nextLine: true),
                style:TextStyles.f12w400Gray6H,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.mWhite,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color:AppColors.mGray3),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "+91",
                          style:  GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primarySecond,
                            height: 0.24,
                          ),
                        ),
                        SizedBox(width: 5,),
                        SvgPicture.asset("assets/images/arrow_down.svg")
                      ],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: "+1 (555) 000-0000",
                          hintStyle: TextStyles.f12w400Gray5,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.height(0.03)),

              // Continue button
              CustomButton(
                onPressed:  () {
                  Navigator.pushNamed(
                    context,
                    otpScreenRoute,
                    arguments: {
                      "mobile": _phoneController.text.trim(),
                    },
                  );
                },
                borderRadius: 6,
                backgroundColor: AppColors.primary,
                text: "Continue",
                textStyle: TextStyles.f14w600Primary.copyWith(color: AppColors.mWhite),
              ),

             Spacer(),

              // Terms & Privacy Policy
              Padding(
                padding: EdgeInsets.only(bottom: context.height(0.03)),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style:TextStyles.f12w400Gray6,
                    children: [
                      TextSpan(text: "By continuing you agree to our "),
                      TextSpan(
                        text: "Terms of Services",
                        style: TextStyles.f12w500PrimaryUnderline,
                      ),

                      TextSpan(text: " and "),
                      TextSpan(
                        text: " Privacy Policy",
                        style: TextStyles.f12w500PrimaryUnderline,
                      ),
                    ],
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
