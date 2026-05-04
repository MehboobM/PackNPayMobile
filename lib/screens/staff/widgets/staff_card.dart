import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../database/hive_database/hive_permission.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class StaffCardWidget extends StatelessWidget {
  final String name;
  final String staffId;
  final String loginCode;
  final String email;
  final String phone;
  final String joiningDate;
  final bool isActive;
  final Function(bool)? onToggle;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final int surveyCount;
  final int quotationCount;
  final int orderCount;
  final int lrCount;

  const StaffCardWidget({
    super.key,
    required this.name,
    required this.staffId,
    required this.loginCode,
    required this.email,
    required this.phone,
    required this.joiningDate,
    this.isActive = true,
    this.onToggle,
    this.onView,
    this.onEdit,
    this.surveyCount = 0,
    this.quotationCount = 0,
    this.orderCount = 0,
    this.lrCount = 0,
  });

  /// 🔹 Stats Item
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

  /// 🔹 Info Row with Material Icon
  Widget _buildMaterialInfoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.tab.withOpacity(0.4),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyles.f12w600Gray9,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Info Row with SVG Icon
  Widget _buildSvgInfoRow(String asset, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.tab.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(4), // ensure SVG fits nicely
              child: SvgPicture.asset(
                asset,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyles.f12w600Gray9,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Action Buttons with SVG Icons
  Widget _buildActionButtons() {
    final canEditStaff = PermissionHelper.canEdit(ModuleCode.staff);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 👁 View
          GestureDetector(
            onTap: onView,
            child: SvgPicture.asset(
              "assets/icons/view_icon.svg",
              width: 20,
              height: 20,
              color: AppColors.primarySecond,
            ),
          ),
          const SizedBox(width: 14),

          // 📜 History
          SvgPicture.asset(
            "assets/icons/history_icon.svg",
            width: 20,
            height: 20,
            color: AppColors.primarySecond,
          ),
          const SizedBox(width: 14),

          // ✏️ Edit
        if(canEditStaff)
          GestureDetector(
            onTap: onEdit, // ✅ Trigger edit action
            child: SvgPicture.asset(
              "assets/icons/note_edit_icon.svg",
              width: 20,
              height: 20,
              color: AppColors.primarySecond,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Compact Active Switch
  Widget _buildActiveSwitch() {
    final isOn = isActive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.75,
          child: Switch(
            value: isOn,
            onChanged: onToggle,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryGreen,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.red.shade300,
          ),
        ),

        Text(
          isOn ? "Active" : "Inactive",
          style: TextStyles.f12w600Gray9.copyWith(
            color: isOn ? AppColors.activeGreen : Colors.red,
          ),
        ),
      ],
    );
  }

  /// 🔹 Info Chip Text
  Widget _buildInfoText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label: ",
        style: TextStyles.f12w400Gray5.copyWith(height: 1),
        children: [
          TextSpan(
            text: value,
            style: TextStyles.f12w500Gray7.copyWith(height: 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER: NAME & ACTIVE SWITCH
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyles.f14w600Primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildActiveSwitch(),
            ],
          ),


          /// 🔹 STAFF INFO ROW
          Row(
            children: [
              _buildInfoText("Staff ID", staffId),
              const SizedBox(width: 10),
              Text("|", style: TextStyles.f12w400Gray5),
              const SizedBox(width: 10),
              _buildInfoText("Login code", loginCode),
            ],
          ),

          const Divider(height: 12),

          /// 🔹 STATS
          Row(
            children: [
              buildStatItem("Survey", surveyCount.toString()),
              buildStatItem("Quotation", quotationCount.toString()),
              buildStatItem("LR/Bilty", lrCount.toString()),
              buildStatItem("Orders", orderCount.toString()),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 CONTACT DETAILS
          _buildMaterialInfoRow(Icons.email_outlined, email),
          _buildSvgInfoRow("assets/icons/phone.svg", phone),

          /// 🔹 DATE + ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: _buildMaterialInfoRow(
                  Icons.email_outlined,
                  joiningDate,
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ],
      ),
    );
  }
}