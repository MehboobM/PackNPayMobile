import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/models/setting_modal.dart';
import 'package:pack_n_pay/repositry/setting_repository.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../utils/toast_message.dart';

class WatermarkSettingsScreen extends StatefulWidget {
  final SettingsModel settings;

  const WatermarkSettingsScreen({
    super.key,
    required this.settings,
  });

  @override
  State<WatermarkSettingsScreen> createState() =>
      _WatermarkSettingsScreenState();
}

class _WatermarkSettingsScreenState
    extends State<WatermarkSettingsScreen> {
  late SettingsModel _settings;
  final SettingsRepository _repository = SettingsRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  /// 🔹 Refresh Settings from API
  Future<void> _refreshSettings() async {
    try {
      final updatedSettings =
      await _repository.getSettings();
      if (mounted) {
        setState(() {
          _settings = updatedSettings;
        });
      }
    } catch (e) {
      ToastHelper.showError(message: e.toString());
    }
  }

  /// 🔹 Update Watermark API
  Future<void> _updateWatermark() async {
    setState(() => _isLoading = true);

    try {
      await _repository.updateWatermarkSettings(
        _settings.toWatermarkJson(),
      );

      ToastHelper.showSuccess(
        message: "Watermark settings updated successfully",
      );

      if (mounted) {
        Navigator.pop(context, true); // Return success
      }
    } catch (e) {
      ToastHelper.showError(
        message: e.toString(),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 🔹 Update Checkbox Value
  void _updateField(String key, bool value) {
    final int newValue = value ? 1 : 0;

    setState(() {
      switch (key) {
        case "wm_quotation":
          _settings =
              _settings.copyWith(wmQuotation: newValue);
          break;
        case "wm_survey_list":
          _settings =
              _settings.copyWith(wmSurveyList: newValue);
          break;
        case "wm_lr_bilty":
          _settings =
              _settings.copyWith(wmLrBilty: newValue);
          break;
        case "wm_money_receipt":
          _settings =
              _settings.copyWith(wmMoneyReceipt: newValue);
          break;
        case "wm_letterhead":
          _settings =
              _settings.copyWith(wmLetterhead: newValue);
          break;
      }
    });

    _updateWatermark();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      WatermarkItem(
        keyName: "wm_quotation",
        title: "Quotation",
        subtitle: "Manage watermark display in quotes",
        iconPath: "assets/icons/generic.svg",
        value: _settings.wmQuotation,
      ),
      WatermarkItem(
        keyName: "wm_survey_list",
        title: "Survey List",
        subtitle: "Manage watermark display in survey list",
        iconPath: "assets/icons/Survey.svg",
        value: _settings.wmSurveyList,
      ),
      WatermarkItem(
        keyName: "wm_lr_bilty",
        title: "LR Bilty",
        subtitle: "Manage watermark display in LR",
        iconPath: "assets/icons/Bilty.svg",
        value: _settings.wmLrBilty,
      ),
      WatermarkItem(
        keyName: "wm_money_receipt",
        title: "Money Receipt",
        subtitle: "Manage watermark display in receipt",
        iconPath: "assets/icons/Receipt.svg",
        value: _settings.wmMoneyReceipt,
      ),
      WatermarkItem(
        keyName: "wm_letterhead",
        title: "Letterhead",
        subtitle: "Manage watermark display in letterhead",
        iconPath: "assets/icons/Letterhead.svg",
        value: _settings.wmLetterhead,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.mWhite,
      appBar: AppBar(
        title: Text(
          "Watermarks",
          style: TextStyles.f16w600Black8,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshSettings,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return WatermarkTile(
                  item: item,
                  onChanged: (value) =>
                      _updateField(item.keyName, value),
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black12,
              child:
              const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class WatermarkItem {
  final String keyName;
  final String title;
  final String subtitle;
  final String iconPath;
  final int value;

  WatermarkItem({
    required this.keyName,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.value,
  });
}

class WatermarkTile extends StatelessWidget {
  final WatermarkItem item;
  final ValueChanged<bool> onChanged;

  const WatermarkTile({
    super.key,
    required this.item,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = item.value == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? AppColors.primary
              : Colors.grey.shade300,
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            item.iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isEnabled
                  ? AppColors.primary
                  : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: TextStyles.f14w500Gray9),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style:
                  TextStyles.f12w400Gray9.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: isEnabled,
            activeColor: AppColors.primary,
            onChanged: (value) =>
                onChanged(value ?? false),
          ),
        ],
      ),
    );
  }
}