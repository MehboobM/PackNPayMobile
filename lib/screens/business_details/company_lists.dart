import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../api_services/network_handler.dart';
import 'my_business_page.dart';

class CompanyListsPage extends StatefulWidget {
  const CompanyListsPage({super.key});

  @override
  State<CompanyListsPage> createState() => _CompanyListsPageState();
}

class _CompanyListsPageState extends State<CompanyListsPage> {
  List<dynamic> _companyList = [];
  bool _isLoading = true;

  final NetworkHandler _networkHandler = NetworkHandler();

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  // ✅ FETCH COMPANIES
  Future<void> _fetchCompanyData() async {
    setState(() => _isLoading = true);

    try {
      final response = await _networkHandler.get(
        'company-config-list',
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {

        setState(() {
          _companyList = response.data['data'] ?? [];
          _isLoading = false;
        });

      } else {
        _handleError("Failed to load companies");
      }

    } catch (e) {
      _handleError("Something went wrong");
      debugPrint("Error fetching companies: $e");
    }
  }

  // ✅ SET DEFAULT COMPANY
  Future<void> _setDefaultCompany(String uid) async {
    try {
      final response = await _networkHandler.patch(
        'company-config/set-default/$uid',
        {},
      );

      if (response.statusCode == 200) {
        _showSuccess("Company set as default successfully");
        _fetchCompanyData();
      }

    } catch (e) {
      debugPrint("Error setting default: $e");
      _handleError("Error updating default company");
    }
  }

  // ✅ COMMON ERROR HANDLER
  void _handleError(String message) {
    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          "Business Details",
          style: TextStyle(
            color: Color(0xFF1A1C1E),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10, bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyBusinessPage()),
                ).then((_) => _fetchCompanyData());
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              label: const Text(
                "Add New Business",
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E4094),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _fetchCompanyData,
          child: _companyList.isEmpty
              ? const Center(child: Text("No companies found"))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            itemCount: _companyList.length,
            itemBuilder: (context, index) {
              final company = _companyList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildCompanyCard(
                  context,
                  uid: company['uid'] ?? "",
                  isDefault: company['is_default'] ?? false,
                  companyName: company['display_name'] ?? company['name'] ?? "No Name",
                  phone: company['phone'] ?? "N/A",
                  email: company['email'] ?? "N/A",
                  location: (company['location'] == null || company['location'] == "")
                      ? "No Location"
                      : company['location'],
                  logoUrl: company['logo']?.replaceAll('localhost', '192.168.0.247') ?? "",
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(
      BuildContext context, {
        required String uid,
        required bool isDefault,
        required String companyName,
        required String phone,
        required String email,
        required String location,
        required String logoUrl,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF2A7A7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                logoUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.business, color: Colors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        companyName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1C1E)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isDefault)
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCE4F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "DEFAULT",
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF2E4094)),
                        ),
                      ),
                    _buildPopupMenu(context, uid),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIconLabel(Icons.phone_android_outlined, phone),
                    const SizedBox(height: 6),
                    _buildIconLabel(Icons.mail_outline, email),
                    const SizedBox(height: 6),
                    _buildIconLabel(Icons.location_on_outlined, location),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, String uid) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 160),
      icon: const Icon(Icons.more_vert, color: Color(0xFF1A1C1E), size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      offset: const Offset(0, 30),
      onSelected: (value) {
        if (value == 1) {
          // EDIT logic: Pass the UID to the MyBusinessPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyBusinessPage(uid: uid)),
          ).then((_) => _fetchCompanyData());
        } else if (value == 2) {
          _setDefaultCompany(uid);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, color: Color(0xFFFF7A00), size: 20),
              const SizedBox(width: 10),
              Text("Edit Details", style: _menuStyle()),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Color(0xFFFF7A00), size: 20),
              const SizedBox(width: 10),
              Text("Mark as Default", style: _menuStyle()),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _menuStyle() => const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1A1C1E));

  Widget _buildIconLabel(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 12, color: const Color(0xFF2E4094)),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF4B5563)),
          ),
        ),
      ],
    );
  }
}