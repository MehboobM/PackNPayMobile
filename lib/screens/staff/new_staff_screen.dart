import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../global_data/dropdown_data.dart';
import '../../global_widget/custom_button.dart';
import '../../global_widget/custom_textfield.dart';
import '../../global_widget/dropdown_with textfield.dart';
import '../../models/staff_user_model.dart';
import '../../repositry/userstaff_repository.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';

class NewStaffScreen extends StatefulWidget {
  final UserModel? user;

  const NewStaffScreen({super.key, this.user});

  @override
  State<NewStaffScreen> createState() => _NewStaffScreenState();
}

class _NewStaffScreenState extends State<NewStaffScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController advanceSalaryController = TextEditingController();
  final TextEditingController baseSalaryController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  // ✅ NEW FIELDS
  final TextEditingController loginCodeController = TextEditingController();
  late TextEditingController joiningDateController;
  late TextEditingController dobController;

  final UserRepository _userRepository = UserRepository();

  DateTime? joiningDate;
  DateTime? dob;

  List<Map<String, dynamic>> roleOptions = [];
  String selectedRole = "";
  bool get isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();

    joiningDateController = TextEditingController();
    dobController = TextEditingController();

    /// Load roles from globalJson
    final data = globalJson["user_role"] as Map<String, dynamic>;
    final options = data["options"] as List;
    roleOptions = options.map((e) => Map<String, dynamic>.from(e)).toList();

    if (roleOptions.isNotEmpty) {
      selectedRole = roleOptions.first["label"];
    }

    /// Prefill fields in edit mode
    if (isEditMode) {
      final user = widget.user!;

      nameController.text = user.name ?? "";
      phoneController.text = user.mobile ?? "";
      altPhoneController.text = user.alternateMobile ?? "";
      emailController.text = user.email ?? "";
      addressController.text = user.address ?? "";
      advanceSalaryController.text = user.advanceSalary ?? "";
      baseSalaryController.text = user.baseSalary ?? "";
      loginCodeController.text = user.loginCode ?? "";

      joiningDate = user.joiningDate != null
          ? DateTime.tryParse(user.joiningDate!)
          : null;

      if (joiningDate != null) {
        joiningDateController.text =
            DateFormat('dd/MM/yyyy').format(joiningDate!);
      }

      // Set selected role
      final roleMatch = roleOptions.firstWhere(
            (e) => e["value"] == user.role,
        orElse: () => roleOptions.first,
      );
      selectedRole = roleMatch["label"];
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    altPhoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    advanceSalaryController.dispose();
    baseSalaryController.dispose();
    roleController.dispose();
    loginCodeController.dispose();
    joiningDateController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Widget buildField(String title, TextEditingController controller,
      {String hint = '', TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.f12w500Gray7),
          const SizedBox(height: 6),
          CustomTextField(
            controller: controller,
            hintText: hint,
            keyboardType: keyboard,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }

  /// ✅ DATE FIELD (Reusable for DOB + Joining)
  Widget buildDateField(
      String title,
      TextEditingController controller,
      Function(DateTime) onDateSelected,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.f12w500Gray7),
        const SizedBox(height: 6),
        CustomTextField(
          controller: controller,
          hintText: "00/00/0000",
          materialIcon: Icons.calendar_today_outlined,
          borderRadius: 12,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onDateSelected(picked);
              controller.text = DateFormat('dd/MM/yyyy').format(picked);
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDropdownField(
      String title, String value, List<String> items, TextEditingController controller) {
    return DropdownWithField(
      title: title,
      value: value,
      items: items,
      controller: controller,
      hintText: "Enter $title",
      onChanged: (val) {
        if (val != null) setState(() => selectedRole = val);
      },
    );
  }

  /// ✅ SAVE FUNCTION
  Future<void> saveUser() async {
    try {
      if (nameController.text.isEmpty) {
        ToastHelper.showError(message: "Name is required");
        return;
      }

      final body = {
        "company_id": 1,
        "name": nameController.text.trim(),
        "role": roleOptions
            .firstWhere((e) => e["label"] == selectedRole)["value"],
        "login_code": loginCodeController.text.trim(),
        "email": emailController.text.trim(),
        "mobile": phoneController.text.trim(),
        "alternate_mobile": altPhoneController.text.trim(),
        "address": addressController.text.trim(),
        "base_salary": int.tryParse(baseSalaryController.text) ?? 0,
        "advance_salary": int.tryParse(advanceSalaryController.text) ?? 0,
      };

      if (joiningDate != null) {
        body["joining_date"] =
            DateFormat('yyyy-MM-dd').format(joiningDate!);
      }

      if (dob != null) {
        body["dob"] = DateFormat('yyyy-MM-dd').format(dob!);
      }

      bool success;

      if (isEditMode) {
        success = await _userRepository.updateUser(
          widget.user!.uid,
          body,
        );
      } else {
        success = await _userRepository.createUser(body);
      }

      if (success) {
        ToastHelper.showSuccess(
          message: isEditMode
              ? "Staff updated successfully"
              : "Staff created successfully",
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ToastHelper.showError(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          isEditMode ? "Edit Staff" : "New Staff",
          style: TextStyles.f16w600mGray9,
        ),
      ),

      body: Column(
        children: [

          Container(
            height: 14,
            width: double.infinity,
            color: AppColors.mGray3,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔹 BASIC DETAILS
                  Row(
                    children: [
                      Text("Basic Details", style: TextStyles.f14w600Primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(height: 1.2, color: AppColors.mGray3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  buildField("staff.form.name".tr(), nameController, hint: "Enter name"),
                  buildField("staff.card.loginCode".tr(), loginCodeController, hint: "Enter login code"),

                  buildDateField("staff.form.dob".tr(), dobController, (val) {
                    setState(() => dob = val);
                  }),

                  Row(
                    children: [
                      Expanded(
                        child: buildField("staff.form.mobile".tr(), phoneController,
                            hint: "Enter mobile", keyboard: TextInputType.phone),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: buildField("staff.form.altMobile".tr(), altPhoneController,
                            hint: "Enter alternate phone",
                            keyboard: TextInputType.phone),
                      ),
                    ],
                  ),

                  buildField("staff.form.email".tr(),  emailController, hint: "Enter email"),
                  buildField("staff.form.address".tr(), addressController, hint: "Write address..."),

                  const SizedBox(height: 20),

                  /// 🔹 EMPLOYMENT DETAILS
                  Row(
                    children: [
                      Text("Employment Details", style: TextStyles.f14w600Primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(height: 1.2, color: AppColors.mGray3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  buildDateField("staff.form.joiningDate".tr(), joiningDateController, (val) {
                    setState(() => joiningDate = val);
                  }),

                  Row(
                    children: [
                      Expanded(
                        child: buildField("staff.form.advSalary".tr(), advanceSalaryController,
                            hint: "₹", keyboard: TextInputType.number),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: buildField("staff.form.baseSalary".tr(), baseSalaryController,
                            hint: "₹", keyboard: TextInputType.number),
                      ),
                    ],
                  ),

                  DropdownWithField(
                    title: "staff.form.role".tr(),
                    value: selectedRole, // 👈 FIX
                    items: roleOptions.map((e) => e["label"].toString()).toList(),
                    controller: roleController,
                    hintText: "Select the role",
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedRole = val; // 👈 store label for UI
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Back",
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          borderColor: AppColors.primary,
                          borderRadius: 10,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: isEditMode ? "Update" : "Save",
                          onPressed: saveUser,
                          backgroundColor: AppColors.primary,
                          borderRadius: 10,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}