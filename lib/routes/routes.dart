import 'package:flutter/material.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/onboard_screen.dart';
import 'package:pack_n_pay/screens/Letterhead/letter_head_page.dart';
import 'package:pack_n_pay/screens/new_survey/new_survey_screen.dart';
import 'package:pack_n_pay/screens/otp/otp_screen.dart';
import 'package:pack_n_pay/screens/subscription/subscription_page.dart';

import '../models/setting_modal.dart';
import '../models/staff_user_model.dart';
import '../screens/Expenses/expenses_category.dart';
import '../screens/Expenses/office_expence.dart';
import '../screens/Lorry_receipt/Lorry_receipt_screen.dart';
import '../screens/Lorry_receipt/New_receipt.dart';
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
import '../screens/survey/survey_list_screen.dart';
import '../screens/setting_helpsupport/help_support.dart';
import '../screens/setting_helpsupport/letter_head.dart';
import '../screens/setting_helpsupport/quotation_screen.dart';
import '../screens/setting_helpsupport/setting.dart';
import '../screens/setting_helpsupport/watermark_screen.dart';
import '../screens/setting_helpsupport/lr_builty.dart';
import '../screens/staff/new_staff_screen.dart';
import '../screens/staff/staff_details_screen.dart';
import '../screens/staff/staff_screen.dart';
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

     case surveyScreenRoute:
        return MaterialPageRoute(builder: (_) => const SurveyListScreen());

      case quotationScreenRoute:
        return MaterialPageRoute(builder: (_) => const QuotationScreen());

      case newQuotationRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) =>  NewQuotationScreen(keyType: args['keyType'],uid: args['uid'],),);

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
          settings: settings,
        );
      case staffScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const StaffScreen(),
        );

      case newStaffScreenRoute:
        final user = settings.arguments as UserModel?;
        return MaterialPageRoute(
          builder: (_) => NewStaffScreen(user: user),
        );
      case lorryReceiptListScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const LorryReceiptListScreen(),
        );

      case newLorryReceiptScreenRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => NewLorryReceiptScreen(
            uid: args?['uid'],
            isEdit: args?['isEdit'] ?? false,
          ),
          settings: settings,
        );
      case expenseCategoriesRoute:
        return MaterialPageRoute(
          builder: (_) => const ExpenseCategoriesPage(),
        );
      case OfficeExpensePageRoute:
        return MaterialPageRoute(
          builder: (_) => const OfficeExpensePage(),
        );
      case LetterheadRoute:
        return MaterialPageRoute(
          builder: (_) => const LetterHeadPage(),
        );
      case SubscriptionRoute:
        return MaterialPageRoute(
          builder: (_) => const SubscriptionPage(),
        );
      case staffDetailsScreenRoute:
        final user = settings.arguments as UserModel;

        return MaterialPageRoute(
          builder: (_) => StaffDetailsScreen(user: user),
        );
      case settingsScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case helpSupportScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const HelpSupportScreen(),
        );
      case watermarkSettingsRoute:
        final settingsModel = settings.arguments as SettingsModel;
        return MaterialPageRoute(
          builder: (_) => WatermarkSettingsScreen(
            settings: settingsModel,
          ),
        );
      case letterHeadSettingsRoute:
        final settingsModel = settings.arguments as SettingsModel;
        return MaterialPageRoute(
          builder: (_) => LetterHeadScreen(
            settings: settingsModel,
          ),
        );
      case quotationSettingsRoute:
        final settingsModel = settings.arguments as SettingsModel;
        return MaterialPageRoute(
          builder: (_) => QuotationSettingsScreen(
            settings: settingsModel,
          ),
        );

      case lrBiltySettingsRoute:
        final settingsModel = settings.arguments as SettingsModel;
        return MaterialPageRoute(
          builder: (_) => LRBiltySettingsScreen(
            settings: settingsModel,
          ),
        );


      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
