import 'package:flutter/material.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/onboard_screen.dart';
import 'package:pack_n_pay/screens/otp/otp_screen.dart';

import '../screens/Quotation/Quotation_screen.dart';
import '../screens/Quotation/new_quotation_screen.dart';
import '../screens/basic_detail/basic_detail_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/login/login_screen.dart';
import '../splash_screen.dart';



class NavigationRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case onboardRoute:
        return MaterialPageRoute(builder: (_) => const OnboardScreen());

      case loginScreenRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case otpScreenRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => OtpScreen(mobile: args['mobile'],),);

      case basicDetailRoute:
        return MaterialPageRoute(builder: (_) => const BasicDetailScreen());

     case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case quotationScreenRoute:
        return MaterialPageRoute(builder: (_) => const QuotationScreen());
      case newQuotationRoute:
        return MaterialPageRoute(builder: (_) => const NewQuotationScreen(),);


      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}


class ProductArg {
  int productId;
  bool isCat;
  bool isCommingFromBrand;


  ProductArg({required this.productId, required this.isCat,this.isCommingFromBrand = false,});
}