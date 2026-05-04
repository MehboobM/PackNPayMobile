import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import '../../api_services/api_end_points.dart';
import '../../database/shared_preferences/shared_storage.dart';
import '../../utils/toast_message.dart';

class NewExpensesSheet extends StatefulWidget {
  final String? uid;
  const NewExpensesSheet({super.key, this.uid});

  @override
  State<NewExpensesSheet> createState() => _NewExpensesSheetState();
}

class _NewExpensesSheetState extends State<NewExpensesSheet> {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  List<dynamic> _categories = [];
  int? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    if (widget.uid != null) _fetchExpenseDetails();
  }

  Future<void> _fetchCategories() async {
    try {
      String? token = await _storage.getToken();
      final response = await _dio.get(
        '${ApiEndPoints.baseurl}expense-category-list',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() => _categories = response.data['data']);
    } catch (e) {
      debugPrint("Category Fetch Error: $e");
    }
  }

  Future<void> _fetchExpenseDetails() async {
    try {
      String? token = await _storage.getToken();
      final response = await _dio.get(
        '${ApiEndPoints.baseurl}office-expense',
        queryParameters: {'uid': widget.uid},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'];
      setState(() {
        _amountController.text = data['amount'].toString();
        _nameController.text = data['name'];
        _selectedCategoryId = data['category_id'];
        _remarksController.text = data['remarks'] ?? "";
      });
    } catch (e) {
      debugPrint("Details Fetch Error: $e");
    }
  }

  Future<void> _saveExpense() async {
    /// ✅ VALIDATION FIRST
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (amount <= 0) {
      ToastHelper.showError(
        message: "Enter valid amount",
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      ToastHelper.showError(
        message: "Enter expense name",
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ToastHelper.showError(
        message: "Select expense category",
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? token = await _storage.getToken();

      final payload = {
        "expense_date": DateTime.now().toString().split(' ')[0],
        "name": _nameController.text.trim(),
        "category_id": _selectedCategoryId,
        "amount": amount,
        "remarks": _remarksController.text.trim(),
      };

      if (widget.uid == null) {
        await _dio.post(
          '${ApiEndPoints.baseurl}office-expense/create',
          data: payload,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      } else {
        await _dio.put(
          '${ApiEndPoints.baseurl}office-expense/update/${widget.uid}',
          data: payload,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }

      /// ✅ SUCCESS TOAST
      ToastHelper.showSuccess(
        message: widget.uid == null
            ? "Expense added successfully"
            : "Expense updated successfully",
      );

      Navigator.pop(context);
    } catch (e) {
      /// ❌ ERROR TOAST (API error)
      ToastHelper.showError(
        message: "Failed to save expense",
      );

      debugPrint("Save Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.uid == null ? "New office Expense" : "Edit office Expense",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2E3B8E))),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAmountInput(),
                const Text("Expense Amount", style: TextStyle(fontSize: 13, color: Color(0xFF757575))),
                const SizedBox(height: 16),
                _buildInputLabel("Expense Name"),
                _buildTextField(_nameController, "Enter name"),
                const SizedBox(height: 16),
                _buildInputLabel("Expense category"),
                _buildDropdownField(),
                const SizedBox(height: 80),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveExpense,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E3B8E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Save", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return IntrinsicWidth(
      child: TextField(
        controller: _amountController,
        autofocus: true,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 36, color: Color(0xFF2E3B8E), fontWeight: FontWeight.w700),
        decoration: const InputDecoration(
          prefixText: "₹ ",
          prefixStyle: TextStyle(fontSize: 32, color: Color(0xFFBDBDBD), fontWeight: FontWeight.w300),
          hintText: "0.00",
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(alignment: Alignment.centerLeft, child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF424242))));
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE0E0E0))),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), border: InputBorder.none),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          isExpanded: true,
          value: _selectedCategoryId,

          hint: const Text(
            "Select category",
            style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
          ),

          items: _categories.map<DropdownMenuItem<int>>((item) {
            return DropdownMenuItem<int>(
              value: item['id'],
              child: Text(
                item['name'],
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),

          onChanged: (val) {
            setState(() => _selectedCategoryId = val);
          },

          /// 🔹 BUTTON STYLE (closed box)
          buttonStyleData: ButtonStyleData(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              color: Colors.white,
            ),
          ),

          /// 🔹 DROPDOWN STYLE (OPENED WHITE BOX BELOW)
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              color: Colors.white, // ✅ white background
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            offset: const Offset(0, 4), // ✅ opens BELOW
          ),

          /// 🔹 ITEM STYLE
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),

          /// 🔹 ICON
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            iconEnabledColor: Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}