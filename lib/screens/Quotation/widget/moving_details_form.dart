import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../global_widget/common_state_city_dropdown.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../global_widget/form_label_widget.dart';
import '../../../models/city_data.dart';
import '../../../models/dropdown_item.dart';
import '../../../models/state_data.dart';
import '../../../notifier/dropdown_notifier.dart';
import '../../../notifier/quatation_notifier.dart';
import '../../../notifier/quotation_form_notifier.dart';
import '../../../utils/m_font_styles.dart';
import 'gradient_title_widget.dart';
import 'insurance_and_other_form.dart';
import 'orange_devider.dart';


class MovingDetailsForm extends ConsumerStatefulWidget {
  const MovingDetailsForm({super.key});

  @override
  ConsumerState<MovingDetailsForm> createState() => _MovingDetailsFormState();
}

class _MovingDetailsFormState extends ConsumerState<MovingDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  late TextEditingController _shiftDateController;
  late TextEditingController _pickupPhoneNoController;
  late TextEditingController _pickupEmailController;
  late TextEditingController _pickupPincodeController;
  late TextEditingController _deliveryPhoneNoController;
  late TextEditingController _deliveryEmailController;
  late TextEditingController _deliveryPincodeController;




  @override
  void dispose() {
    _shiftDateController.dispose();
    _pickupPhoneNoController.dispose();
    _pickupEmailController.dispose();
    _pickupPincodeController.dispose();

    _deliveryPhoneNoController.dispose();
    _deliveryEmailController.dispose();
    _deliveryPincodeController.dispose();
    super.dispose();
  }


  States? findState(List<States>? list, String? id,String? code) {
    if (list == null || id == null) return null;
    try {
      return list.firstWhere((e) => (e.id.toString() == id || e.code.toString() == code));
    } catch (e) {
      return null;
    }
  }

  Cities? findCity(List<Cities>? list, String? id, String? name) {
    if (list == null || id == null) return null;
    try {
      return list.firstWhere((e) => (e.id.toString() == id || e.name.toString() == name));
    } catch (e) {
      return null;
    }
  }
  @override
  void initState() {
    super.initState();

    final data = ref.read(quotationFormProvider);

    /// Controllers
    _shiftDateController = TextEditingController(text: data.shiftingDate ?? "");

    _pickupPhoneNoController = TextEditingController(text: data.pickupPhone ?? "");
    _pickupEmailController = TextEditingController(text: data.pickupEmail ?? "");
    _pickupPincodeController = TextEditingController(text: data.pickupPincode ?? "");

    _deliveryPhoneNoController = TextEditingController(text: data.deliveryPhone ?? "");
    _deliveryEmailController = TextEditingController(text: data.deliveryEmail ?? "");
    _deliveryPincodeController = TextEditingController(text: data.deliveryPincode ?? "");

    /// Dropdown init
    selectedMovingDetail = data.pickupLiftAvailable ;
    selectedDeliveryDetail = data.deliveryLiftAvailable;

    /// 🔥 MAIN LOGIC (FIXED)
    Future.microtask(() async {
      final notifier = ref.read(quotationProvider.notifier);

      /// 1️⃣ LOAD STATES (WAIT PROPERLY)
      await notifier.loadStates();

      final stateData = ref.read(quotationProvider);

      /// =========================
      /// ✅ PICKUP SECTION
      /// =========================

      /// 2️⃣ Pickup State

      print("2:>>>>>>>>>>>>${data.pickupStateId}");
      print("3:>>>>>>>>>>>>${data.pickupCityId}");
      print("4:>>>>>>>>>>>>${data.pickupStateCode}");

      selectedPickupState = findState(stateData.states, data.pickupStateId,data.pickupStateCode);


      if (selectedPickupState != null) {
        /// 3️⃣ Load pickup cities properly
        await notifier.onStateSelected(selectedPickupState!);

        /// 4️⃣ NOW cities available → set city
        final cities = ref.read(quotationProvider).cities;

        selectedPickupCity = findCity(cities, data.pickupCityId,data.pickupCityName);

        ref.read(quotationFormProvider.notifier).state.pickupCityName = selectedPickupCity?.name;
      }

      /// =========================
      /// ✅ DELIVERY SECTION
      /// =========================

      /// 5️⃣ Delivery State
      selectedDeliveryState = findState(stateData.states, data.deliveryStateId,data.deliveryStateCode);

      if (selectedDeliveryState != null) {
        /// 6️⃣ Load delivery cities
        final res = await notifier.repository.fetchCities(selectedDeliveryState!.id!);

        deliveryCities = res.data ?? [];

        /// 7️⃣ NOW set delivery city
        selectedDeliveryCity = findCity(deliveryCities, data.deliveryCityId,data.deliveryCityName);
        ref.read(quotationFormProvider.notifier).state.deliveryCityName = selectedDeliveryCity?.name;
      }

      /// FINAL UI UPDATE
      setState(() {});
    });
  }

  String? selectedMovingDetail = null;
  String? selectedDeliveryDetail = null;

  States? selectedPickupState;
  Cities? selectedPickupCity;

  States? selectedDeliveryState;
  Cities? selectedDeliveryCity;
  List<Cities> deliveryCities = [];

  @override
  Widget build(BuildContext context) {

    final dropdown = ref.read(dropdownProvider.notifier);

    final liftAvailableItem = dropdown.getLabels("lift_available");
    final liftAvailableLabel = dropdown.getLabelByValue("lift_available", selectedMovingDetail);

    final liftDeliveryItem = dropdown.getLabels("lift_available");
    final liftDeliveryLabel = dropdown.getLabelByValue("lift_available", selectedDeliveryDetail);

    final stateData = ref.watch(quotationProvider);

    /// ✅ CONVERT TO DropdownItem
    final stateItems = stateData.states?.map((e) => DropdownItem(
      value: e.id.toString(),
      label: e.name ?? "",
    )).toList() ?? [];

    final pickupCityItems = stateData.cities?.map((e) => DropdownItem(
      value: e.id.toString(),
      label: e.name ?? "",
    )).toList() ?? [];

    final deliveryCityItems = deliveryCities.map((e) => DropdownItem(
      value: e.id.toString(),
      label: e.name ?? "",
    )).toList();


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Moving Details", style: TextStyles.f14w600mGray9),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GradientTitleWidget(title: 'Pickup Details',),
                ),
                Expanded(
                  child: OrangeDeviderWidget(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Shifting DATE + Moving DATE

            formLabel("Shifting/Moving Date", isRequired: true),
            const SizedBox(height: 6),
            CustomTextField(
              controller: _shiftDateController,
              hintText: "00/00/0000",
              borderRadius: 12,
              hintStyle: TextStyles.f12w400Gray5,
              materialIcon: Icons.calendar_today_outlined,
              onTap: () => pickDate(context, _shiftDateController),
              onChanged: (val) {
                ref.read(quotationFormProvider.notifier)
                    .state.shiftingDate = val;
              },
            ),

            const SizedBox(height: 16),

            /// Moving Details PHONE + EMAIL
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      formLabel("Additional phone no.", isRequired: true),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _pickupPhoneNoController,
                        hintText: "Enter phone no.",
                        onChanged: (val) {
                          ref.read(quotationFormProvider.notifier).state.pickupPhone = val;
                        },
                        keyboardType: TextInputType.phone,
                        borderRadius: 12,
                        hintStyle: TextStyles.f12w400Gray5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      formLabel("Email", isRequired: true),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _pickupEmailController,
                        hintText: "Enter email",
                        onChanged: (val) {
                          ref.read(quotationFormProvider.notifier).state.pickupEmail = val;
                        },
                        keyboardType: TextInputType.emailAddress,
                        borderRadius: 12,
                        hintStyle: TextStyles.f12w400Gray5,
                      ),
                    ],
                  ),
                ),
              ],
            ),


            const SizedBox(height: 16),

            ///Moving Details State + City
            Row(
              children: [
                /// STATE
                Expanded(
                  child: commonStateCityDropdowns(
                    title: "State",
                    isRequired: true,
                    value: selectedPickupState?.id.toString(),
                    items: stateItems,
                      onChanged: (item) {
                        if (item != null) {
                          final selected = stateData.states?.firstWhere((e) => e.id.toString() == item.value);

                          if (selected != null) {
                            setState(() {
                              selectedPickupState = selected;
                              selectedPickupCity = null;
                            });

                            ref.read(quotationProvider.notifier).onStateSelected(selected);

                            /// ✅ SAVE
                            ref.read(quotationFormProvider.notifier).state.pickupStateId = item.value;
                            ref.read(quotationFormProvider.notifier).state.pickupCityId = null;
                          }
                        }
                      }

                  ),
                ),

                const SizedBox(width: 12),

                /// CITY
                Expanded(
                  child: commonStateCityDropdowns(
                    title: "City",
                      isRequired: true,
                    value: selectedPickupCity?.id.toString(),
                    items: pickupCityItems,
                      onChanged: (item) {
                        if (item != null) {
                          final selected = stateData.cities?.firstWhere(
                                  (e) => e.id.toString() == item.value);

                          if (selected != null) {
                            setState(() {
                              selectedPickupCity = selected;
                            });

                            /// ✅ SAVE
                            ref.read(quotationFormProvider.notifier).state.pickupCityId = item.value;
                            ref.read(quotationFormProvider.notifier).state.pickupCityName = selected.name;
                          }
                        }
                      }

                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Pincode + Lift
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formLabel("Pincode", isRequired: true),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _pickupPincodeController,
                        hintText: "Enter pincode",
                        keyboardType: TextInputType.phone,
                        borderRadius: 12,
                        hintStyle: TextStyles.f12w400Gray5,
                        onChanged: (val) {
                          ref.read(quotationFormProvider.notifier).state.pickupPincode = val;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: reusableDropdown(
                    title: "Lift",
                    isRequired: true,
                    value: liftAvailableLabel,
                    items: liftAvailableItem,
                      onChanged: (value) {
                        final val = dropdown.getValueByLabel("lift_available", value ?? "");

                        setState(() {
                          selectedMovingDetail = val;
                        });

                        /// ✅ SAVE
                        ref.read(quotationFormProvider.notifier).state.pickupLiftAvailable = val;
                      }

                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),


            //Delivery detail
            Row(
              children: [
                Expanded(
                  child: GradientTitleWidget(title: 'Delivery Details',),
                ),
                Expanded(
                  child: OrangeDeviderWidget(),
                ),
              ],
            ),
            const SizedBox(height: 16),


            /// PHONE + EMAIL
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      formLabel("Additional phone no.", isRequired: true),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _deliveryPhoneNoController,
                        hintText: "Enter phone no.",
                        keyboardType: TextInputType.phone,
                        borderRadius: 12,
                        onChanged: (val) {
                          ref.read(quotationFormProvider.notifier).state.deliveryPhone = val;
                        },
                        hintStyle: TextStyles.f12w400Gray5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formLabel("Email", isRequired: true),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _deliveryEmailController,
                        hintText: "Enter email",
                        onChanged: (val) {
                          ref.read(quotationFormProvider.notifier).state.deliveryEmail = val;
                        },
                        keyboardType: TextInputType.emailAddress,
                        borderRadius: 12,
                        hintStyle: TextStyles.f12w400Gray5,
                      ),
                    ],
                  ),
                ),
              ],
            ),


            const SizedBox(height: 16),

            ///deliverydetail State + City
            Row(
              children: [
                /// STATE
                Expanded(
                  child: commonStateCityDropdowns(
                    title: "State",
                    isRequired: true,
                    value: selectedDeliveryState?.id.toString(),
                    items: stateItems,
                      onChanged: (item) async {
                        if (item != null) {
                          final selected = stateData.states
                              ?.firstWhere((e) => e.id.toString() == item.value);

                          if (selected != null) {
                            setState(() {
                              selectedDeliveryState = selected;
                              selectedDeliveryCity = null;
                              deliveryCities = [];
                            });

                            final res = await ref
                                .read(quotationProvider.notifier)
                                .repository
                                .fetchCities(selected.id!);

                            setState(() {
                              deliveryCities = res.data ?? [];
                            });

                            /// ✅ SAVE
                            ref.read(quotationFormProvider.notifier).state.deliveryStateId = item.value;
                            ref.read(quotationFormProvider.notifier).state.deliveryCityId = null;
                          }
                        }
                      }

                  ),
                ),

                const SizedBox(width: 12),

                /// CITY
                Expanded(
                  child: commonStateCityDropdowns(
                    title: "City",
                    isRequired: true,
                    value: selectedDeliveryCity?.id.toString(),
                    items: deliveryCityItems,
                      onChanged: (item) {
                        if (item != null) {
                          final selected = deliveryCities.firstWhere(
                                  (e) => e.id.toString() == item.value);

                          setState(() {
                            selectedDeliveryCity = selected;
                          });

                          /// ✅ SAVE
                          ref.read(quotationFormProvider.notifier).state.deliveryCityId = item.value;
                          ref.read(quotationFormProvider.notifier).state.deliveryCityName = selected.name;
                        }
                      }

                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Pincode + Lift
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      formLabel("Pincode", isRequired: true),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _deliveryPincodeController,
                        hintText: "Enter pincode",
                        keyboardType: TextInputType.phone,
                        borderRadius: 12,
                        hintStyle: TextStyles.f12w400Gray5,
                        onChanged: (val) {
                          ref.read(quotationFormProvider.notifier).state.deliveryPincode = val;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: reusableDropdown(
                    title: "Lift",
                    isRequired: true,
                    value: liftDeliveryLabel,
                    items: liftDeliveryItem,
                      onChanged: (value) {
                        final val = dropdown.getValueByLabel("lift_available", value ?? "");

                        setState(() {
                          selectedDeliveryDetail = val;
                        });

                        /// ✅ SAVE
                        ref.read(quotationFormProvider.notifier).state.deliveryLiftAvailable = val;
                      }

                  ),
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }

  Future<void> pickDate(
      BuildContext context,
      TextEditingController controller,
      ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";

      controller.text = formattedDate;

      /// ✅ SAVE TO PROVIDER
      ref.read(quotationFormProvider.notifier).state.shiftingDate = formattedDate;
    }
  }
}



