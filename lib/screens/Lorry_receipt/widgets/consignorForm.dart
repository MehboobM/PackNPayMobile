import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../../global_widget/custom_button.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/location_notifier.dart' show cityProvider, stateProvider;
import '../../../notifier/lorry_receiptnotifier.dart';
import '../../../notifier/lr_provider.dart';
import '../../Quotation/widget/insurance_and_other_form.dart';

class ConsignorForm extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ConsignorForm({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<ConsignorForm> createState() => _ConsignorFormState();
}

class _ConsignorFormState extends ConsumerState<ConsignorForm> {
  final _formKey = GlobalKey<FormState>();
  /// Controllers - Move From
  final TextEditingController consignorNameFromController =
  TextEditingController();
  final TextEditingController consignorPhoneFromController =
  TextEditingController();
  final TextEditingController consignorGstinFromController =
  TextEditingController();
  final TextEditingController pincodeFromController =
  TextEditingController();
  final TextEditingController addressFromController =
  TextEditingController();

  /// Controllers - Move To
  final TextEditingController consignorNameToController =
  TextEditingController();
  final TextEditingController consignorPhoneToController =
  TextEditingController();
  final TextEditingController consignorGstinToController =
  TextEditingController();
  final TextEditingController pincodeToController =
  TextEditingController();
  final TextEditingController addressToController =
  TextEditingController();

  bool moveFromExpanded = true;
  bool moveToExpanded = true;
  String? selectedFromState;
  String? selectedFromCity;
  int? selectedFromStateId;
  int? selectedFromCityId;

  String? selectedToState;
  String? selectedToCity;
  int? selectedToStateId;
  int? selectedToCityId;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(lrFormDataProvider);
      if (data.isNotEmpty) {
        _populateFields(data);
        setState(() {});
      }
    });
  }
  void _populateFields(Map<String, dynamic> data) {
    final from = data["consignor_from"] ?? {};
    final to = data["consignor_to"] ?? {};

    consignorNameFromController.text = from["name"] ?? "";
    consignorPhoneFromController.text = from["phone"] ?? "";
    consignorGstinFromController.text = from["gst_no"] ?? "";
    pincodeFromController.text = from["pincode"] ?? "";
    addressFromController.text = from["address"] ?? "";
    selectedFromState = from["state"]?.toString();
    selectedFromCity = from["city"]?.toString();

    consignorNameToController.text = to["name"] ?? "";
    consignorPhoneToController.text = to["phone"] ?? "";
    consignorGstinToController.text = to["gst_no"] ?? "";
    pincodeToController.text = to["pincode"] ?? "";
    addressToController.text = to["address"] ?? "";
    selectedFromState = from["state"]?.toString();
    selectedFromCity = from["city"]?.toString();


  }
  @override
  Widget build(BuildContext context) {
    final dropdown = ref.read(dropdownProvider.notifier);

    final countryItems =
    dropdown.getLabels("country").toSet().toList();

    final stateItems =
    dropdown.getLabels("state").toSet().toList();

    final cityItems =
    dropdown.getLabels("city").toSet().toList();
    if (selectedFromState != null &&
        !stateItems.contains(selectedFromState)) {
      selectedFromState = null;
    }

    if (selectedFromCity != null &&
        !cityItems.contains(selectedFromCity)) {
      selectedFromCity = null;
    }

    return Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: Column(
        children: [
          /// FORM CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// ================= MOVE FROM =================
                    _sectionHeader(
                      "consignorFrom.title".tr(),
                      moveFromExpanded,
                          () => setState(
                            () => moveFromExpanded = !moveFromExpanded,
                      ),
                    ),

                    if (moveFromExpanded)
                      _consignorSection(
                        isFromSection: true,
                        nameController: consignorNameFromController,
                        phoneController: consignorPhoneFromController,
                        gstController: consignorGstinFromController,
                        pincodeController: pincodeFromController,
                        addressController: addressFromController,
                        countryItems: countryItems,
                      ),

                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 1.2,
                      color: AppColors.primary,
                    ),

                    /// ================= MOVE TO =================
                    _sectionHeader(
                      "Consignor/Move To",
                      moveToExpanded,
                          () => setState(
                            () => moveToExpanded = !moveToExpanded,
                      ),
                    ),

                    if (moveToExpanded)
                      _consignorSection(
                        isFromSection: false,
                        nameController: consignorNameToController,
                        phoneController: consignorPhoneToController,
                        gstController: consignorGstinToController,
                        pincodeController: pincodeToController,
                        addressController: addressToController,
                        countryItems: countryItems,
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),

          /// BOTTOM BUTTONS
          _buildBottomBar(),
        ],
      ),
        ),
    );
  }

  /// 🔹 Reusable Consignor Section
  Widget _consignorSection({
    required bool isFromSection,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController gstController,
    required TextEditingController pincodeController,
    required TextEditingController addressController,
    required List<String> countryItems,
  }) {
    final selectedState =
    isFromSection ? selectedFromState : selectedToState;
    final selectedCity =
    isFromSection ? selectedFromCity : selectedToCity;
    final selectedStateId =
    isFromSection ? selectedFromStateId : selectedToStateId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formLabel("consignorFrom.consignorName".tr(),),
        const SizedBox(height: 6),
        CustomTextField(
          controller: nameController,
          hintText: "Enter name",
          borderRadius: 10,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Name is required";
            }
            return null;
          },
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formLabel("lr.fields.consignorPhone".tr(),),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: phoneController,
                    hintText: "Enter no.",
                    keyboardType: TextInputType.phone,
                    borderRadius: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number required";
                      }
                      if (value.length != 10) {
                        return "Enter valid 10 digit number";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formLabel("lr.fields.gstNo".tr(),),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: gstController,
                    hintText: "XXXXX-XXXXX",
                    borderRadius: 10,
                    validator: (value) {
                      if (value != null && value.isNotEmpty && value.length < 15) {
                        return "Invalid GST number";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// ================= COUNTRY & STATE =================
        Consumer(
          builder: (context, ref, _) {
            final statesAsync = ref.watch(stateProvider);

            return statesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (error, stack) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      const Text(
                        "Failed to load states",
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 6),
                      OutlinedButton(
                        onPressed: () => ref.refresh(stateProvider),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              },
              data: (states) {
                final stateNames =
                states.map((state) => state.name).toList();

                return Row(
                  children: [
                    Expanded(
                      child: reusableDropdown(
                        title: "lr.fields.country".tr(),
                        items: countryItems,
                        value: countryItems.contains("India") ? "India" : null,
                        onChanged: (val) {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: reusableDropdown(
                        title: "lr.fields.state".tr(),
                        items: stateNames,
                        value: stateNames.contains(selectedState) ? selectedState : null,
                        onChanged: (val) {
                          final selected = states.firstWhere(
                                  (state) => state.name == val);

                          setState(() {
                            if (isFromSection) {
                              selectedFromState = val;
                              selectedFromStateId = selected.id;
                              selectedFromCity = null;
                              selectedFromCityId = null;
                            } else {
                              selectedToState = val;
                              selectedToStateId = selected.id;
                              selectedToCity = null;
                              selectedToCityId = null;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),

        const SizedBox(height: 12),

        /// ================= CITY & PINCODE =================
        Row(
          children: [
            Expanded(
              child: selectedStateId == null
                  ? reusableDropdown(
                title: "lr.fields.city".tr(),
                items: const [],
                value: null,
                onChanged: (val) {},
              )
                  : Consumer(
                builder: (context, ref, _) {
                  final citiesAsync =
                  ref.watch(cityProvider(selectedStateId));

                  return citiesAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2),
                      ),
                    ),
                    error: (error, stack) {
                      debugPrint("City Error: $error");
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Failed to load cities",
                            style: TextStyle(color: Colors.red),
                          ),
                          TextButton(
                            onPressed: () =>
                                ref.refresh(cityProvider(selectedStateId!)),
                            child: const Text("Retry"),
                          ),
                        ],
                      );
                    },
                    data: (cities) {
                      final cityNames =
                      cities.map((city) => city.name).toList();

                      return reusableDropdown(
                        title: "lr.fields.city".tr(),
                        items: cityNames,
                        value: cityNames.contains(selectedCity) ? selectedCity : null,
                        onChanged: (val) {
                          final selectedCityModel =
                          cities.firstWhere(
                                  (city) => city.name == val);

                          setState(() {
                            if (isFromSection) {
                              selectedFromCity = val;
                              selectedFromCityId =
                                  selectedCityModel.id;
                            } else {
                              selectedToCity = val;
                              selectedToCityId =
                                  selectedCityModel.id;
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formLabel("lr.fields.pincode".tr(),),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: pincodeController,
                    hintText: "Enter",
                    keyboardType: TextInputType.number,
                    borderRadius: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Pincode required";
                      }
                      if (value.length != 6) {
                        return "Enter valid pincode";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        formLabel("lr.fields.address".tr(),),
        const SizedBox(height: 6),
        CustomTextField(
          controller: addressController,
          hintText: "Enter address",
          borderRadius: 10,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Address is required";
            }
            return null;
          },
        ),
      ],
    );
  }

  /// 🔹 Section Header
  Widget _sectionHeader(
      String title, bool expanded, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyles.f14w600mGray9,
              ),
            ),
            Icon(
              expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Bottom Navigation Buttons
  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: widget.onBack,
                text: "Back",
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                borderColor: AppColors.primary,
                height: 48,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  /// Validate dropdowns manually
                  if (selectedFromState == null || selectedFromCity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Select From State & City")),
                    );
                    return;
                  }

                  if (selectedToState == null || selectedToCity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Select To State & City")),
                    );
                    return;
                  }

                  final notifier = ref.read(lorryReceiptProvider.notifier);

                  updateFormData(ref, {
                    "consignor_from": {
                      "name": consignorNameFromController.text.trim(),
                      "phone": consignorPhoneFromController.text.trim(),
                      "gst_no": consignorGstinFromController.text.trim(),
                      "country": "India",
                      "state": selectedFromState ?? "",
                      "city": selectedFromCity ?? "",
                      "pincode": pincodeFromController.text.trim(),
                      "address": addressFromController.text.trim(),
                    },
                    "consignor_to": {
                      "name": consignorNameToController.text.trim(),
                      "phone": consignorPhoneToController.text.trim(),
                      "gst_no": consignorGstinToController.text.trim(),
                      "country": "India",
                      "state": selectedToState ?? "",
                      "city": selectedToCity ?? "",
                      "pincode": pincodeToController.text.trim(),
                      "address": addressToController.text.trim(),
                    },
                  });

                  widget.onNext(); // ✅ only after validation
                },
                text: "Save & Next  >>",
                iconRight: true,
                backgroundColor: AppColors.primary,
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}