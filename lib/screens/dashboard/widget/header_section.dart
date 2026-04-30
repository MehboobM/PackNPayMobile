import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../../routes/route_names_const.dart';
import '../../../api_services/network_handler.dart';
import '../../../database/shared_preferences/shared_storage.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  final NetworkHandler _networkHandler = NetworkHandler();
  final StorageService _storage = StorageService();

  List companies = [];

  String selectedCompanyName = "Default Business";
  String selectedCompanyFullName = "Acme Corporation pvt.Ltd";
  String? selectedLogo;

  bool isLoading = false;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  /// ================= FETCH COMPANIES =================
  Future<void> _fetchCompanies() async {
    try {
      setState(() => isLoading = true);

      final response = await _networkHandler.get("get-user-companies");

      if (response.statusCode == 200 &&
          response.data["success"] == true) {
        companies = response.data["data"]["companies"] ?? [];

        _toggleDropdown(); // 👈 show popup
      }
    } catch (e) {
      print("Company API Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// ================= SWITCH COMPANY =================
  Future<void> _switchCompany(dynamic company) async {
    try {
      final response = await _networkHandler.post(
        "switch-company",
        {
          "company_id": company["id"],
        },
      );

      if (response.data["success"] == true) {
        /// ✅ Save token + company_id
        await _storage.saveToken(response.data["token"]);
        await _storage.saveCompanyId(
            company["id"].toString());

        setState(() {
          selectedCompanyName =
              company["label_name"] ?? "Business";
          selectedCompanyFullName =
              company["company_name"] ?? "";
          selectedLogo = company["logo"];
        });

        _removeDropdown();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Company Switched")),
        );
      }
    } catch (e) {
      print("Switch Company Error: $e");
    }
  }

  /// ================= DROPDOWN =================
  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _removeDropdown();
    }
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          /// 👇 OUTSIDE TAP DETECTOR
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeDropdown,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox(),
            ),
          ),

          /// 👇 DROPDOWN
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 38), // 🔥 closer to widget
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white, // ✅ keep white container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 200, // ✅ scroll only if needed
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero, // ✅ remove top gap
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        final company = companies[index];

                        return InkWell(
                          onTap: () => _switchCompany(company),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                company["logo"] != null
                                    ? CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                  NetworkImage(company["logo"]),
                                )
                                    : const CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.business, size: 14),
                                ),
                                const SizedBox(width: 8),
                                const SizedBox(height: 2),
                                Expanded(
                                  child: Text(
                                    company["company_name"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
          ),
          ),
        ],
      ),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          /// LOGO
          selectedLogo != null
              ? CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(selectedLogo!),
          )
              : Image.asset(
            "assets/images/logo.png",
            width: 40,
            height: 40,
          ),

          const SizedBox(width: 6),

          /// DROPDOWN
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: isLoading ? null : _fetchCompanies,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        selectedCompanyName,
                        style: TextStyles.f11w400Gray6,
                      ),
                      const SizedBox(width: 6),

                      isLoading
                          ? const SizedBox(
                        height: 12,
                        width: 12,
                        child: CircularProgressIndicator(
                            strokeWidth: 2),
                      )
                          : SvgPicture.asset(
                        "assets/images/arrow_down.svg",
                        height: 6,
                        width: 6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedCompanyFullName,
                    style: TextStyles.f12w600Gray9,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          /// LANGUAGE
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, languageRoute);
            },
            child: SvgPicture.asset(
              "assets/images/language.svg",
              width: 24,
              height: 24,
              color: AppColors.mBlack9,
            ),
          ),

          const SizedBox(width: 12),

          /// NOTIFICATION
          const Icon(Icons.notifications_none, size: 22),

          const SizedBox(width: 12),

          /// PROFILE
          const CircleAvatar(
            radius: 18,
            backgroundImage:
            AssetImage("assets/images/profile.png"),
          ),
        ],
      ),
    );
  }
}