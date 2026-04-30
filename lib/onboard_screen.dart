

import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

import 'database/shared_preferences/shared_storage.dart';
import 'routes/route_names_const.dart';
import 'utils/common_funtion.dart';
import 'global_widget/custom_button.dart';
import 'utils/m_font_styles.dart';



class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => OnboardState();
}

class OnboardState extends State<OnboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboard_first.png"),  // Fixed syntax here
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: context.height(0.02),    // Responsive!
                    left: context.width(0.06),
                    right: context.width(0.06),
                  ),
                  child: Image.asset(
                    "assets/images/pack_pay_logo.png",
                    width: context.width(0.45),
                    height: context.height(0.12),
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                 Text(
                  "Expand Your Reach, Win More Customers",
                  style: TextStyles.f32w400White,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                Text(
                  "From survey creation to quotation management and order tracking, our app empowers vendors to run their packers & movers business with ease.",
                  style: TextStyles.f14w400White,
                  textAlign: TextAlign.start,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 12.0,bottom: 10),
                  child: CustomButton(
                    onPressed: () async {
                      await StorageService().saveIsLoginClick("click");
                      Navigator.pushNamed(context, loginScreenRoute);


                    //    Navigator.pushNamedAndRemoveUntil(context, basicDetailRoute, (route) => false,
                      //                         arguments: {
                      //                           "mobile":"",
                      //                           "otp": "",
                      //                         },
                      //                       );
                    },
                    borderRadius: 6,
                    backgroundColor: AppColors.mWhite,
                    text: "Login",
                    textStyle: TextStyles.f14w600Primary,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
