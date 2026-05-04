import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pack_n_pay/utils/app_colors.dart';

class CommonFilterBottomSheet extends StatefulWidget {
  final dynamic notifier;

  const CommonFilterBottomSheet({
    super.key,
    required this.notifier,
  });

  @override
  State<CommonFilterBottomSheet> createState() =>
      _CommonFilterBottomSheetState();
}

class _CommonFilterBottomSheetState
    extends State<CommonFilterBottomSheet> {
  String? selectedSort;
  int? selectedStaffId;

  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedSort = widget.notifier.sortOrder;
    selectedStaffId = widget.notifier.staffId;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staffList = (widget.notifier.staffList ?? []);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Row(
            children: [
              const Text(
                "Filters",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedSort = null;
                    selectedStaffId = null;
                  });
                },
                child: const Text("Reset"),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// SORT
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildSortItem("Old", "old"),
                _buildSortItem("New", "new"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// STAFF DROPDOWN (UNCHANGED UI)
          DropdownButtonHideUnderline(
            child: DropdownButton2<int>(
              isExpanded: true,
              hint: const Text("Search & Select Staff"),
              value: selectedStaffId,

              items: staffList
                  .map<DropdownMenuItem<int>>((staff) {
                final id = staff['id'];
                final parsedId = id is int
                    ? id
                    : int.tryParse(id.toString());

                return DropdownMenuItem<int>(
                  value: parsedId,
                  child: Text(
                    staff['name']?.toString() ?? '',
                  ),
                );
              }).toList(),

              onChanged: (val) {
                setState(() => selectedStaffId = val);
              },

              buttonStyleData: ButtonStyleData(
                height: 50,
                padding:
                const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: Colors.grey.shade300),
                ),
              ),

              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down),
              ),

              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              dropdownSearchData: DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search staff...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  final text =
                      (item.child as Text).data ?? '';
                  return text
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// APPLY BUTTON
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                widget.notifier.updateSort(selectedSort);
                widget.notifier.updateStaff(selectedStaffId);

                Navigator.pop(context);
              },
              child: const Text(
                "Apply Filters",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSortItem(String title, String value) {
    final isSelected = selectedSort == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedSort = value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color:
              isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}