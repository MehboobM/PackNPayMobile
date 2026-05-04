import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import '../../models/setting_modal.dart';
import '../../repositry/setting_repository.dart';
import '../../utils/m_font_styles.dart';

class LetterHeadScreen extends StatefulWidget {
  final SettingsModel settings;

  const LetterHeadScreen({
    super.key,
    required this.settings,
  });

  @override
  State<LetterHeadScreen> createState() =>
      _LetterHeadScreenState();
}

class _LetterHeadScreenState extends State<LetterHeadScreen> {
  late String appliedTheme;
  String? selectedTheme;
  bool isLoading = false;

  final SettingsRepository _repository = SettingsRepository();

  final List<Map<String, String>> themes = [
    {
      "title": "Blue Classic",
      "value": "LH_BLUE_1",
      "image": "assets/images/portraid.png",
    },
    {
      "title": "Modern Blue",
      "value": "LH_BLUE_2",
      "image": "assets/images/landscape.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    appliedTheme =
        widget.settings.lhTheme ?? "LH_BLUE_1";
  }

  Future<void> _applyTheme(String themeValue) async {
    if (themeValue == appliedTheme) return;

    setState(() => isLoading = true);

    try {
      final body = widget.settings.toLetterHeadJson(
        theme: themeValue,
      );

      final success =
      await _repository.updateLetterHeadSettings(body);

      if (success && mounted) {
        setState(() {
          appliedTheme = themeValue;
          selectedTheme = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Letter Head applied successfully"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _buildThemeCard(Map<String, String> theme) {
    final value = theme["value"]!;
    final image = theme["image"]!;
    final title = theme["title"]!;

    final bool isApplied = value == appliedTheme;
    final bool isSelected = value == selectedTheme;

    return GestureDetector(
      onTap: () {
        setState(() => selectedTheme = value);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.grey
                : isApplied
                ? AppColors.primary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              if (isSelected)
                Container(
                  height: 200,
                  color: Colors.black.withOpacity(0.45),
                ),

              if (isApplied && !isSelected)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "APPLIED",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              if (isSelected && !isApplied)
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _applyTheme(value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "APPLY",
                    style: TextStyles.f12w700primary,
                  ),
                ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyles.f12w500White,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:
        Text("Letter Head", style: TextStyles.f16w600Black8),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: themes.length,
            itemBuilder: (context, index) {
              return _buildThemeCard(themes[index]);
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

