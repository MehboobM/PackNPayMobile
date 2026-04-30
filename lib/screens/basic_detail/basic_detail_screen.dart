

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/hive_database/hive_permission.dart';
import '../../database/shared_preferences/shared_storage.dart';
import '../../global_widget/custom_textfield.dart';
import '../../notifier/login_notifier.dart';
import '../../routes/route_names_const.dart';
import '../../utils/app_colors.dart';
import '../../utils/common_funtion.dart';
import '../../global_widget/custom_button.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';


class BasicDetailScreen extends ConsumerStatefulWidget {

  final String mobile;
  final String otp;

  const BasicDetailScreen({
    super.key,
    required this.mobile,
    required this.otp,
  });


  @override
  ConsumerState<BasicDetailScreen> createState() => _BasicDetailScreenState();
}

class _BasicDetailScreenState extends ConsumerState<BasicDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // ✅ FormKey
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController companyController = TextEditingController();
  final TextEditingController gstController = TextEditingController();

  final FocusNode companyFocus = FocusNode();
  final FocusNode gstFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    companyController.dispose();
    gstController.dispose();
    companyFocus.dispose();
    gstFocus.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }


  String? validateGST(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "GST number is required";
    }

    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );

    if (!gstRegex.hasMatch(value.trim())) {
      return "Enter a valid GST number (e.g. 27ABCDE1234F1Z5)";
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    print("otp is >>>>>>>>>>>>${widget.otp}");
    print(widget.mobile);
  }

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authProvider);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.mWhite,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.mWhite,
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width(0.07)),
          child: Form(  // ✅ REQUIRED for validation
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              
                  //Spacer(),
                  SizedBox(height: 40),
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
                      if (value == null || value.trim().isEmpty || value.length<=3) {
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
              
                  SizedBox(height: 16),
              
                  CustomTextField(
                    controller: companyController,
                    prefixIcon: "assets/images/company_icon.svg",
                    hintText: "Enter company name",
                    focusNode: companyFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => gstFocus.requestFocus(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Company name is required";
                      }
                      return null;
                    },
                  ),
              
                  SizedBox(height: 16),
              
                  CustomTextField(
                    controller: gstController,
                    prefixIcon: "assets/images/gst_icon.svg",
                    hintText: "Enter GST number",
                    focusNode: gstFocus,
                    textInputAction: TextInputAction.done,
                    validator: validateGST,
                  ),
              
              
                  SizedBox(height: context.height(0.04)),
              
                  // Continue button
                  CustomButton2(
                    onPressed:  () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await ref.read(authProvider.notifier).register(
                          mobile: widget.mobile,
                          otp: widget.otp,
                          name: nameController.text.trim(),
                          email:emailController.text.trim(),
                          companyName: companyController.text.trim(),
                          gstNumber: gstController.text.trim().toUpperCase(),
                        );
                        if (response != null && response['success']) {
                          ToastHelper.showSuccess(message: response['message']);
                          await StorageService().saveToken(response['token']);
                          await AuthHiveService.saveResponse(response);
                          final user = response['user'];

                          if (user != null) {
                            await StorageService().saveCompanyStatus(user['company_status'] ?? '');
                            await StorageService().saveSubscriptionStatus(user['subscription_status'] ?? '');
                          }
                          Navigator.pushNamedAndRemoveUntil(context, homeScreenRoute, (_) => false,);
                        }else{
                          ToastHelper.showError(message: authState.error ?? "Something went wrong");
                        }
                      }
                    },
                    borderRadius: 6,
                    backgroundColor: AppColors.primary,
                    textWidget:  authState.isLoading ? CupertinoActivityIndicator(
                      radius: 14,
                    ) :
                    Text(
                      "Continue",
                      style: TextStyles.f14w600Primary.copyWith(color: AppColors.mWhite),
                    ),
              
                  ),
              
               //   Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

