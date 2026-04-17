import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../database/shared_preferences/shared_storage.dart';

class MoneyReciptPage extends StatefulWidget {
  final String? uid;
  const MoneyReciptPage({super.key, this.uid});

  @override
  State<MoneyReciptPage> createState() => _MoneyReciptPageState();
}

class _MoneyReciptPageState extends State<MoneyReciptPage> {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  // Controllers
  final TextEditingController _lhNoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.uid != null && widget.uid!.isNotEmpty) {
      _fetchDetails();
    } else {
      // Set default values for new entries
      _lhNoController.text = "#PNP0001";
      _dateController.text = DateTime.now().toString().split(' ')[0];
    }
  }

  // GET API Call (Fetch for Edit)
  Future<void> _fetchDetails() async {
    setState(() => _isLoading = true);
    try {
      String? token = await _storage.getToken();
      final response = await _dio.get(
        'http://192.168.0.176:5000/api/letter-head',
        queryParameters: {'uid': widget.uid},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        setState(() {
          _lhNoController.text = data['lh_no'] ?? "";
          _dateController.text = data['lh_date'] ?? "";
          _nameController.text = data['name'] ?? "";
          _phoneController.text = data['phone'] ?? "";
          _emailController.text = data['email'] ?? "";
          _remarksController.text = data['remarks'] ?? "";
          _contentController.text = data['letter_content'] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showPdfPreview() async {
    if (widget.uid == null || widget.uid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please save the letter head first to preview")),
      );
      return;
    }

    String? token = await _storage.getToken();
    final String pdfUrl = 'http://192.168.0.176:5000/api/letter-head/preview/${widget.uid}';

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("PDF Preview"),
            backgroundColor: const Color(0xFF2E3B8E),
            foregroundColor: Colors.white,
          ),
          body: SfPdfViewer.network(
            pdfUrl,
            headers: {'Authorization': 'Bearer $token'},
          ),
        ),
      ),
    );
  }

  // POST / PUT API Call (Save)
  Future<void> _handleSave() async {
    // Basic Validation
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and Phone are required")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? token = await _storage.getToken();

      final payload = {
        "company_id": 1,
        "lh_date": _dateController.text,
        "name": _nameController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
        "remarks": _remarksController.text,
        "letter_content": _contentController.text,
      };

      Response response;
      // Safety check: Use PUT only if widget.uid is provided and not empty
      if (widget.uid != null && widget.uid!.isNotEmpty) {
        // UPDATE (PUT)
        response = await _dio.put(
          'http://192.168.0.176:5000/api/letter-head/update/${widget.uid}',
          data: payload,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      } else {
        // CREATE (POST)
        payload["lh_no"] = _lhNoController.text;
        response = await _dio.post(
          'http://192.168.0.176:5000/api/letter-head/create',
          data: payload,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Saved successfully!")),
        );
        Navigator.pop(context, true); // Return true to refresh list
      }
    } on DioException catch (e) {
      debugPrint("Dio Error: ${e.response?.statusCode} - ${e.response?.data}");
      String errorMsg = "Server Error: ${e.response?.statusCode ?? 'Unknown'}";
      if (e.response?.statusCode == 404) {
        errorMsg = "Error 404: API endpoint or UID not found";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    } catch (e) {
      debugPrint("Save Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E3B8E)))
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSectionHeader("Basic Details"),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            "LH No.",
                            controller: _lhNoController,
                            placeholder: "#PNP0001",
                            isReadOnly: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _selectDate,
                            child: AbsorbPointer(
                              child: _buildInputField(
                                "Date",
                                controller: _dateController,
                                placeholder: "YYYY-MM-DD",
                                suffixIcon: Icons.calendar_month_outlined,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInputField("Name", controller: _nameController, placeholder: "Enter name"),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildInputField("Phone", controller: _phoneController, placeholder: "Enter")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField("Email", controller: _emailController, placeholder: "Enter")),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInputField("Remarks", controller: _remarksController, placeholder: "Write remarks...", maxLines: 2),
                    const SizedBox(height: 20),
                    _buildSectionHeader("Letter Details", showRichTextTools: true),
                    const SizedBox(height: 10),
                    _buildInputField("", controller: _contentController, placeholder: "Enter a description...", maxLines: 8),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Text(
            widget.uid == null ? 'New Letter head' : 'Edit Letter head',
            style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          if (_lhNoController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFDDE7FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _lhNoController.text,
                style: const TextStyle(color: Color(0xFF3F51B5), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: _showPdfPreview,
          icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF2E3B8E)),
          label: const Text(
            "Preview",
            style: TextStyle(
              color: Color(0xFF2E3B8E),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildInputField(String label,
      {required String placeholder,
        required TextEditingController controller,
        IconData? suffixIcon,
        int maxLines = 1,
        bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(color: Color(0xFF616161), fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: isReadOnly ? const Color(0xFFF8F8F8) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  readOnly: isReadOnly,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 12.5),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              if (suffixIcon != null) Icon(suffixIcon, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool showRichTextTools = false}) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF2E3B8E), fontSize: 14, fontWeight: FontWeight.bold)),
        if (!showRichTextTools) ...[
          const SizedBox(width: 10),
          Expanded(child: Container(height: 1, color: const Color(0xFFEEEEEE))),
        ],
        if (showRichTextTools) ...[
          const SizedBox(width: 10),
          const Icon(Icons.format_bold, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          const Icon(Icons.format_italic, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          const Icon(Icons.link, size: 16, color: Colors.grey),
        ]
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2E3B8E)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text("Back", style: TextStyle(color: Color(0xFF2E3B8E), fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3B8E),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                elevation: 0,
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}