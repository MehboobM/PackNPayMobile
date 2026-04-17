import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class ManagePeoplePopup extends StatefulWidget {
  final String title;
  final List<Map<String, String>> people;
  final Function(int index)? onDelete;

  const ManagePeoplePopup({
    super.key,
    required this.title,
    required this.people,
    this.onDelete,
  });

  @override
  State<ManagePeoplePopup> createState() => _ManagePeoplePopupState();
}

class _ManagePeoplePopupState extends State<ManagePeoplePopup> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, String>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = widget.people;
  }

  void _filter(String value) {
    setState(() {
      filteredList = widget.people
          .where((e) => e["name"]!
          .toLowerCase()
          .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: TextStyles.f14w600Gray9),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 18, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            /// ✅ YOUR SEARCH FIELD
            CustomTextField(
              controller: searchController,
              hintText: "Search labor",
              borderRadius: 8,
              hintStyle: TextStyles.f12w400Gray5,
              onChanged: _filter,
            ),

            const SizedBox(height: 6),

            /// ✅ YOUR ARROW DIVIDER
            Row(
              children: [
                const Icon(Icons.arrow_right,
                    size: 18, color: AppColors.primary),
                Expanded(
                  child: Container(
                    height: 2,
                    color: AppColors.primary,
                  ),
                ),
                const Icon(Icons.arrow_left,
                    size: 18, color: AppColors.primary),
              ],
            ),

            const SizedBox(height: 4),

            /// LIST
            ...List.generate(filteredList.length, (index) {
              final item = filteredList[index];

              return Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        /// INDEX (for labour list style)
                        if (widget.title.toLowerCase().contains("labour"))
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text("${index + 1}.",
                                style: TextStyles.f12w500Gray7),
                          ),

                        /// NAME + ROLE
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"] ?? "",
                                style: TextStyles.f12w700primary
                              ),

                              RichText(
                                text: TextSpan(
                                  children: [
                                     TextSpan(
                                      text: "Staff ID: ",
                                      style: TextStyles.f10w500Gray5
                                    ),
                                    TextSpan(
                                      text: item["role"],
                                      style:  TextStyles.f10w700mGray9
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DELETE BUTTON (SVG)
                        GestureDetector(
                          onTap: () {
                            widget.onDelete?.call(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/delete.svg", // your svg
                              height: 16,
                              width: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Divider between items
                  if (index != filteredList.length - 1)
                    const Divider(height: 1),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}