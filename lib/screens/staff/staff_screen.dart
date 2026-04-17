import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/screens/staff/widgets/staff_card.dart';

import '../../global_widget/custom_textfield.dart';
import '../../models/staff_user_model.dart';
import '../../notifier/staff_notifier.dart';
import '../../repositry/userstaff_repository.dart';
import '../../routes/route_names_const.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  late final StaffNotifier staffNotifier;
  final TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    staffNotifier = StaffNotifier(UserRepository());
  }

  @override
  void dispose() {
    searchController.dispose();
    staffNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodysecondry,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilterSection(),
          // 🔹 STAFF LIST
          Expanded(
            child: AnimatedBuilder(
              animation: staffNotifier,
              builder: (context, _) {
                final staff = staffNotifier.filteredStaff;
                if (staff.isEmpty) {
                  return const Center(child: Text("No staff found"));
                }
                return ListView.builder(
                  itemCount: staff.length,
                  itemBuilder: (context, index) {
                    final user = staff[index];
                    final joiningDate = user.joiningDate != null
                        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(user.joiningDate!))
                        : "-";

                    return StaffCardWidget(
                      name: user.name ?? "-",
                      staffId: user.role ?? "-",
                      loginCode: user.uid,
                      email: user.email ?? "-",
                      phone: user.mobile ?? "-",
                      joiningDate: joiningDate,
                      isActive: user.status == "ACTIVE",

                      onToggle: (val) {
                        staffNotifier.toggleStatus(user);
                      },

                      onView: () {
                        Navigator.pushNamed(
                          context,
                          staffDetailsScreenRoute,
                          arguments: user,
                        );
                      },

                      // ✅ EDIT FUNCTIONALITY
                      onEdit: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          newStaffScreenRoute,
                          arguments: user,
                        );

                        if (result == true) {
                          await staffNotifier.fetchUsers(); // 🔄 Auto-refresh list
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 SEARCH, FILTER & DATE PICKER
  Widget _buildSearchAndFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: searchController,
              hintText: "Search ",
              prefixIcon: "assets/icons/search.svg",
              hintStyle: TextStyles.f12w400Gray5,
              textStyle: const TextStyle(fontSize: 14),
              borderRadius: 12,
              onChanged: staffNotifier.updateSearch,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.mGray3),
            ),
            child: const Icon(Icons.filter_list),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                staffNotifier.updateDateRange(picked.start, picked.end);
              }
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.mGray3),
              ),
    child: Padding(
    padding: const EdgeInsets.all(8),
    child: SvgPicture.asset(
    "assets/icons/calender_icon.svg",
    colorFilter: const ColorFilter.mode(
    AppColors.mBlack9,
    BlendMode.srcIn,
    ),
    ),
    ),
              ),
            ),

        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Flexible(
            child: Row(
              children: [
                Text("Staff", style: TextStyles.f16w600mGray9),
                const SizedBox(width: 6),
                // 🔹 COUNT BADGE
                AnimatedBuilder(
                  animation: staffNotifier,
                  builder: (context, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.tab,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        staffNotifier.filteredStaff.length.toString(),
                        style: TextStyles.f10w500primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SvgPicture.asset(
            "assets/icons/pdf.svg",
            width: 20,
            height: 20,
            color: AppColors.primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            height: 34,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                elevation: 0,
              ),
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  newStaffScreenRoute,
                );

                if (result == true) {
                  await staffNotifier.fetchUsers(); // 🔄 Auto-refresh list
                }
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: Text("New Staff", style: TextStyles.f12w400mWhite),
            ),
          ),
        ),
      ],
    );
  }
}