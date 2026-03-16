

import 'package:flutter/material.dart';
import 'package:pack_n_pay/screens/new_survey/widget/FieldLabel.dart';

import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';

class SurveyLinkScreen extends StatefulWidget {
  const SurveyLinkScreen({super.key});

  @override
  State<SurveyLinkScreen> createState() => _SurveyLinkScreenState();
}

class _SurveyLinkScreenState extends State<SurveyLinkScreen> {
  final surveyNoCtrl = TextEditingController(text: '#PNP0001');
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final movingFromCtrl = TextEditingController();
  final movingToCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.mWhite,
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black38, // stronger shadow
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.mWhite,
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_back, color: Colors.black),
                )),
            Text(
              'Survey Link',
              style: TextStyles.f16w600mBlack8,
            ),
            const SizedBox(width: 8),

          ],
        ),
      ),

      body: Column(
        children: [
          Container(height: 10,color: Color(0xFFDBDBDB)),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Survey No (disabled)
                const FieldLabel('Survey No.'),
                const SizedBox(height: 6),
                AbsorbPointer(
                  child: CustomTextField(
                    controller: surveyNoCtrl,
                    hintText: '',
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff9E9EA7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const FieldLabel('Name'),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: nameCtrl,
                  hintText: 'Enter Name',
                ),
                const SizedBox(height: 16),

                const FieldLabel('Phone No.'),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: phoneCtrl,
                  hintText: 'Enter phone no.',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                const FieldLabel('Date'),
                const SizedBox(height: 6),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: dateCtrl,
                      hintText: '00/00/0000',
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: DateTime.now(),
                        );
                        if (picked != null) {
                          dateCtrl.text =
                          '${picked.day.toString().padLeft(2, '0')}/'
                              '${picked.month.toString().padLeft(2, '0')}/'
                              '${picked.year}';
                          setState(() {

                          });

                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.calendar_today_outlined,
                          size: 20, color: Color(0xffA6A6AE)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const FieldLabel('Moving from'),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: movingFromCtrl,
                  hintText: 'Enter Pickup location',
                ),
                const SizedBox(height: 16),

                const FieldLabel('Moving to'),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: movingToCtrl,
                  hintText: 'Enter Destination',
                ),

                Spacer(),
                CustomButton(
                  onPressed:  () {

                  },
                  borderRadius: 6,
                  backgroundColor: AppColors.primary,
                  text: "Submit & Share link",
                  textStyle: TextStyles.f14w600Primary.copyWith(color: AppColors.mWhite),
                ),

                const SizedBox(height: 20),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
