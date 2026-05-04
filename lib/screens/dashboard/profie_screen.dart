import 'package:flutter/material.dart';
import '../../repositry/Dashboard_repository.dart';
import '../../models/profile_modal.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DashboardService _service = DashboardService();

  ProfileModel? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _service.getProfile();

    setState(() {
      profile = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load profile")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2F3A8F),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profile!.profileImage != null
                        ? NetworkImage(profile!.profileImage!)
                        : const AssetImage("assets/images/profile.png")
                    as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile!.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    profile!.role,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// DETAILS CARD
            _buildTile("User ID", profile!.uid),
            _buildTile("Mobile", profile!.mobile),
            _buildTile("Email", profile!.email ?? "-"),
            _buildTile("City", profile!.city ?? "-"),
            _buildTile("State", profile!.state ?? "-"),
            _buildTile("Address", profile!.address ?? "-"),
            _buildTile("Status", profile!.status),
            _buildTile("Joined", profile!.createdAt),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 12, color: Colors.black54),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}