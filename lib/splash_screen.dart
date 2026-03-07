import 'package:flutter/material.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/common_funtion.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashState();
}

class SplashState extends State<SplashScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration(seconds: 2),() {
      //Navigator.pushNamed(context, homeScreenRoute);
      Navigator.pushNamed(context, onboardRoute).then((value) {
        Future.delayed(Duration(seconds: 3),() {
          Navigator.pushNamed(context, onboardRoute);
        },);
      },);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(
          "assets/images/pack_pay_logo.png",
          width: context.width(0.45),
          height: context.height(0.12),
          fit: BoxFit.contain,
        ),
        //Image.asset("assets/images/pack_pay_logo.png",width: 180,),
      ),
    );

  }
}
