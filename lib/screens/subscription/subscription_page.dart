import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Active Plan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildActivePlanCard(),
            const SizedBox(height: 24),
            const Text(
              "Plan History",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildHistoryItem(
                "ACTIVE", const Color(0xFFE3F2FD), const Color(0xFF2196F3)),
            const SizedBox(height: 12),
            _buildHistoryItem(
                "EXPIRED", const Color(0xFFFFEBEE), const Color(0xFFEF5350)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 170, // Slightly taller to match image proportions
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
        ),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/backg_img.png',
                fit: BoxFit.cover,
              ),
            ),
            // Content overlay
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("45",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1)),
                          Text("Days left to renew",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),

                      // PIXEL PERFECT RENEW BUTTON
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF223081), // Dark core
                            borderRadius: BorderRadius.circular(100),
                            // The outer thin dark border
                            border: Border.all(
                              color: const Color(0xFF1A2562),
                              width: 1.5,
                            ),
                            // The soft light-blue glow
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4E61D4).withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Text(
                            "Renew plan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPlanDetail("PLAN", "Professional"),
                      _buildPlanDetail("PURCHASED ON", "Feb 15, 2026"),
                      _buildPlanDetail("VALID TILL", "Mar 15, 2026"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Helper methods for the rest of the UI (Search, Buttons, History)
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Text("Search", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildSmallIconBtn(Icons.filter_list),
        const SizedBox(width: 8),
        _buildSmallIconBtn(Icons.calendar_today_outlined),
      ],
    );
  }
  Widget _buildSmallIconBtn(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Icon(icon, size: 20, color: Colors.black87),
    );
  }
  Widget _buildHistoryItem(String status, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("#01", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                children: [
                  const Icon(Icons.visibility_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 12),
                  const Icon(Icons.file_download_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
                    child: Text(status, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text("SILVER-30 DAYS", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E3B8E), fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHistoryDetail("Price", "₹2000"),
              _buildHistoryDetail("Purchased On", "JAN 9, 2026"),
              _buildHistoryDetail("Period", "JAN 9,26 - FEB 9,26"),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildHistoryDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
      ],
    );
  }
}