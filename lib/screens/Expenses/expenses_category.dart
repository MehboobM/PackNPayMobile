import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../api_services/api_end_points.dart';
import '../../database/hive_database/hive_permission.dart';
import '../../database/shared_preferences/shared_storage.dart';
import 'new_category_sheet.dart';
import 'office_expence.dart';

class ExpenseCategoriesPage extends StatefulWidget {
  const ExpenseCategoriesPage({super.key});

  @override
  State<ExpenseCategoriesPage> createState() => _ExpenseCategoriesPageState();
}

class _ExpenseCategoriesPageState extends State<ExpenseCategoriesPage> {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  List<dynamic> _categories = [];
  String _totalExpenses = "₹0";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      String? token = await _storage.getToken();
      final response = await _dio.get(
        '${ApiEndPoints.baseurl}expense-category-list',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Add debug print to see what the server is actually returning
      debugPrint("API Response: ${response.data}");

      if (response.data['success'] == true) {
        setState(() {
          _categories = response.data['data'] ?? [];
          // Ensure total is handled as a string or number safely
          _totalExpenses = "₹${response.data['total'] ?? 0}";
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      debugPrint("Dio Error: ${e.response?.statusCode} - ${e.message}");
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Fetch Error: $e");
      setState(() => _isLoading = false);
    }
  }
  Future<void> _toggleCategory(String uid, int index) async {
    try {
      String? token = await _storage.getToken();

      final response = await _dio.patch(
        '${ApiEndPoints.baseurl}expense-category/toggle/$uid',
        data: {},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['success'] == true) {
        setState(() {
          _categories[index]['is_enabled'] = response.data['data']['is_enabled'];
        });
      }
    } on DioException catch (e) {
      debugPrint("Toggle Dio Error: ${e.response?.statusCode} at URL: ${e.requestOptions.path}");
      debugPrint("Server Response: ${e.response?.data}"); // This helps see why the server crashed (500)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server Error (500): ${e.response?.data['message'] ?? 'Check server logs'}")),
      );
    } catch (e) {
      debugPrint("Toggle Error: $e");
    }
  }
  Future<void> _deleteCategory(String uid) async {
    try {
      String? token = await _storage.getToken();
      await _dio.delete(
        '${ApiEndPoints.baseurl}expense-category/$uid',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      _fetchCategories();
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    final canAddExpense = PermissionHelper.canAdd(ModuleCode.expense);
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
        title: const Text('Expense Categories',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          _buildTotalBadge(_totalExpenses),
          const SizedBox(width: 12),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              children: List.generate(_categories.length, (index) {
                final item = _categories[index];
                return _buildCategoryRow(
                  index,
                  "${index + 1}.",
                  item["name"],
                  "₹${item["amount"]}",
                  item["is_enabled"] == 1,
                  item["uid"],
                  isLast: index == _categories.length - 1,
                );
              }),
            ),
          ),
        ],
      ),
      bottomSheet: canAddExpense ? _buildAddButton(context) : null,
    );
  }

  Widget _buildCategoryRow(int index, String num, String name, String amount, bool isActive, String uid, {bool isLast = false}) {

    final canEditExpense = PermissionHelper.canEdit(ModuleCode.expense);
    final canDeleteExpense = PermissionHelper.canDelete(ModuleCode.expense);
    return InkWell(
      //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OfficeExpensePage())),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
        child: Row(
          children: [
            Text(num, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(width: 8),
            Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFDDE7FF), borderRadius: BorderRadius.circular(4)),
              child: Text(amount, style: const TextStyle(color: Color(0xFF2E3B8E), fontWeight: FontWeight.bold, fontSize: 11)),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _toggleCategory(uid, index),
              child: _buildToggle(isActive),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => NewCategorySheet(uid: uid),
                  ).then((_) => _fetchCategories());
                } else if (value == 'delete') {
                  _deleteCategory(uid);
                }
              },
              itemBuilder: (context) => [
                if(canEditExpense)
                const PopupMenuItem(value: 'edit', child: Text("Edit")),
                if(canDeleteExpense)
                const PopupMenuItem(value: 'delete', child: Text("Delete", style: TextStyle(color: Colors.red))),
              ],
              child: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Keep _buildTotalBadge, _buildToggle as they were)
  Widget _buildTotalBadge(String amount) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFFDDE7FF), borderRadius: BorderRadius.circular(20)),
        child: RichText(
          text: TextSpan(children: [
            const TextSpan(
                text: 'Total Expenses: ',
                style: TextStyle(color: Color(0xFF3F51B5), fontSize: 10)),
            TextSpan(
                text: amount,
                style: const TextStyle(
                    color: Color(0xFF3F51B5), fontSize: 10, fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }

  Widget _buildToggle(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 36,
      height: 18,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF4CAF50) : const Color(0xFFBDBDBD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            right: active ? 2 : 20,
            top: 2,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Center(
                child: active
                    ? const Icon(Icons.check, size: 10, color: Color(0xFF4CAF50))
                    : const Icon(Icons.close, size: 10, color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF8F9FA),
      child: ElevatedButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const NewCategorySheet(),
        ).then((_) => _fetchCategories()),
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
            Text("Add new category",
                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}