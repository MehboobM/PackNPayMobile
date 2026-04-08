import 'package:flutter/material.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/onboard_screen.dart';
import 'package:pack_n_pay/screens/new_survey/new_survey_screen.dart';
import 'package:pack_n_pay/screens/otp/otp_screen.dart';

import '../screens/Money_receipt/Money_list_receipt.dart';
import '../screens/Money_receipt/new_receipt.dart';
import '../screens/Quotation/Quotation_screen.dart';
import '../screens/Quotation/new_quotation_screen.dart';
import '../screens/basic_detail/basic_detail_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/new_survey/survey_link_screen.dart';
import '../screens/orders/order_details.dart';
import '../screens/orders/order_screen.dart';
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
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) =>  BasicDetailScreen(mobile: args['mobile'],otp:args['otp'],));

     case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

     case newSurveyRoute:
        return MaterialPageRoute(builder: (_) => const NewSurveyScreen());

     case surveyLinkRoute:
        return MaterialPageRoute(builder: (_) => const SurveyLinkScreen());

      case quotationScreenRoute:
        return MaterialPageRoute(builder: (_) => const QuotationScreen());

      case newQuotationRoute:
        final args = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) =>  NewQuotationScreen(keyType: args,),);

      case ordersScreenRoute:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());

      case orderDetailsScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const OrderDetailsScreen(),
        );
      case moneyListScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const MoneyListScreen(),
        );

      case newReceiptScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const NewReceiptScreen(),
        );


      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
