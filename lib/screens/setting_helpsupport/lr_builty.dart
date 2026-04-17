import 'package:flutter/material.dart';
import 'package:pack_n_pay/screens/setting_helpsupport/widget/terms&condition_card.dart';
import 'package:pack_n_pay/screens/setting_helpsupport/widget/theme_selection.dart';
import '../../models/setting_modal.dart';
import '../../repositry/setting_repository.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';

class LRBiltySettingsScreen extends StatefulWidget {
  final SettingsModel settings;

  const LRBiltySettingsScreen({
    super.key,
    required this.settings,
  });

  @override
  State<LRBiltySettingsScreen> createState() =>
      _LRBiltySettingsScreenState();
}

class _LRBiltySettingsScreenState
    extends State<LRBiltySettingsScreen> {
  final SettingsRepository _repository = SettingsRepository();

  late String appliedTheme;
  String? selectedTheme;
  late String terms;
  bool isLoading = false;

  final List<Map<String, String>> themes = [
    {
      "title": "Portrait Design",
      "value": "PORTRAIT",
      "image": "assets/images/portraid.png",
    },
    {
      "title": "Landscape Design",
      "value": "LANDSCAPE",
      "image": "assets/images/landscape.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    appliedTheme = widget.settings.lrLandscapePdf == 1
        ? "LANDSCAPE"
        : "PORTRAIT";

    terms = widget.settings.lrTermsAndConditions ?? "";
  }

  Future<void> _saveSettings() async {
    final Map<String, dynamic> body = {};

    final String finalTheme = selectedTheme ?? appliedTheme;

    // Convert theme to API value
    final int landscapeValue =
    finalTheme == "LANDSCAPE" ? 1 : 0;

    if (landscapeValue != widget.settings.lrLandscapePdf) {
      body["lr_landscape_pdf"] = landscapeValue;
    }

    if (terms.trim() !=
        (widget.settings.lrTermsAndConditions ?? "").trim()) {
      body["lr_terms_and_conditions"] = terms.trim();
    }

    if (body.isEmpty) {
      ToastHelper.showInfo(
        message: "No changes to update",
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final success =
      await SettingsRepository().updateLRSettings(body);

      if (success) {
        ToastHelper.showSuccess(
          message: "LR Bilty settings updated successfully.",
        );
        Navigator.pop(context, true);
      } else {
        ToastHelper.showError(
          message: "Failed to update LR Bilty settings.",
        );
      }
    } catch (e) {
      ToastHelper.showError(
        message: e.toString().replaceFirst("Exception: ", ""),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        title: Text("LR Bilty", style: TextStyles.f16w600Black8),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: isLoading ? null : _saveSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            "Save Changes",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Theme", style: TextStyles.f14w600Gray9),
          const SizedBox(height: 10),
          ...themes.map((theme) {
            final value = theme["value"]!;
            return ThemeSelectionCard(
              title: theme["title"]!,
              imagePath: theme["image"]!,
              isApplied: appliedTheme == value,
              isSelected: selectedTheme == value,
              onTap: () {
                setState(() => selectedTheme = value);
              },
              onApply: () {
                setState(() {
                  appliedTheme = value;
                  selectedTheme = null;
                });
              },
            );
          }),
          TermsConditionsCard(
            title: "Terms & Conditions",
            terms: terms,
            onSaved: (value) {
              setState(() => terms = value);
            },
          ),
        ],
      ),
    );
  }
}