import 'package:flutter/material.dart';
import 'package:pack_n_pay/screens/setting_helpsupport/widget/terms&condition_card.dart';
import 'package:pack_n_pay/screens/setting_helpsupport/widget/theme_selection.dart';
import '../../models/setting_modal.dart';
import '../../repositry/setting_repository.dart';
import '../../utils/app_colors.dart';
import '../../utils/m_font_styles.dart';
import '../../utils/toast_message.dart';

class QuotationSettingsScreen extends StatefulWidget {
  final SettingsModel settings;

  const QuotationSettingsScreen({
    super.key,
    required this.settings,
  });

  @override
  State<QuotationSettingsScreen> createState() =>
      _QuotationSettingsScreenState();
}

class _QuotationSettingsScreenState
    extends State<QuotationSettingsScreen> {


  late String appliedTheme;
  String? selectedTheme;
  late String terms;
  bool isLoading = false;

  final List<Map<String, String>> themes = [
    {
      "title": "Quotation Theme 1",
      "value": "PORTRAIT_ONE",
      "image": "assets/images/portraid.png",
    },
    {
      "title": "Quotation Theme 2",
      "value": "LANDSCAPE_ONE",
      "image": "assets/images/landscape.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    appliedTheme = widget.settings.qtTheme ?? "PORTRAIT_ONE";
    terms = widget.settings.qtTermsAndConditions ?? "";
  }

  Future<void> _saveSettings() async {
    final Map<String, dynamic> body = {};

    final String finalTheme = selectedTheme ?? appliedTheme;

    // Send only changed fields
    if (finalTheme != widget.settings.qtTheme) {
      body["qt_theme"] = finalTheme;
    }

    if (terms.trim() !=
        (widget.settings.qtTermsAndConditions ?? "").trim()) {
      body["qt_terms_and_conditions"] = terms.trim();
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
      await SettingsRepository().updateQuotationSettings(body);

      if (success) {
        ToastHelper.showSuccess(
          message: "Quotation settings updated successfully.",
        );
        Navigator.pop(context, true);
      } else {
        ToastHelper.showError(
          message: "Failed to update quotation settings.",
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
        title: Text("Quotation", style: TextStyles.f16w600Black8),
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