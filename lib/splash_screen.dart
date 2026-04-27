import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/database/shared_preferences/shared_storage.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/screens/basic_detail/basic_detail_screen.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/common_funtion.dart';

import 'models/payment_field_visible.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashState();
}



//Navigator.pushNamed(context, quotationScreenRoute);
//Navigator.pushNamed(context, newSurveyRoute);
class SplashState extends State<SplashScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));

    final storage = StorageService();
    final token = await storage.getToken();
    final isLoginClick = await storage.getIsLoginClick();

    if (!mounted) return;

    /// -------- NOT LOGGED IN --------
    if(isLoginClick!="click"){
      Navigator.pushNamedAndRemoveUntil(context, onboardRoute, (_) => false,);
      return;
    }
    else if (token == null || token.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, onboardRoute, (_) => false,);
      return;
    }
    else{
      Navigator.pushNamedAndRemoveUntil(context, homeScreenRoute, (_) => false,);
      return;
    }

    final container = ProviderScope.containerOf(context);

    container.read(paymentVisibilityProvider.notifier).state =
    const VisiblePaymentField(
      isFreightVisible: true,
      isAdvanceVisible: true,
      isPackingVisible: true,
      isUnpackingVisible: true,
      isLoadingVisible: true,
    );


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
