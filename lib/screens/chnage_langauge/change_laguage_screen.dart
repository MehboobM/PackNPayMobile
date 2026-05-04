

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pack_n_pay/global_widget/custom_button.dart';
import 'package:pack_n_pay/routes/route_names_const.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

import '../../database/shared_preferences/shared_storage.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Load the previously selected language (if any)
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLocale = await StorageService().getLocal();
    print("get seleted language is $savedLocale");
    setState(() {
      _selectedLanguage = savedLocale ?? 'en'; // Default to English
    });
    // Set the initial locale
    if (savedLocale != null) {
      context.setLocale(Locale(savedLocale));
    }
  }

  Future<void> _saveAndContinue() async {

    print("save seleted language is $_selectedLanguage");

    if (_selectedLanguage != null) {
      // Save the selected language
      await StorageService().saveLocal(_selectedLanguage!);
      // Update the app's locale
      context.setLocale(Locale(_selectedLanguage!));
      // Navigate to the next screen
      Navigator.pop(context);
      //Navigator.pushNamed(context, loginScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () async {
        Navigator.pop(context);
       // Navigator.pushReplacementNamed(context, loginScreenRoute);

        return true;
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          titleSpacing: 0, // 🔥 THIS removes gap

          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
             // Navigator.pushReplacementNamed(context, loginScreenRoute);
            },
          ),

          title: Text(
            'Select Language',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: ListView(
                children: [
                  _buildLanguageTile('English', 'en'),
                  _buildLanguageTile('Hindi', 'hi'),
                  _buildLanguageTile('Kannada', 'ka'),
                  _buildLanguageTile('Tamil', 'ta'),
                  _buildLanguageTile('Malayalam', 'ml'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _selectedLanguage != null ? _saveAndContinue : null,
              text: 'Change',
              backgroundColor: AppColors.primary,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildLanguageTile(String language, String locale) {
    final isSelected = _selectedLanguage == locale;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLanguage = locale;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              title: Text(
                language,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isSelected ? AppColors.primary : Colors.transparent, // Fill when selected
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade400, // Border color
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white, // Icon color white when selected
                )
                    : null,
              )

          ),
        ),
      ),
    );
  }
}


