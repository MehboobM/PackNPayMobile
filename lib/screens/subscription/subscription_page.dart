import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../all_state/dashboard_state.dart';
import '../../notifier/dashboard_notifier.dart';
import '../../api_services/api_end_points.dart';
import '../../api_services/network_handler.dart';
import '../../routes/route_names_const.dart';
import '../dashboard/widget/subscription_card.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() =>
      _SubscriptionPageState();
}

class _SubscriptionPageState
    extends ConsumerState<SubscriptionPage> {
  final NetworkHandler _networkHandler = NetworkHandler();
  String formatFullDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("MMM d, yyyy").format(parsed); // Jan 9, 2026
    } catch (e) {
      return date;
    }
  }

  String formatShortDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("MMM d, yy").format(parsed); // Jan 9, 26
    } catch (e) {
      return date;
    }
  }

  String formatAmount(dynamic amount) {
    if (amount == null) return "₹0";
    return "₹${amount.toString()}";
  }

  List<dynamic> historyList = [];
  bool isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final response = await _networkHandler.get(
        ApiEndPoints.subscriptionHistory,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        setState(() {
          historyList = response.data['data'] ?? [];
          isLoadingHistory = false;
        });
      } else {
        setState(() => isLoadingHistory = false);
      }
    } catch (e) {
      setState(() => isLoadingHistory = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final dashboard = state.dashboard;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,

        /// 🔙 BACK
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Subscription',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: state.isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text(state.error!))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= ACTIVE PLAN =================
            const Text(
              "Active Plan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            /// ✅ REUSED CARD
            if (dashboard != null)
              const SubscriptionCard(
                navigateTo: PlansRoute, // 👈 ADD THIS
              ),

            const SizedBox(height: 24),

            /// ================= HISTORY =================
            const Text(
              "Plan History",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            /*_buildSearchBar(),
            const SizedBox(height: 16),*/

            /// 🔥 API DATA
            if (isLoadingHistory)
              const Center(
                  child: CircularProgressIndicator())
            else if (historyList.isEmpty)
              const Center(child: Text("No History Found"))
            else
              Column(
                children: historyList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final status = item['status'] ?? "";

                  final isActive =
                      status.toUpperCase() == "ACTIVE";

                  return Padding(
                    padding:
                    const EdgeInsets.only(bottom: 12),
                    child: _buildHistoryItem(
                      index,
                      status,
                      isActive
                          ? const Color(0xFFE3F2FD)
                          : const Color(0xFFFFEBEE),
                      isActive
                          ? const Color(0xFF2196F3)
                          : const Color(0xFFEF5350),

                      /// 🔥 PASS API DATA
                      planName: item['plan_name'] ?? '',
                      startDate: item['start_date'] ?? '',
                      endDate: item['end_date'] ?? '',
                      amount: formatAmount(item['amount']),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  /// ================= SEARCH =================
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
            child: const Row(
              children: [
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

  /// ================= HISTORY ITEM =================
  Widget _buildHistoryItem(
      int index,
      String status,
      Color bgColor,
      Color textColor, {
        required String planName,
        required String amount,
        required String startDate,
        required String endDate,
      }) {
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
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "#${(index + 1).toString().padLeft(2, '0')}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  /*const Icon(Icons.visibility_outlined,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 12),
                  const Icon(Icons.file_download_outlined,
                      size: 18, color: Colors.grey),*/
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius:
                      BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            planName.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3B8E),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _HistoryDetail("Price", amount),
      _HistoryDetail("Purchased On", formatFullDate(startDate)),
      _HistoryDetail(
        "Period",
        "${formatShortDate(startDate)} - ${formatShortDate(endDate)}",
      ),

            ],
          ),
        ],
      ),
    );
  }
}

/// 🔹 CLEAN SMALL WIDGET
class _HistoryDetail extends StatelessWidget {
  final String label;
  final String value;

  const _HistoryDetail(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11)),
      ],
    );
  }


}