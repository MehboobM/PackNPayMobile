 import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../api_services/api_end_points.dart';
import '../../database/shared_preferences/shared_storage.dart';
import 'money_recipt_page.dart';

class LetterHeadPage extends StatefulWidget {
  const LetterHeadPage({super.key});

  @override
  State<LetterHeadPage> createState() => _LetterHeadPageState();
}

class _LetterHeadPageState extends State<LetterHeadPage> {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();
  final GlobalKey _filterKey = GlobalKey();

  List<dynamic> _allLetterHeads = [];
  String? _selectedSort;
  List<dynamic> _filteredLetterHeads = [];
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchLetterHeads();
  }

  Future<void> _fetchLetterHeads({
    String? search,
    String? fromDate,
    String? toDate,
    String? sortOrder,
  }) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      String? token = await _storage.getToken();

      final response = await _dio.get(
        '${ApiEndPoints.baseurl}letter-head-list',
        queryParameters: {
          if (search != null && search.isNotEmpty) "search": search,
          if (fromDate != null) "from_date": fromDate,
          if (toDate != null) "to_date": toDate,
          if (sortOrder != null) "sort_order": sortOrder,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      setState(() {
        _filteredLetterHeads = response.data['data'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load data";
        _isLoading = false;
      });
    }
  }

  // --- SEARCH LOGIC ---
  void _runFilter(String query) {
    _fetchLetterHeads(search: query);
  }
  void _onFilterTap() {
    final RenderBox button =
    _filterKey.currentContext!.findRenderObject() as RenderBox;

    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset position =
    button.localToGlobal(Offset.zero, ancestor: overlay);

    _showFilterPopup(context, position, button.size);
  }

  // --- DATE FILTER LOGIC ---
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final formatted =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      _fetchLetterHeads(fromDate: formatted, toDate: formatted);
    }
  }

  // --- DELETE LOGIC ---
  Future<void> _deleteLetterHead(String uid) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      String? token = await _storage.getToken();

      // FIXED URL: Removed "/update" from the DELETE request
      final response = await _dio.delete(
        '${ApiEndPoints.baseurl}letter-head/$uid',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      Navigator.pop(context); // Remove loading indicator

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Deleted successfully"),
              backgroundColor: Colors.green),
        );
        _fetchLetterHeads(); // Refresh the list
      }
    } on DioException catch (e) {
      Navigator.pop(context); // Remove loading indicator
      debugPrint("Delete Error: ${e.response?.statusCode} - ${e.response?.data}");

      // If the above still fails with 404, try: /api/letter-head/delete/$uid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Delete failed: ${e.response?.statusCode ?? 'Unknown Error'}")),
      );
    }
  }

  // --- DELETE CONFIRMATION DIALOG ---
  void _showDeleteDialog(String uid, String lhNo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete $lhNo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteLetterHead(uid);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text('Letter Head',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: const Color(0xFFDDE7FF),
                  borderRadius: BorderRadius.circular(10)),
              child: Text('${_filteredLetterHeads.length}',
                  style: const TextStyle(
                      color: Color(0xFF3F51B5),
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const MoneyReciptPage(uid: null))).then((value) {
                if (value == true) _fetchLetterHeads();
              }),
              icon: const Icon(Icons.add, size: 14),
              label: const Text("Create new", style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E3B8E),
                  foregroundColor: Colors.white,
                  elevation: 0),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0))),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _runFilter,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search, size: 18),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildIconButton(Icons.filter_list, _onFilterTap, key: _filterKey),
                const SizedBox(width: 8),
                _buildIconButton(Icons.calendar_today_outlined,
                        () => _selectDate(context)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildTableHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _fetchLetterHeads,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredLetterHeads.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _buildLetterHeadTile(_filteredLetterHeads[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Key? key}) {
    return InkWell(
      key: key,
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: const BoxDecoration(
          color: Color(0xFF2E3B8E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      child: Row(
        children: const [
          Expanded(
              flex: 4,
              child: Text("CUSTOMER",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold))),
          Expanded(
              flex: 5,
              child: Text("CONTACT DETAILS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold))),
          Text("ACTION",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLetterHeadTile(dynamic data)  {
    final String uid = data['uid'] ?? "";
    final String lhNo = data['lh_no'] ?? "N/A";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ]),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lhNo,
                        style: const TextStyle(
                            color: Color(0xFF757575), fontSize: 10.5)),
                    Text(data['lh_date'] ?? "",
                        style: const TextStyle(
                            color: Color(0xFF757575), fontSize: 10.5)),
                    Text(data['name']?.toString().toUpperCase() ?? "UNKNOWN",
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 12)),
                  ])),
          Expanded(
              flex: 5,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['phone'] ?? "N/A",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                    Text(data['email'] ?? "N/A",
                        style: const TextStyle(
                            color: Color(0xFF616161), fontSize: 10.5)),
                  ])),
          PopupMenuButton<String>(
            icon:
            const Icon(Icons.more_vert, size: 20, color: Color(0xFF616161)),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MoneyReciptPage(uid: uid)))
                    .then((value) {
                  if (value == true) _fetchLetterHeads();
                });
              } else if (value == 'delete') {
                _showDeleteDialog(uid, lhNo);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text("Edit")
                  ])),
              const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Delete", style: TextStyle(color: Colors.red))
                  ])),
            ],
          ),
        ],
      ),
    );
  }
  void _showFilterPopup(
      BuildContext context, Offset position, Size size) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height, // 👈 THIS MAKES IT OPEN BELOW ICON
        position.dx + size.width,
        position.dy,
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Filter",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),

                  RadioListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Newest First"),
                    value: "desc",
                    groupValue: _selectedSort,
                    onChanged: (val) {
                      setState(() => _selectedSort = val);
                    },
                  ),

                  RadioListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Oldest First"),
                    value: "asc",
                    groupValue: _selectedSort,
                    onChanged: (val) {
                      setState(() => _selectedSort = val);
                    },
                  ),

                  RadioListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text("All"),
                    value: null,
                    groupValue: _selectedSort,
                    onChanged: (val) {
                      setState(() => _selectedSort = val);
                    },
                  ),

                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedSort);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E3B8E),
                      minimumSize: const Size(double.infinity, 36),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );

    if (result != null) {
      _selectedSort = result;
      _fetchLetterHeads(sortOrder: result);
    } else {
      _fetchLetterHeads();
    }
  }
}