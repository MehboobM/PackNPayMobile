import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pack_n_pay/screens/staff/widgets/calender.dart';
import '../../database/hive_database/hive_permission.dart';
import '../../models/staff_details_modal.dart';
import '../../models/staff_user_model.dart';
import '../../repositry/userstaff_repository.dart';
import '../../routes/route_names_const.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';

class StaffDetailsScreen extends StatefulWidget {
  final UserModel user;

  const StaffDetailsScreen({super.key, required this.user});

  @override
  State<StaffDetailsScreen> createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  late bool isActive;
  UserModel? userData;
  bool isLoading = true;
  Map<String, dynamic> attendanceMap = {};
  int totalDaysWorked = 0;

  int surveyCount = 0;
  int quotationCount = 0;
  int orderCount = 0;
  int lrCount = 0;

  DateTime selectedMonth = DateTime(2026, 4);
  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return "-";
    }
  }

  String formatCurrency(String? amount) {
    if (amount == null || amount.isEmpty) return "-";
    final value = double.tryParse(amount);
    if (value == null) return "-";
    return "₹${value.toStringAsFixed(0)}";
  }
  Future<void> _fetchUserDetails() async {
    try {
      final repository = UserRepository();

      final response = await repository.getUserByUid(widget.user.uid);

      print("DETAIL RESPONSE => $response"); // ✅ debug

      final details = UserDetailsModel.fromJson(response);

      setState(() {
        userData = widget.user;

        attendanceMap = details.attendanceMap ?? {};
        totalDaysWorked = details.totalDaysWorked ?? 0;

        surveyCount = details.surveyCount ?? 0;
        quotationCount = details.quotationCount ?? 0;
        orderCount = details.orderCount ?? 0;
        lrCount = details.lrCount ?? 0;

        isLoading = false; // ✅ CORRECT
      });
    } catch (e) {
      print("ERROR => $e");

      setState(() {
        isLoading = false; // ✅ MUST USE setState
      });

      ToastHelper.showError(message: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    isActive = widget.user.status == "ACTIVE";
    _fetchUserDetails();
  }


  @override
  Widget build(BuildContext context) {
    final user = userData ?? widget.user;
    final canEditStaff = PermissionHelper.canEdit(ModuleCode.staff);
    final canDeleteStaff = PermissionHelper.canDelete(ModuleCode.staff);
    return Scaffold(
      backgroundColor: AppColors.bodysecondry,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        title: Text("Staff Details", style: TextStyles.f16w600mGray9),
        actions: [
          /// ✏️ EDIT BUTTON

          if(canEditStaff)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  newStaffScreenRoute,
                  arguments: widget.user,
                );

                if (result == true) {
                  Navigator.pop(context, true);
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/edit.svg",
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text("Edit", style: TextStyles.f12w600primary),
                ],
              ),
            ),
          ),

          /// 🗑️ DELETE BUTTON
          if(canDeleteStaff)
           Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: _confirmDelete,
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/Trash.svg",
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Colors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Delete",
                    style: TextStyles.f12w600primary.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= HEADER =================
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.purple.shade100,
                      backgroundImage: user.profileImage != null &&
                          user.profileImage!.isNotEmpty
                          ? NetworkImage(user.profileImage!)
                          : null,
                      child: user.profileImage == null ||
                          user.profileImage!.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? "-",
                            style: TextStyles.f14w600mGray9,
                          ),
                          const SizedBox(height: 4),

                          /// Staff ID and Login Code
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic, // Required for baseline alignment
                            children: [
                              Text(
                                "Staff ID: ",
                                style: TextStyles.f10w500Gray6,
                              ),
                              Text(
                                user.role ?? "-",
                                style: TextStyles.f10w500Gray9,
                              ),
                              Text(
                                " | Login: ",
                                style: TextStyles.f10w500Gray6,
                              ),

                              /// Login Code (Max 2 Lines)
                              Expanded(
                                child: Text(
                                  user.uid ?? "-",
                                  style: TextStyles.f10w500Gray9.copyWith(
                                    height: 1, // Improves spacing between wrapped lines
                                  ),
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildActiveSwitch(),
                  ],
                ),

                const SizedBox(height: 8),

                // ================= BASIC DETAILS =================
                _sectionTitle("Basic Details"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _info("Name", user.name)),
                    Expanded(
                      child: _info(
                        "Alternate mobile no.",
                        user.alternateMobile,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _info("Mobile no.", user.mobile)),
                    Expanded(child: _info("Email", user.email)),
                  ],
                ),
                _info("Address", user.address),

                // ================= EMPLOYMENT DETAILS =================
                _sectionTitle("Employment Details"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _info(
                        "Joining Date",
                        formatDate(user.joiningDate),
                      ),
                    ),
                    Expanded(
                      child: _info(
                        "Advance Salary",
                        formatCurrency(user.advanceSalary),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _info("Role", user.role)),
                    Expanded(
                      child: _info(
                        "Base Salary",
                        formatCurrency(user.baseSalary),
                      ),
                    ),
                  ],
                ),
                _info("Address", user.address),

                const SizedBox(height: 8),

                // ================= ATTENDANCE =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Attendance",
                      style: TextStyles.f12w600primary,
                    ),
                    _monthSelector(),
                  ],
                ),
                const SizedBox(height: 10),
                _attendanceCalendar(),

                const SizedBox(height: 16),

                // ================= ORDER COUNTS =================
                _sectionTitle("Order Counts"),
                Row(
                  children: [
                    buildStatItem("Survey", surveyCount.toString()),
                    buildStatItem("Quotation", quotationCount.toString()),
                    buildStatItem("LR/Bilty", lrCount.toString()),
                    buildStatItem("Orders", orderCount.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= ACTIVE SWITCH (YOUR STYLE) =================
  Widget _buildActiveSwitch() {
    final isOn = isActive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.75,
          child: Switch(
            value: isOn,
            onChanged: (val) {
              setState(() => isActive = val);
            },
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryGreen,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.red.shade300,
          ),
        ),

      ],
    );
  }

  // ================= MONTH SELECTOR =================


  Widget _monthSelector() {
    return InkWell(
      onTap: _selectMonth,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SVG Calendar Icon
            SvgPicture.asset(
              "assets/icons/calender_icon.svg",
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Colors.black87,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 4),

            // Month and Year Text
            Text(
              DateFormat('MMMM yyyy').format(selectedMonth),
              style: TextStyles.f11w600Gray9
            ),
            const SizedBox(width: 4),

            // Dropdown Arrow
             Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: AppColors.mBlack9,
            ),
          ],
        ),
      ),
    );
  }

  // ================= ATTENDANCE GRID (SIMPLE MOCK UI) =================
  Widget _attendanceCalendar() {
    final DateTime firstDayOfMonth =
    DateTime(selectedMonth.year, selectedMonth.month, 1);

    final int daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;

    // Convert weekday to Sunday-start index
    final int startWeekday = firstDayOfMonth.weekday % 7;

    final int daysInPrevMonth =
        DateTime(selectedMonth.year, selectedMonth.month, 0).day;

    // Sample attendance data
    final Map<int, String> attendanceData = {};

    attendanceMap.forEach((date, value) {
      try {
        final parsedDate = DateTime.parse(date);

        if (parsedDate.month == selectedMonth.month &&
            parsedDate.year == selectedMonth.year) {
          attendanceData[parsedDate.day] =
          (value.isNotEmpty && value[0]['status'] == "P") ? "P" : "A";
          }
          } catch (_) {}
        });

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // ================= WEEKDAY HEADER =================
            Container(
              color: const Color(0xFF2E2A72),
              child: Row(
                children: const [
                  WeekDayHeader("SUN"),
                  WeekDayHeader("MON"),
                  WeekDayHeader("TUE"),
                  WeekDayHeader("WED"),
                  WeekDayHeader("THU"),
                  WeekDayHeader("FRI"),
                  WeekDayHeader("SAT"),
                ],
              ),
            ),

            // ================= DATE GRID =================
            Column(
              children: List.generate(5, (week) {
                return Row(
                  children: List.generate(7, (day) {
                    final int cellIndex = week * 7 + day;
                    int date;
                    bool isCurrentMonth = true;

                    if (cellIndex < startWeekday) {
                      date =
                          daysInPrevMonth - startWeekday + cellIndex + 1;
                      isCurrentMonth = false;
                    } else if (cellIndex >=
                        startWeekday + daysInMonth) {
                      date =
                          cellIndex - startWeekday - daysInMonth + 1;
                      isCurrentMonth = false;
                    } else {
                      date = cellIndex - startWeekday + 1;
                    }

                    final String? status =
                    isCurrentMonth ? attendanceData[date] : null;

                    return Expanded(
                      child: _buildGridDateCell(
                        date: date,
                        isCurrentMonth: isCurrentMonth,
                        status: status,
                      ),
                    );
                  }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildGridDateCell({
    required int date,
    required bool isCurrentMonth,
    String? status,
  }) {
    Color? bgColor;
    Color textColor =
    isCurrentMonth ? Colors.black : Colors.grey.shade400;

    if (status == "P") {
      bgColor = AppColors.greenlight;
    } else if (status == "A") {
      bgColor = Colors.red.withOpacity(0.20);
    }

    return Container(
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 11,
              color: textColor,
            ),
          ),
          if (status != null) ...[
            const Spacer(),
            Center(
              child: Column(
                children: [
                   Text(
                    "10/10",
                    style: TextStyles.f9w700mGray9
                  ),
                  if (status == "P")
                    Text(
                      "P",
                      style: TextStyles.f9w700mGray9
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= HELPERS =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyles.f10w600Primary
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              height: 1,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildStatItem(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.mGray3.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyles.f12w700b),
            const SizedBox(height: 2),
            Text(title, style: TextStyles.f10w400Gray9),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:  TextStyles.f10w500Gray6
          ),
          const SizedBox(height: 8),
          Text(
            value ?? "-",
            style: TextStyles.f12w600Gray9
          ),
        ],
      ),
    );
  }

  Future<void> _selectMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        selectedMonth = DateTime(picked.year, picked.month);
      });
    }
  }
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // ✅ White dialog background
        surfaceTintColor: Colors.white, // Prevents Material 3 tint
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          "Delete Staff",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          "Are you sure you want to delete this staff member?",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          /// ❌ Cancel Button
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Text color
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          /// 🗑️ Delete Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Button background
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _deleteStaff();
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _deleteStaff() async {
    try {
      final repository = UserRepository();
      final success =
      await repository.deleteUser(widget.user.uid);

      if (success) {
        ToastHelper.showSuccess(
          message: "Staff deleted successfully",
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ToastHelper.showError(message: e.toString());
    }
  }
}