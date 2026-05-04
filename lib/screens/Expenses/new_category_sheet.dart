import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pack_n_pay/api_services/api_end_points.dart';
import '../../database/shared_preferences/shared_storage.dart';

class NewCategorySheet extends StatefulWidget {
  final String? uid;
  const NewCategorySheet({super.key, this.uid});

  @override
  State<NewCategorySheet> createState() => _NewCategorySheetState();
}

class _NewCategorySheetState extends State<NewCategorySheet> {
  final TextEditingController _nameController = TextEditingController();
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.uid != null) _fetchCategoryData();
  }

  Future<void> _fetchCategoryData() async {
    try {
      String? token = await _storage.getToken();
      final response = await _dio.get(
        '${ApiEndPoints.baseurl}expense-category',
        queryParameters: {'uid': widget.uid},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data['success'] == true) {
        setState(() {
          _nameController.text = response.data['data']['name'];
        });
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  Future<void> _saveCategory() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      String? token = await _storage.getToken();
      final payload = {
        "name": _nameController.text,
        "amount": 0, // Default for category creation
        "sort_order": 1
      };

      if (widget.uid == null) {
        await _dio.post(
          '${ApiEndPoints.baseurl}expense-category/create',
          data: payload,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      } else {
        await _dio.put(
          '${ApiEndPoints.baseurl}expense-category/update/${widget.uid}',
          data: payload,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
      Navigator.pop(context);
    } catch (e) {
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.uid == null ? "New Expense Category" : "Edit Expense Category",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2E3B8E)),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.grey)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                const Text("Category Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Enter category name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveCategory,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E3B8E)),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}