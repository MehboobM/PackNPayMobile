import 'package:flutter/material.dart';
import 'package:pack_n_pay/screens/setting_helpsupport/watermark_screen.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';
import '../../models/setting_modal.dart';
import '../../repositry/setting_repository.dart';
import '../../routes/route_names_const.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<SettingsModel> settingsFuture;

  @override
  void initState() {
    super.initState();
    settingsFuture = SettingsRepository().getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Settings", style: TextStyles.f16w600Black8),
      ),
      body: FutureBuilder<SettingsModel>(
        future: settingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load settings"));
          } else if (!snapshot.hasData) {
            return const SizedBox();
          }

          final settings = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                SettingsItem(
                  title: "Watermark",
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      watermarkSettingsRoute,
                      arguments: settings,
                    );

                    // Refresh API when returning
                    if (result == true) {
                      setState(() {
                        settingsFuture = SettingsRepository().getSettings();
                      });
                    }
                  },
                ),
                SettingsItem(
                  title: "Letter Head",
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      letterHeadSettingsRoute,
                      arguments: settings,
                    );

                    // Refresh API when returning
                    if (result == true) {
                      setState(() {
                        settingsFuture = SettingsRepository().getSettings();
                      });
                    }
                  },
                ),
                SettingsItem(
                  title: "Quotation",
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      quotationSettingsRoute,
                      arguments: settings,
                    );

                    if (result == true) {
                      setState(() {
                        settingsFuture =
                            SettingsRepository().getSettings();
                      });
                    }
                  },
                ),
                SettingsItem(
                  title: "LR Bilty",
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      lrBiltySettingsRoute,
                      arguments: settings,
                    );

                    if (result == true) {
                      setState(() {
                        settingsFuture =
                            SettingsRepository().getSettings();
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title, style: TextStyles.f14w600Gray9),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}