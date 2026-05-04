
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/new_survey/widget/FieldLabel.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../routes/route_names_const.dart';
import '../../utils/m_font_styles.dart';

class NewSurveyScreen extends StatefulWidget {
  const NewSurveyScreen({super.key});

  @override
  State<NewSurveyScreen> createState() => _NewSurveyScreenState();
}

class _NewSurveyScreenState extends State<NewSurveyScreen> {

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
              'New Survey',
              style: TextStyles.f16w600mBlack8,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(top: 4),// for container center to New Survey
              decoration: BoxDecoration(
                color:  AppColors.cyanBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child:  Text(
                '#PNP0001',
                style: TextStyles.f10w500Primary,
              ),
            ),
          ],
        ),
        actions: [
          CustomButton(
            onPressed: () {
              Navigator.pushNamed(context, surveyLinkRoute);
            },
            width: 110,
            height: 36,
            borderRadius: 6,
            backgroundColor: AppColors.primary,
            icon: Icons.assignment_outlined,
            text: "Save",
            textStyle: TextStyles.f12w500White,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          ),
          SizedBox(width: 10,)
        ],
      ),

      body: Column(
        children: [
          Container(height: 10,color: Color(0xFFDBDBDB)),
          Expanded(child: SingleChildScrollView(
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


                // Items header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'Items',
                      style: TextStyles.f14w600Gray9,
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14), // remove extra padding
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                      ),
                      icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                      label: Text(
                        'Add item',
                        style: TextStyles.f14w600Primary,
                      ),
                    ),
                  ],
                ),

                _ItemsHeaderRow(),
                const SizedBox(height: 4),

                // Items list
                ListView.separated(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) =>
                  const Divider(color: Color(0xffE2E2E4), height: 24),
                  itemBuilder: (_, index) => _ItemRow(index: index),
                ),
                const SizedBox(height: 24),
              ],
            ),
          )),
        ],
      ),
    );
  }
}



class _ItemsHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'ITEM',
              style: TextStyles.f10w500Gray6,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'CATEGORY',
              style: TextStyles.f10w500Gray6,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'QUANTITY',
              textAlign: TextAlign.center,
              style: TextStyles.f10w500Gray6,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ACTION',
              textAlign: TextAlign.center,
              style: TextStyles.f10w500Gray6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final int index;
  const _ItemRow({required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#0${index + 1}',
                style: TextStyles.f10w400Gray6,
              ),
              const SizedBox(height: 2),
               Text(
                'TWIN BED',
                style: TextStyles.f10w700mGray9,
              ),
              const SizedBox(height: 2),
               Text(
                '✓ Installation',
                style: TextStyles.f8w400mSecondary,
              ),
            ],
          ),
        ),

        // Category
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FURNITURE',
                  style: TextStyles.f10w700mGray9,
                ),
                const SizedBox(height: 2),
                 Text(
                  'Wooden\nFurniture',
                  style: TextStyles.f10w400Gray6,
                ),
              ],
            ),
          ),
        ),

        // Quantity
         Expanded(
          flex: 3,
          child: Center(
            child: Text(
              '12',
              style: TextStyles.f10w700mGray9,
            ),
          ),
        ),

        // Action
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset("assets/icons/edit.svg")
                // const Icon(
                //   Icons.edit_outlined,
                //   size: 20,
                //   color: Color(0xff4A4A52),
                // ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                  child: SvgPicture.asset("assets/icons/delete.svg")
              ),
            ],
          ),
        ),
      ],
    );
  }
}





