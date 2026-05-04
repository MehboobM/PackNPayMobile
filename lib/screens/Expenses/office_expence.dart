import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../api_services/api_end_points.dart';
import '../../database/shared_preferences/shared_storage.dart';
import 'new_expenses_sheet.dart';

class OfficeExpensePage extends StatefulWidget {
  const OfficeExpensePage({super.key});

  @override
  State<OfficeExpensePage> createState() => _OfficeExpensePageState();
}

class _OfficeExpensePageState extends State<OfficeExpensePage> {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  List<dynamic> _allExpenses = []; // Master list from API
  List<dynamic> _filteredExpenses = []; // List displayed on UI
  bool _isLoading = true;
  String _totalAmount = "0";

  // Search Controller
  final TextEditingController _searchController = TextEditingController();

  // Filters
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Search Logic
  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredExpenses = _allExpenses;
      } else {
        _filteredExpenses = _allExpenses.where((item) {
          final name = (item['name'] ?? "").toString().toLowerCase();
          final category = (item['category_name'] ?? "").toString().toLowerCase();
          final id = (item['id'] ?? "").toString().toLowerCase();
          final searchQuery = query.toLowerCase();

          return name.contains(searchQuery) ||
              category.contains(searchQuery) ||
              id.contains(searchQuery);
        }).toList();
      }
    });
  }

  Future<void> _fetchExpenses() async {
    setState(() => _isLoading = true);
    try {
      String? token = await _storage.getToken();
      String url = '${ApiEndPoints.baseurl}office-expense-list';

      Map<String, dynamic> queryParams = {};
      if (_selectedDateRange != null) {
        queryParams['from_date'] = DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start);
        queryParams['to_date'] = DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end);
      }

      final response = await _dio.get(
        url,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        setState(() {
          _allExpenses = response.data['data'];
          _filteredExpenses = _allExpenses; // Initialize filtered list
          _totalAmount = "${response.data['total'] ?? 0}";
          _isLoading = false;
        });
        // Maintain search filter if text exists
        if (_searchController.text.isNotEmpty) {
          _onSearchChanged(_searchController.text);
        }
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteExpense(String uid) async {
    try {
      String? token = await _storage.getToken();
      await _dio.delete(
        '${ApiEndPoints.baseurl}office-expense/$uid',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      _fetchExpenses(); // Refresh list
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text('Office Expenses',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          _buildTotalBadge('₹$_totalAmount'),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildTableHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _fetchExpenses,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                itemCount: _filteredExpenses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = _filteredExpenses[index];
                  return _buildExpenseTile(
                    uid: item['uid'],
                    id: "#${item['id']}",
                    date: item['expense_date'],
                    title: item['name'],
                    category: item['category_name'],
                    amount: "₹${item['amount']}",
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(context),
    );
  }

  Widget _buildTotalBadge(String amount) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFDDE7FF), borderRadius: BorderRadius.circular(20)),
        child: RichText(
          text: TextSpan(children: [
            const TextSpan(text: 'Total Expenses: ', style: TextStyle(color: Color(0xFF3F51B5), fontSize: 10)),
            TextSpan(text: amount, style: const TextStyle(color: Color(0xFF3F51B5), fontSize: 10, fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildIconBtn(Icons.filter_list, () {
            // Reset filters
            setState(() {
              _searchController.clear();
              _onSearchChanged("");
            });
          }),
          const SizedBox(width: 8),
          _buildIconBtn(Icons.calendar_today_outlined, () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(() => _selectedDateRange = picked);
              _fetchExpenses();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Icon(icon, color: Colors.black87, size: 18),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF2E3B8E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text("DETAILS", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          Expanded(flex: 5, child: Text("NAME & CATEGORY", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          Text("ACTION", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildExpenseTile(
      {required String uid,
        required String id,
        required String date,
        required String title,
        required String category,
        required String amount}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(id, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ]),
          ),
          Expanded(
            flex: 5,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(category, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFDDE7FF), borderRadius: BorderRadius.circular(4)),
                child: Text(amount,
                    style:
                    const TextStyle(color: Color(0xFF2E3B8E), fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              const SizedBox(height: 8),
              Row(children: [

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => NewExpensesSheet(uid: uid),
                      ).then((_) => _fetchExpenses());
                    } else if (value == 'delete') {
                      _deleteExpense(uid);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text("Edit")),
                    const PopupMenuItem(value: 'delete',
                        child: Text("Delete", style: TextStyle(color: Colors.red))),
                  ],
                  child: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                ),
              ]),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF8F9FA),
      child: ElevatedButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const NewExpensesSheet(),
        ).then((_) => _fetchExpenses()),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E3B8E),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text("Add Expense",
                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}