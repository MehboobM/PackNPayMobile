import 'package:flutter/material.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../global_data/dropdown_data.dart';
import '../../global_widget/build_common_dropdown.dart';
import '../../models/compalint_history.dart';
import '../../repositry/support_repository.dart';
import '../../utils/toast_message.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final SupportRepository _repository = SupportRepository();
  late Future<List<SupportTicketModel>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _repository.getMySupportTickets();
  }

  /// 🔄 Refresh Tickets
  void _refreshTickets() {
    setState(() {
      _ticketsFuture = _repository.getMySupportTickets();
    });
  }

  /// 🎨 Get Status Color
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "OPEN":
        return Colors.orange;
      case "IN_PROGRESS":
        return Colors.blue;
      case "RESOLVED":
        return Colors.green;
      case "REJECTED":
        return Colors.red;
      case "CLOSED":
        return Colors.grey;
      default:
        return Colors.black54;
    }
  }

  /// 📅 Format Date
  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.day.toString().padLeft(2, '0')} "
          "${_monthName(parsedDate.month)} "
          "${parsedDate.year}";
    } catch (e) {
      return date;
    }
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),

      /// 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        surfaceTintColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Help & Support",
          style: TextStyles.f16w600Black8,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await showRaiseComplaintBottomSheet(context);
                  _refreshTickets(); // Refresh after submission
                },
                icon: const Icon(
                  Icons.report_problem_outlined,
                  size: 14,
                  color: Colors.white,
                ),
                label: Text(
                  "Raise Complaint",
                  style: TextStyles.f12w400mWhite,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      /// 🔹 BODY
      body: RefreshIndicator(
        onRefresh: () async => _refreshTickets(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📞 CONTACT INFORMATION CARD
              _buildContactCard(),

              const SizedBox(height: 20),

              /// 📜 HISTORY HEADER
              Text(
                "Complaint History",
                style: TextStyles.f14w600mGray9,
              ),

              const SizedBox(height: 10),

              /// 📡 API DATA
              FutureBuilder<List<SupportTicketModel>>(
                future: _ticketsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Failed to load complaints"),
                    );
                  }

                  final tickets = snapshot.data ?? [];

                  if (tickets.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No complaints found"),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];

                      return _buildHistoryItem(
                        requestNo: ticket.uid,
                        issueType: ticket.issueType,
                        message: ticket.message,
                        status: ticket.status,
                        date: _formatDate(ticket.createdAt),
                        statusColor: _getStatusColor(ticket.status),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 CONTACT CARD
  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2A3582),
            Color(0xFF4E5ACD),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Contact Information",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Connect with our support specialists anytime",
            style: TextStyles.f12w400mWhite.copyWith(
              color: AppColors.mWhite.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 18),
          _contactRow(Icons.phone, "Call us", "+91 0000000000"),
          const SizedBox(height: 14),
          _contactRow(Icons.email, "Mail us", "support@email.com"),
          const SizedBox(height: 14),
          _contactRow(
            Icons.location_on,
            "Office",
            "105 Jerry Dove Drive, Florence, SC 29501",
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// 🔹 CONTACT ROW
  Widget _contactRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.f10w500mWhite.copyWith(
                  color: AppColors.mWhite.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyles.f12w400mWhite,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 HISTORY ITEM
  Widget _buildHistoryItem({
    required String requestNo,
    required String issueType,
    required String message,
    required String status,
    required String date,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Request No & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Req No: $requestNo",
                style: TextStyles.f12w600primary,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// Date
          Text(
            "Date: $date",
            style:
            TextStyles.f12w400Gray9.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),

          /// Issue Type
          Text(
            "Issue Type",
            style: TextStyles.f12w600primary,
          ),
          const SizedBox(height: 2),
          Text(
            issueType,
            style: TextStyles.f12w400Gray9,
          ),
          const SizedBox(height: 8),

          /// Message
          Text(
            "Message",
            style: TextStyles.f12w600primary,
          ),
          const SizedBox(height: 2),
          Text(
            message,
            style: TextStyles.f12w400Gray9,
          ),
        ],
      ),
    );
  }

  Future<void> showRaiseComplaintBottomSheet(BuildContext context) async {
    final TextEditingController messageController = TextEditingController();
    String? selectedIssueType;

    // Fetch issue types from globalJson
    final List<Map<String, dynamic>> issueTypeOptions =
    List<Map<String, dynamic>>.from(
      (globalJson['issue_type'] as Map<String, dynamic>)['options'],
    );

    final List<String> issueTypeLabels =
    issueTypeOptions.map((e) => e['label'].toString()).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Handle Bar
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      /// 🔹 Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Raise Complaint",
                            style: TextStyles.f14w500Gray9,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 Issue Type Dropdown (Fixed Height)
                      SizedBox(
                        height: 78,
                        child: Row(
                          children: [
                            buildCommonDropdown(
                              title: "Issue Type",
                              value: selectedIssueType,
                              items: issueTypeLabels,
                              isRequired: true,
                              onChanged: (value) {
                                setState(() {
                                  selectedIssueType = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 Message Label
                      Text(
                        "Message",
                        style: TextStyles.f14w500Gray9,
                      ),
                      const SizedBox(height: 6),

                      /// 🔹 Message Text Field
                      SizedBox(
                        height: 110,
                        child: TextField(
                          controller: messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Write the message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyles.f12w600primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final message = messageController.text.trim();

                                if (selectedIssueType == null || message.isEmpty) {
                                  ToastHelper.showError(
                                    message: "Please fill all fields",
                                  );
                                  return;
                                }

                                try {
                                  // Convert selected label to API value
                                  final selectedOption = issueTypeOptions.firstWhere(
                                        (option) => option['label'] == selectedIssueType,
                                  );

                                  final String issueTypeValue =
                                  selectedOption['value'].toString();

                                  final repository = SupportRepository();

                                  final success = await repository.createSupportTicket(
                                    issueType: issueTypeValue,
                                    message: message,
                                  );

                                  if (success) {
                                    Navigator.pop(context);
                                    ToastHelper.showSuccess(
                                      message: "Complaint submitted successfully",
                                    );
                                  }
                                } catch (e) {
                                  ToastHelper.showError(
                                    message: e.toString().replaceAll("Exception: ", ""),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(
                                "Submit",
                                style: TextStyles.f12w500White,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}