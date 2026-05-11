

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/new_survey/widget/FieldLabel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api_services/network_handler.dart';
import '../../database/shared_preferences/shared_storage.dart';
import '../../global_widget/common_state_city_dropdown.dart';
import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../main.dart';
import '../../models/city_modal.dart';
import '../../models/dropdown_item.dart';
import '../../models/state_data.dart';
import '../../models/survey_list_data.dart';
import '../../notifier/quatation_notifier.dart';
import '../../notifier/survey_moving_city_notifier.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';

class SurveyLinkScreen extends ConsumerStatefulWidget {
  final SurveyList? item; // ✅ ADD THIS

  const SurveyLinkScreen({super.key, this.item});

  @override
  ConsumerState<SurveyLinkScreen> createState() => _SurveyLinkScreenState();
}

class _SurveyLinkScreenState extends ConsumerState<SurveyLinkScreen> {








  final surveyNoCtrl = TextEditingController(text: '#PNP0001');
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final movingFromCtrl = TextEditingController();
  final movingToCtrl = TextEditingController();

  // States? selectedMovingFormCity;
  // States? selectedMovingToCity;




  bool validateForm() {
    if (nameCtrl.text.trim().isEmpty) {
      ToastHelper.showError(
        message:  'Please enter name',
      );
      return false;
    }

    if (phoneCtrl.text.trim().isEmpty) {
      ToastHelper.showError(
        message:  'Please enter phone number',
      );
      return false;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneCtrl.text.trim())) {
      ToastHelper.showError(
        message:  'Enter valid 10 digit mobile number',
      );
      return false;
    }

    if (dateCtrl.text.trim().isEmpty) {
      ToastHelper.showError(
        message:  'Please select date',
      );
      return false;
    }

    if (selectedMovingFormCity == null) {
      ToastHelper.showError(
        message:  'Please select moving from',
      );
      return false;
    }

    if (selectedMovingToCity == null) {
      ToastHelper.showError(
        message:  'Please select moving to',
      );
      return false;
    }

    return true;
  }

  String getFormattedDate() {
    final parts = dateCtrl.text.split('/');
    final date = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );

    return date.toUtc().toIso8601String();
  }

  CityModel? selectedMovingFormCity;
  CityModel? selectedMovingToCity;
  void showPincodeDialog({
    required BuildContext context,
    required Function(CityModel city) onSelected,
  }) {
    final pinCtrl = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TITLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Find Pickup City",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Enter 6-digit pincode to locate city & state",
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: pinCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: "e.g. 560068",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        counterText: "",
                      ),
                    ),

                    const SizedBox(height: 12),

                    CustomButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (pinCtrl.text.length != 6) {
                            ToastHelper.showError(
                                message: "Enter valid pincode");
                            return;
                          }

                          setStateDialog(() {
                            isLoading = true;
                          });

                          try {
                            final city = await ref.read(cityProviders.notifier).getCityByPincode(pinCtrl.text);

                            Navigator.pop(context);

                            if (city != null) {
                              onSelected(city);
                            }
                          } catch (e) {
                            ToastHelper.showError(
                                message: "Invalid pincode");
                          }

                          setStateDialog(() {
                            isLoading = false;
                          });
                        },
                        backgroundColor: AppColors.primary,
                        text: "Find City")

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> createSurvey() async {

    final companyId = await StorageService().getCompanyId();

    final body = {
      "company_id": companyId,
      "company_name": "",
      "customer_name": nameCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "survey_date": getFormattedDate(),
      "moving_from": selectedMovingFormCity?.name ?? "",
      "moving_to": selectedMovingToCity?.name ?? "",
    };

    try {
      final response = await NetworkHandler().post(
        "survey/create",
        body,
      );

      final data = response.data;

      // 🔍 Debug logs
      print("URL: /api/survey/create");
      print("Request: $body");
      print("StatusCode: ${response.statusCode}");
      print("Response: $data");

      // ✅ Use success flag (BEST PRACTICE)
      if (data["success"] == true) {
        ToastHelper.showSuccess(message: data["message"]);

        String surveyNo = data["survey_no"];
        String uid = data["uid"];

        print("✅ Survey No: $surveyNo");
        print("✅ UID: $uid");

        String link = "https://join.unsurveyi.com/project/$uid";
        showSuccessDialog(
          context: navigatorKey.currentContext!, // or pass context
          name: nameCtrl.text,
          phone: phoneCtrl.text,
          from: selectedMovingFormCity?.name ?? "",
          to: selectedMovingToCity?.name ?? "",
          link: link,
        );

        // 👉 Optional: clear form / navigate
      } else {
        ToastHelper.showError(
          message: data["message"] ?? "Something went wrong",
        );
      }
    } on DioException catch (e) {
      // 🔴 Detailed error logs
      print("❌ API ERROR URL: /api/survey/create");
      print("❌ Request Body: $body");
      print("❌ Status Code: ${e.response?.statusCode}");
      print("❌ Response: ${e.response?.data}");

      ToastHelper.showError(
        message: e.response?.data?["message"] ?? "Server error",
      );
    } catch (e) {
      print("❌ EXCEPTION: $e");
      ToastHelper.showError(message: "Something went wrong");
    }
  }


  Future<void> submitSurvey() async {
    final companyId = await StorageService().getCompanyId();

    final isEdit = widget.item != null;

    final body = {
      "company_id": companyId,
      "company_name": "",
      "customer_name": nameCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "survey_date": getFormattedDate(),
      "moving_from": selectedMovingFormCity?.name ?? movingFromCtrl.text,
      "moving_to": selectedMovingToCity?.name ?? movingToCtrl.text,
    };

    try {
      final response = isEdit
          ? await NetworkHandler().put(
        "survey/update/${widget.item!.uid}", // ✅ UPDATE API
        body,
      )
          : await NetworkHandler().post(
        "survey/create", // ✅ CREATE API
        body,
      );

      final data = response.data;

      print("URL: ${isEdit ? "update" : "create"}");
      print("Body: $body");
      print("Response: $data");

      if (data["success"] == true) {
        ToastHelper.showSuccess(message: data["message"]);

        String uid = isEdit ? widget.item!.uid! : data["uid"];

        String link = "https://join.unsurveyi.com/project/$uid";

        showSuccessDialog(
          context: navigatorKey.currentContext!,
          name: nameCtrl.text,
          phone: phoneCtrl.text,
          from: body["moving_from"] ?? "",
          to: body["moving_to"] ?? "",
          link: link,
        );
      } else {
        ToastHelper.showError(
          message: data["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      print("❌ ERROR: $e");
      ToastHelper.showError(message: "Something went wrong");
    }
  }


  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      ref.read(quotationProvider.notifier).loadStates();

      ref.read(cityProviders.notifier).loadCities();
    });

    /// ✅ PREFILL (EDIT MODE)
    if (widget.item != null) {
      final data = widget.item!;

      surveyNoCtrl.text = data.id ?? "";
      nameCtrl.text = data.customer ?? "";
      phoneCtrl.text = data.phone ?? "";

      /// DATE FORMAT (yyyy-mm-dd → dd/mm/yyyy)
      if (data.date != null) {
        final d = DateTime.parse(data.date!);
        dateCtrl.text =
        "${d.day.toString().padLeft(2, '0')}/"
            "${d.month.toString().padLeft(2, '0')}/"
            "${d.year}";
      }

      /// LOCATION SPLIT (VERY IMPORTANT)
      if (data.location != null && data.location!.contains("→")) {
        final parts = data.location!.split("→");
        movingFromCtrl.text = parts[0].trim();
        movingToCtrl.text = parts[1].trim();
      }
    }
  }
  void showSuccessDialog({
    required BuildContext context,
    required String name,
    required String phone,
    required String from,
    required String to,
    required String link,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// CLOSE BUTTON
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                /// ICON
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.orange.shade100,
                  child: Image.asset("assets/images/link_success.png"),
                ),

                const SizedBox(height: 12),

                /// TITLE
                const Text(
                  "Success!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  "You’ve just created a new survey list.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                /// NAME & PHONE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name", style: TextStyles.f11w400Gray9),
                        const SizedBox(height: 2),
                        Text(name, style: TextStyles.f12w600Gray9),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Phone no.", style: TextStyles.f11w400Gray9),
                        const SizedBox(height: 2),
                        Text(phone, style: TextStyles.f12w600Gray9),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// FROM - TO CARD
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [

                      /// FROM
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("From", style: TextStyles.f10w400Gray9),
                          const SizedBox(height: 2),
                          Text(
                            from,
                            style: TextStyles.f12w600Gray9
                                .copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),

                      const SizedBox(width: 8),

                      /// LINE
                      const Expanded(
                        child: Divider(thickness: 1),
                      ),

                      const SizedBox(width: 8),

                      /// TRUCK ICON
                      SvgPicture.asset(
                        "assets/images/truck_orange.svg",
                        height: 20,
                      ),

                      const SizedBox(width: 8),

                      /// LINE
                      const Expanded(
                        child: Divider(thickness: 1),
                      ),

                      const SizedBox(width: 8),

                      /// TO
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("To", style: TextStyles.f10w400Gray9),
                          const SizedBox(height: 2),
                          Text(
                            to,
                            style: TextStyles.f12w600Gray9
                                .copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// SHARE LINK
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Share link",
                      style: TextStyles.f11w400Gray9),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          link,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/images/copy.svg",
                          height: 18,
                        ),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: link));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(content: Text("Copied")),
                          );
                        },
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // ✅
                          ),
                          side: BorderSide(
                              color: Colors.grey.shade300),
                        ),
                        child: Text(
                          "Close",
                          style: TextStyles.f12w600Gray9
                              .copyWith(
                              color: AppColors.mGray7),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          //Share.share(link);
                          final url = Uri.parse(
                            "https://wa.me/?text=${Uri.encodeComponent(link)}",
                          );
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        },
                        icon: Image.asset(
                          "assets/images/whatsapp.png",
                          height: 18,
                        ),
                        label: Text(
                          "Send to WhatsApp",
                          style: TextStyles.f12w600Gray9
                              .copyWith(
                              color: AppColors.mWhite),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // ✅
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    // final stateData = ref.watch(quotationProvider);
    // final stateItems = stateData.states?.map((e) => DropdownItem(
    //   value: e.id.toString(),
    //   label: e.name ?? "",
    // )).toList() ?? [];
    final cityState = ref.watch(cityProviders);

    final cityItems = cityState.cities.map((e) {
      return DropdownItem(
        value: e.id.toString(),
        label: e.displayName, // "Bangalore, Karnataka"
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.mWhite,
      resizeToAvoidBottomInset: false,
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

      body: SafeArea(
        child: Column(
          children: [
            Container(height: 10,color: Color(0xFFDBDBDB)),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Survey No (disabled)
                  FieldLabel("surveyForm.surveyNo".tr()),
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
        
                  FieldLabel("common.name".tr()),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: nameCtrl,
                    hintText: 'Enter Name',
                  ),
                  const SizedBox(height: 16),
        
                  FieldLabel("common.phone".tr()),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: phoneCtrl,
                    hintText: 'Enter phone no.',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
        
        
                  FieldLabel("common.date".tr()),
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
        // FieldLabel(),
        //                 Expanded(
        //                   child: commonStateCityDropdowns(
        //                       title: "lr.fields.movingFrom".tr(),
        //                       addButton:InkWell(
        //                         onTap: (){
        //
        //                           //moving city
        //                           // optinal but if click open dialog there user enter pincode base on pincode select the city
        //                         },
        //                           child: Text("select city by pin code")
        //                       ),
        //                       isRequired: false,
        //                       value: selectedMovingFormCity?.id.toString(),
        //                       items: stateItems,
        //                       onChanged: (item) {
        //                         if (item != null) {
        //                           final selected = stateData.states?.firstWhere((e) => e.id.toString() == item.value);
        //
        //                           if (selected != null) {
        //                             setState(() {
        //                               selectedMovingFormCity = selected;
        //                             });
        //                             print("MovingFormState >>>>>>>>>>>>>>>>>>${item.value}");
        //                           }
        //                         }
        //                       }
        //
        //                   ),
        //                 ),
                  Expanded(
                    child: commonStateCityDropdowns(
                      title: "lr.fields.movingFrom".tr(),
                      addButton: InkWell(
                        onTap: () {
                          showPincodeDialog(
                            context: context,
                            onSelected: (city) {
                              setState(() {
                                selectedMovingFormCity = city;
                              });
                            },
                          );
                        },
                        child: Icon(Icons.add_circle_outline,color: AppColors.primary,size: 18,),
                      ),
                      isRequired: false,
                      value: selectedMovingFormCity?.id.toString(),
                      items: cityItems,
                      onChanged: (item) {
                        if (item != null) {
                          final selected = cityState.cities.firstWhere(
                                (e) => e.id.toString() == item.value,
                          );
        
                          setState(() {
                            selectedMovingFormCity = selected;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: commonStateCityDropdowns(
                      title: "lr.fields.movingTo".tr(),
                      addButton: InkWell(
                        onTap: () {
                          showPincodeDialog(
                            context: context,
                            onSelected: (city) {
                              setState(() {
                                selectedMovingToCity = city;
                              });
                            },
                          );
                        },
                        child: Icon(Icons.add_circle_outline,color: AppColors.primary,size: 18,),
                      ),
                      isRequired: false,
                      value: selectedMovingToCity?.id.toString(),
                      items: cityItems,
                      onChanged: (item) {
                        if (item != null) {
                          final selected = cityState.cities.firstWhere(
                                (e) => e.id.toString() == item.value,
                          );
        
                          setState(() {
                            selectedMovingToCity = selected;
                          });
                        }
                      },
                    ),
                  ),
                  // Expanded(
                  //   child: commonStateCityDropdowns(
                  //       title: "lr.fields.movingTo".tr(),
                  //       addButton:InkWell(
                  //           onTap: (){
                  //             // optinal but if click open dialog there user enter pincode base on pincode select the city
                  //           },
                  //           child: Text("select city by pin code")
                  //       ),
                  //       isRequired: false,
                  //       value: selectedMovingToCity?.id.toString(),
                  //       items: stateItems,
                  //       onChanged: (item) {
                  //         if (item != null) {
                  //           final selected = stateData.states?.firstWhere((e) => e.id.toString() == item.value);
                  //
                  //           if (selected != null) {
                  //             setState(() {
                  //               selectedMovingToCity = selected;
                  //             });
                  //             print("MovingToState>>>>>>>>>>>>>>>>>>${item.value}");
                  //           }
                  //         }
                  //       }
                  //
                  //   ),
                  // ),
        
                  Spacer(),
                  CustomButton(
                    onPressed: () {
                      // if (validateForm()) {
                      //   createSurvey();
                      // }
                      if (validateForm()) {
                        if (widget.item != null) {
                          // ✅ EDIT FLOW
                          submitSurvey();
                        } else {
                          // ✅ CREATE FLOW
                          createSurvey();
                        }
                      }
                    },
                    borderRadius: 6,
                    backgroundColor: AppColors.primary,
                    text: "common.submit".tr(),
                    textStyle: TextStyles.f14w600Primary.copyWith(color: AppColors.mWhite),
                  ),
        
                  const SizedBox(height: 20),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
