

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../global_widget/custom_textfield.dart';
import '../../routes/route_names_const.dart';
import '../../utils/app_colors.dart';
import '../../utils/common_funtion.dart';
import '../../global_widget/custom_button.dart';
import '../../utils/m_font_styles.dart';


class BasicDetailScreen extends StatefulWidget {
  const BasicDetailScreen({super.key});

  @override
  State<BasicDetailScreen> createState() => _BasicDetailScreenState();
}

class _BasicDetailScreenState extends State<BasicDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // ✅ FormKey
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
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
          child: Form(  // ✅ REQUIRED for validation
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Spacer(),

                // Home icon with orange swirl
                Image.asset("assets/images/logomark_three.png",
                  width: context.width(0.4),
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 16),
                Text(
                  "Basic Details",
                  style: TextStyles.f18w600Black8,
                ),
                SizedBox(height: 16),
                Text(
                  "Enter your basic details",
                  style:TextStyles.f12w400Gray6H,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                CustomTextField(
                  controller: nameController,
                  prefixIcon: "assets/images/person_icon.svg",
                  hintText: "Enter name",
                  focusNode: nameFocus,
                  textInputAction: TextInputAction.next,     // ✅ Fixed
                  onFieldSubmitted: (_) => emailFocus.requestFocus(),  // ✅ Works now
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                CustomTextField(
                  controller: emailController,
                  prefixIcon: "assets/images/email_icon.svg",
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter email",
                  focusNode: emailFocus,
                  textInputAction: TextInputAction.done,      // ✅ Fixed
                  onFieldSubmitted: (_) => _formKey.currentState?.validate(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                      return "Please enter valid email";
                    }
                    return null;
                  },
                ),


                SizedBox(height: context.height(0.04)),

                // Continue button
                CustomButton(
                  onPressed:  () {
                    // ✅ Name & Email validation
                    // if (_formKey.currentState!.validate()) {  // ✅ Form validation only
                    //   print("Valid! Navigate...");
                    // }

                    Navigator.pushNamed(context, homeScreenRoute);
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
      ),
    );
  }
}

