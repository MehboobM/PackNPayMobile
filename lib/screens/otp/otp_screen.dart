
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pinput/pinput.dart';

import '../../routes/route_names_const.dart';
import '../../utils/common_funtion.dart';
import '../../global_widget/custom_button.dart';
import '../../utils/m_font_styles.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String mobile;

  const OtpScreen({
    super.key,
    required this.mobile,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.mWhite,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.mWhite,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width(0.07)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Spacer(),

              // Home icon with orange swirl
              Image.asset("assets/images/logomark_two.png",
                width: context.width(0.4),
                fit: BoxFit.contain,
              ),

              SizedBox(height: 16),
              Text(
                "OTP Verification",
                style: TextStyles.f18w600Black8,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter the OTP sent to +91 ${widget.mobile}",
                    style:TextStyles.f12w400Gray6H,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 14,
                    width: 16,
                    child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset("assets/images/edit_3.svg",)),
                  )
                ],
              ),

              SizedBox(height: 10),


              Pinput(
                controller: _otpController,
                length: 4,
                preFilledWidget: Text(
                  "0",
                  style: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),

                showCursor: true,
                enableSuggestions: false,
                textInputAction: TextInputAction.done,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],


                defaultPinTheme: PinTheme(
                  width: 54,
                  height: 54,
                  textStyle: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400]!,  // Light grey for 0s
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mWhite,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                ),

                focusedPinTheme: PinTheme(
                  width: 54,
                  height: 54,
                  textStyle: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),

                submittedPinTheme: PinTheme(
                  width: 54,
                  height: 54,
                  textStyle: GoogleFonts.interTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mBlack9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),
              ),


              SizedBox(height: context.height(0.01)),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyles.f10w400Gray6,
                  children: [
                    TextSpan(text: "Didn't receive the code? "),
                    TextSpan(
                      text: "Resend OTP",
                      style: TextStyles.f10w600PrimarySecond,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('OTP resent successfully')),
                          );
                        },
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.height(0.04)),

              // Continue button
              CustomButton(
                onPressed:  () {
                  Navigator.pushNamed(context, basicDetailRoute);
                },
                borderRadius: 6,
                backgroundColor: AppColors.primary,
                text: "Continue",
                textStyle: TextStyles.f14w600Primary.copyWith(color: AppColors.mWhite),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
