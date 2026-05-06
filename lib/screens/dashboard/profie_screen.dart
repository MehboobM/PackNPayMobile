import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../api_services/api_end_points.dart';
import '../../api_services/network_handler.dart';
import '../../repositry/Dashboard_repository.dart';
import '../../models/profile_modal.dart';
import '../../models/location_modal.dart';
import '../../repositry/lr_city_state.dart';
import '../../repositry/profile_repo.dart';
import '../../utils/toast_message.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DashboardService _service = DashboardService();
  final LocationRepository _locationRepo = LocationRepository();
  final ProfileRepository _profileRepo = ProfileRepository();

  ProfileModel? profile;

  bool isLoading = true;
  bool isPincodeLoading = false;
  bool isSaving = false;

  Timer? _debounce;

  /// Image
  final picker = ImagePicker();
  File? selectedImage;

  /// Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  List<StateModel> states = [];
  List<CityModel> cities = [];

  StateModel? selectedState;
  CityModel? selectedCity;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    try {
      profile = await _service.getProfile();
      states = await _locationRepo.getStates();

      nameCtrl.text = profile?.name ?? "";
      emailCtrl.text = profile?.email ?? "";
      phoneCtrl.text = profile?.mobile ?? "";
      addressCtrl.text = profile?.address ?? "";

      if (profile?.state != null) {
        final stateMatch =
        states.where((e) => e.name == profile!.state);

        if (stateMatch.isNotEmpty) {
          selectedState = stateMatch.first;

          cities = await _locationRepo
              .getCitiesByState(selectedState!.id);

          final cityMatch =
          cities.where((e) => e.name == profile!.city);

          if (cityMatch.isNotEmpty) {
            selectedCity = cityMatch.first;
          }
        }
      }
    } catch (e) {
      debugPrint("Init error: $e");
    }

    setState(() => isLoading = false);
  }

  /// IMAGE PICKER
  Future<void> pickImage() async {
    final picked =
    await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  /// PINCODE AUTO-FILL
  Future<void> fetchLocationFromPincode(String pincode) async {
    if (pincode.length != 6) return;

    try {
      setState(() => isPincodeLoading = true);

      final response = await NetworkHandler().get(
        ApiEndPoints.getLocationByPincode,
        queryParams: {"pincode": pincode},
      );

      if (response.statusCode == 200 &&
          response.data["success"] == true) {
        final data = response.data["data"];

        int stateId = data["state_id"];
        int cityId = data["city_id"];

        final stateMatch =
        states.where((e) => e.id == stateId);
        if (stateMatch.isNotEmpty) {
          selectedState = stateMatch.first;
        }

        cities =
        await _locationRepo.getCitiesByState(stateId);

        final cityMatch =
        cities.where((e) => e.id == cityId);
        if (cityMatch.isNotEmpty) {
          selectedCity = cityMatch.first;
        }

        setState(() {});
      }
    } catch (e) {
      debugPrint("Pincode API Error: $e");
    }

    setState(() => isPincodeLoading = false);
  }

  /// UPDATE PROFILE
  Future<void> updateProfile() async {
    setState(() => isSaving = true);

    try {
      final body = {
        "name": nameCtrl.text,
        "email": emailCtrl.text,
        "mobile": phoneCtrl.text,
        "state": selectedState?.id, // can be null
        "city": selectedCity?.id,   // can be null
        "pincode": pincodeCtrl.text,
        "address": addressCtrl.text,
      };

      final response = await _profileRepo.updateProfile(
        body: body,
        profileImage: selectedImage,
      );

      if (response.data["success"] == true) {
        ToastHelper.showSuccess(
          message: response.data["message"] ?? "Profile updated successfully",
        );
      } else {
        ToastHelper.showError(
          message: response.data["message"] ?? "Update failed",
        );
      }
    } catch (e) {
      ToastHelper.showError(
        message: "Something went wrong",
      );
    }

    setState(() => isSaving = false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// SAVE BUTTON
      floatingActionButton: ElevatedButton.icon(
        onPressed: isSaving ? null : updateProfile,
        icon: isSaving
            ? const SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: Colors.white),
        )
            : const Icon(Icons.save),
        label: const Text("Save Changes"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.only(top: 50, bottom: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6A75CA),
                    Color(0xFFD1C4E9),
                  ],
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : (profile!.profileImage != null
                          ? NetworkImage(
                          profile!.profileImage!)
                          : const AssetImage(
                          "assets/images/profile.png"))
                      as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(profile!.name),
                  Text(profile!.role),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// BASIC DETAILS
            buildCard(
              "Basic Details",
              Column(
                children: [
                  buildTextField("Name", nameCtrl),
                  buildTextField("Email", emailCtrl),
                  buildTextField("Phone", phoneCtrl),
                ],
              ),
            ),

            /// LOCATION
            buildCard(
              "Location",
              Column(
                children: [

                  buildDropdown<StateModel>(
                    "Select State",
                    selectedState,
                    states,
                        (val) async {
                      selectedState = val;
                      selectedCity = null;

                      cities = await _locationRepo
                          .getCitiesByState(val!.id);

                      setState(() {});
                    },
                  ),

                  buildDropdown<CityModel>(
                    "Select City",
                    selectedCity,
                    cities,
                        (val) {
                      setState(() {
                        selectedCity = val;
                      });
                    },
                  ),

                  buildTextField(
                    "Pincode",
                    pincodeCtrl,
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) {
                        _debounce!.cancel();
                      }

                      _debounce = Timer(
                        const Duration(milliseconds: 600),
                            () => fetchLocationFromPincode(value),
                      );
                    },
                    suffix: isPincodeLoading
                        ? const SizedBox(
                      height: 16,
                      width: 16,
                      child:
                      CircularProgressIndicator(
                          strokeWidth: 2),
                    )
                        : null,
                  ),

                  buildTextField("Address", addressCtrl),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  /// CARD
  Widget buildCard(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  /// TEXTFIELD
  Widget buildTextField(
      String hint,
      TextEditingController controller, {
        Function(String)? onChanged,
        Widget? suffix,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  /// DROPDOWN
  Widget buildDropdown<T>(
      String hint,
      T? value,
      List<T> items,
      Function(T?) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        value: value,
        hint: Text(hint),
        items: items.map((e) {
          return DropdownMenuItem<T>(
            value: e,
            child: Text((e as dynamic).name),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}