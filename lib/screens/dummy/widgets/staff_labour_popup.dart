import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../global_widget/custom_textfield.dart';
import '../../../notifier/order_detail_notifier.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';


class ManagePeoplePopup extends ConsumerStatefulWidget {
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
  ConsumerState<ManagePeoplePopup> createState() => _ManagePeoplePopupState();
}


class _ManagePeoplePopupState extends ConsumerState<ManagePeoplePopup> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, String>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = List.from(widget.people);
  }

  bool _isAlreadyAdded(String id) {
    return filteredList.any((e) => e["id"] == id);
  }

  @override
  Widget build(BuildContext context) {
    final isLabour = widget.title.toLowerCase().contains("labour");

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
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            /// ✅ TYPEAHEAD SEARCH
            TypeAheadField<dynamic>(
              controller: searchController,

              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) return [];

                if (isLabour) {
                  return await ref
                      .read(orderDetailProvider.notifier)
                      .searchLabour(pattern);
                } else {
                  return await ref
                      .read(orderDetailProvider.notifier)
                      .searchStaff(pattern);
                }
              },

              /// 🔥 CUSTOM DROPDOWN BOX i give elevation here actualy i want update this background elvation but show shadow upside
              decorationBuilder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4), // 🔥 ONLY DOWNWARD SHADOW
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: child,
                  ),
                );
              },

              /// 🔥 CUSTOM ITEM UI
              itemBuilder: (context, suggestion) {
                final id = suggestion["id"].toString();
                final alreadyAdded = _isAlreadyAdded(id);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [

                      /// AVATAR
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6ECF5),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (suggestion["name"] ?? "A")[0].toUpperCase(),
                          style: TextStyles.f12w700primary,
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// NAME + ROLE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              suggestion["name"] ?? "",
                              style: TextStyles.f12w700primary.copyWith(
                                color: AppColors.mGray9,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              suggestion["role"] ?? "",
                              style: TextStyles.f10w500Gray5,
                            ),
                          ],
                        ),
                      ),

                      /// ADD BUTTON
                      GestureDetector(
                        onTap: alreadyAdded
                            ? null
                            : () {
                          setState(() {
                            filteredList.add({
                              "name": suggestion["name"],
                              "role": suggestion["role"],
                              "id": id,
                            });
                          });
                          searchController.clear();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: alreadyAdded
                                  ? Colors.grey
                                  : AppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            alreadyAdded ? "Added" : "Add",
                            style: TextStyles.f9w700mGray9.copyWith(
                              color: alreadyAdded ? Colors.grey : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },

              /// ❌ DISABLE DEFAULT TAP (we handle with button)
              onSelected: (_) {},

              builder: (context, controller, focusNode) {
                return CustomTextField(
                  controller: controller,
                  focusNode: focusNode,
                  hintText:
                  isLabour ? "Search labour" : "Search staff",
                  borderRadius: 8,
                  hintStyle: TextStyles.f12w400Gray5,
                );
              },
            ),

            const SizedBox(height: 6),

            /// DIVIDER
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

            /// SELECTED LIST
            ...List.generate(filteredList.length, (index) {
              final item = filteredList[index];

              return Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        if (isLabour)
                          Padding(
                            padding:
                            const EdgeInsets.only(right: 6),
                            child: Text("${index + 1}.",
                                style:
                                TextStyles.f12w500Gray7),
                          ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(item["name"] ?? "",
                                  style:
                                  TextStyles.f12w700primary),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: isLabour
                                          ? "Labour ID: "
                                          : "Staff ID: ",
                                      style: TextStyles
                                          .f10w500Gray5,
                                    ),
                                    TextSpan(
                                      text: item["id"],
                                      style: TextStyles
                                          .f10w700mGray9,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              filteredList.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                              Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/delete.svg",
                              height: 16,
                              width: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != filteredList.length - 1)
                    const Divider(height: 1),
                ],
              );
            }),

            const SizedBox(height: 10),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  final payload = filteredList.map((e) => {
                    "user_id":
                    int.tryParse(e["id"] ?? "0"),
                    "role_label": e["role"],
                  }).toList();

                  Navigator.pop(context, payload);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F3A8F),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Update Staff & Labour",
                  style: TextStyles.f12w500White,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class _ManagePeoplePopupState extends ConsumerState<ManagePeoplePopup> {
//
//   final TextEditingController searchController = TextEditingController();
//
//   List<Map<String, String>> filteredList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     filteredList = widget.people;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isLabour = widget.title.toLowerCase().contains("labour");
//
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding:
//       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//
//             /// HEADER
//             Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(widget.title,
//                     style: TextStyles.f14w600Gray9),
//                 IconButton(
//                   icon: const Icon(Icons.close,
//                       size: 18, color: Colors.grey),
//                   onPressed: () =>
//                       Navigator.pop(context),
//                 ),
//               ],
//             ),
//
//             /// ✅ TYPEAHEAD SEARCH (API BASED)
//             TypeAheadField<dynamic>(
//               controller: searchController,
//
//               suggestionsCallback: (pattern) async {
//                 if (pattern.isEmpty) return [];
//
//                 if (isLabour) {
//                   return await ref.read(orderDetailProvider.notifier).searchLabour(pattern);
//                 } else {
//                   return await ref.read(orderDetailProvider.notifier).searchStaff(pattern);
//                 }
//               },
//
//               itemBuilder: (context, suggestion) {
//                 return ListTile(
//                   title: Text(suggestion["name"] ?? ""),
//                   subtitle:
//                   Text(suggestion["mobile"] ?? ""),
//                 );
//               },
//
//               onSelected: (suggestion) {
//                 setState(() {
//                   filteredList.add({
//                     "name": suggestion["name"],
//                     "role": suggestion["role"],
//                     "id": suggestion["id"].toString(), // store id
//                   });
//                 });
//
//                 searchController.clear();
//               },
//
//               builder: (context, controller, focusNode) {
//                 return CustomTextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   hintText: isLabour
//                       ? "Search labour"
//                       : "Search staff",
//                   borderRadius: 8,
//                   hintStyle: TextStyles.f12w400Gray5,
//                 );
//               },
//             ),
//
//             const SizedBox(height: 6),
//
//             /// DIVIDER
//             Row(
//               children: [
//                 const Icon(Icons.arrow_right,
//                     size: 18, color: AppColors.primary),
//                 Expanded(
//                   child: Container(
//                     height: 2,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 const Icon(Icons.arrow_left,
//                     size: 18, color: AppColors.primary),
//               ],
//             ),
//
//             const SizedBox(height: 4),
//
//             /// LIST (UNCHANGED UI ✅)
//             ...List.generate(filteredList.length, (index) {
//               final item = filteredList[index];
//
//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 6),
//                     child: Row(
//                       children: [
//
//                         /// INDEX
//                         if (isLabour)
//                           Padding(
//                             padding:
//                             const EdgeInsets.only(right: 6),
//                             child: Text("${index + 1}.",
//                                 style: TextStyles.f12w500Gray7),
//                           ),
//
//                         /// NAME + ROLE
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item["name"] ?? "",
//                                 style:
//                                 TextStyles.f12w700primary,
//                               ),
//                               RichText(
//                                 text: TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: isLabour ? "Labour ID: " : "Staff ID: ",
//                                       style: TextStyles.f10w500Gray5,
//                                     ),
//                                     TextSpan(
//                                       text: item["id"],
//                                       style: TextStyles.f10w700mGray9,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         /// DELETE
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               filteredList.removeAt(index);
//                             });
//                             widget.onDelete?.call(index);
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.red.withOpacity(0.1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: SvgPicture.asset(
//                               "assets/icons/delete.svg",
//                               height: 16,
//                               width: 16,
//                               color: Colors.red,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   if (index != filteredList.length - 1)
//                     const Divider(height: 1),
//                 ],
//               );
//             }),
//
//             const SizedBox(height: 10),
//
//             /// SAVE BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 45,
//               child: ElevatedButton(
//                 onPressed: () async {
//
//
//                   // final payload = filteredList.map((e) {
//                   //   return {
//                   //     "user_id": int.parse(e["id"]!), // ✅ force valid id
//                   //     "role_label": e["role"] ?? "Staff",
//                   //   };
//                   // }).toList();
//                   //
//                   // print("RETURN PAYLOAD >>> $payload");
//                   //
//                   // Navigator.pop(context, payload);
//
//                   /// ✅ BUILD PAYLOAD
//                   final payload = filteredList.map((e) => {
//                     "user_id": int.tryParse(e["id"] ?? "0"),
//                     "role_label": e["role"],
//                   }).toList();
//
//                   // 🔥 you can pass this payload to parent via callback
//                   Navigator.pop(context, payload);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2F3A8F),
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                     BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   "Update Staff & Labour",
//                   style: TextStyles.f12w500White,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



/*
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

            /// ✅ YOUR SEARCH FIELD here use flutter_typeahead: ^6.0.0 and this dialog reuable for staff and labour
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

            ElevatedButton(
              onPressed: () {

              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F3A8F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                  "Update Staff & Labour",
                  style: TextStyles.f12w500White
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
