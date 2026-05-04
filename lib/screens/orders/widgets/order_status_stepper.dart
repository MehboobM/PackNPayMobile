import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_n_pay/utils/app_colors.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

import '../../../models/order_detail_model.dart';

class OrderStatusStepper extends StatelessWidget {
  final List<StatusLogs> logs;
  final List<StatusTimeline> timeline;

  const OrderStatusStepper({
    super.key,
    required this.logs,
    required this.timeline,
  });

  @override
  Widget build(BuildContext context) {
    /// ✅ SORT ORDER LOGS
    final sortedLogs = logs
        .where((e) => e.statusType == "ORDER")
        .toList()
      ..sort((a, b) => (a.changedAt ?? "").compareTo(b.changedAt ?? ""));

    /// ✅ LATEST LOG
    final StatusLogs? latestLog =
    sortedLogs.isNotEmpty ? sortedLogs.last : null;

    /// ✅ BUILD STEPS FROM API (NO STATIC LIST)
    final steps = timeline.map((t) {
      StatusLogs? log;

      try {
        log = sortedLogs.firstWhere((e) => e.status == t.key);
      } catch (_) {
        log = null;
      }

      String date = "";

      if (log != null) {
        date = _formatDate(log.changedAt);
      } else if (t.done == true && latestLog != null) {
        // optional fallback
        date = _formatDate(latestLog.changedAt);
      }

      return _StepData(
        t.label ?? t.key ?? "-",
        date,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("order.orderStatus".tr(), style: TextStyles.f12w600Gray9),
          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(steps.length, (index) {
                final isCompleted = timeline[index].done == true;

                return SizedBox(
                  width: 110,
                  child: Column(
                    children: [
                      /// ===== LINE + CIRCLE =====
                      SizedBox(
                        height: 34,
                        child: Row(
                          children: [
                            /// LEFT LINE
                            Expanded(
                              child: Container(
                                height: 2,
                                color: index == 0
                                    ? Colors.transparent
                                    : (timeline[index - 1].done == true
                                    ? AppColors.primary
                                    : Colors.grey.shade300),
                              ),
                            ),

                            /// CIRCLE
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: isCompleted
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(Icons.check, size: 18)
                                  : null,
                            ),

                            /// RIGHT LINE
                            Expanded(
                              child: Container(
                                height: 2,
                                color: index == steps.length - 1
                                    ? Colors.transparent
                                    : (isCompleted
                                    ? AppColors.primary
                                    : Colors.grey.shade300),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// ===== TITLE + DATE =====
                      SizedBox(
                        height: 30,
                        child: Column(
                          children: [
                            Text(
                              steps[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyles.f8w600mGray9.copyWith(
                                color: isCompleted
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              steps[index].date,
                              textAlign: TextAlign.center,
                              style: TextStyles.f7w400mGray6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ DATE FORMAT
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "";

    final d = DateTime.tryParse(date);
    if (d == null) return date;

    return "${d.day.toString().padLeft(2, '0')} "
        "${_monthName(d.month)} ${d.year}, "
        "${_formatTime(d)}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime d) {
    final hour = d.hour > 12 ? d.hour - 12 : d.hour;
    final period = d.hour >= 12 ? "pm" : "am";

    return "${hour.toString().padLeft(2, '0')}:"
        "${d.minute.toString().padLeft(2, '0')} $period";
  }
}

class _StepData {
  final String title;
  final String date;

  _StepData(this.title, this.date);
}

// class OrderStatusStepper extends StatelessWidget {
//   final List<StatusLogs> logs;
//
//   const OrderStatusStepper({super.key, required this.logs});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> allSteps = [
//       "QUOTATION",
//       "ORDER_CONFIRMED",
//       "LR_CREATED",
//       "SETTLED",
//     ];
//
//     /// ✅ SORT LOGS
//     final sortedLogs = logs
//         .where((e) => e.statusType == "ORDER")
//         .toList();
//
//     sortedLogs.sort(
//           (a, b) => (a.changedAt ?? "").compareTo(b.changedAt ?? ""),
//     );
//
//     // final sortedLogs = [...logs];
//     // sortedLogs.sort(
//     //       (a, b) => (a.changedAt ?? "").compareTo(b.changedAt ?? ""),
//     // );
//
//     /// ✅ CURRENT STEP
//     int currentIndex = -1;
//     StatusLogs? latestLog;
//
//     if (sortedLogs.isNotEmpty) {
//       latestLog = sortedLogs.last;
//       currentIndex = allSteps.indexWhere((e) => e == latestLog!.status);
//     }
//
//     /// ✅ BUILD STEPS
//     final steps = allSteps.asMap().entries.map((entry) {
//       final index = entry.key;
//       final status = entry.value;
//
//       StatusLogs? log;
//
//       try {
//        // log = sortedLogs.firstWhere((e) => e.status == status);
//         log = sortedLogs.firstWhere((e) => e.status == status);
//       } catch (_) {
//         log = null;
//       }
//
//       String date = "";
//       if (log != null) {
//         date = _formatDate(log.changedAt);
//       } else if (currentIndex >= 0 && index <= currentIndex) {
//         date = _formatDate(latestLog?.changedAt);
//       }
//
//       return _StepData(_mapStatus(status), date);
//     }).toList();
//
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment:MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("order.orderStatus".tr(), style: TextStyles.f12w600Gray9),
//           SizedBox(height: 8,),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.zero,
//             child: Row(
//               children: List.generate(steps.length, (index) {
//                 final isCompleted = currentIndex >= 0 && index <= currentIndex;
//
//                 return SizedBox(
//                   width: 110, // ✅ FIXED WIDTH (important)
//                   child: Column(
//                     children: [
//                       /// ================= TOP (LINE + CIRCLE) =================
//
//                       SizedBox(
//                         height: 34,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             /// LEFT LINE
//                             Expanded(
//                               child: Container(
//                                 height: 2,
//                                 color: index == 0
//                                     ? Colors.transparent
//                                     : (index <= currentIndex
//                                     ? AppColors.primary
//                                     : Colors.grey.shade300),
//                               ),
//                             ),
//
//                             /// CIRCLE
//                             Container(
//                               width: 34,
//                               height: 34,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                                 border: Border.all(
//                                   color: isCompleted
//                                       ? AppColors.primary
//                                       : Colors.grey.shade300,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: isCompleted
//                                   ? const Icon(Icons.check, size: 18)
//                                   : null,
//                             ),
//
//                             /// RIGHT LINE
//                             Expanded(
//                               child: Container(
//                                 height: 2,
//                                 color: index == steps.length - 1
//                                     ? Colors.transparent
//                                     : (index < currentIndex
//                                     ? AppColors.primary
//                                     : Colors.grey.shade300),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 6),
//
//                       /// ================= FIXED HEIGHT CONTENT =================
//                       SizedBox(
//                         height: 30, // ✅ KEY FIX (no layout shifting)
//                         child: Column(
//                           children: [
//                             /// TITLE
//                             Text(
//                               steps[index].title,
//                               textAlign: TextAlign.center,
//                               style: TextStyles.f8w600mGray9.copyWith(
//                                 color: isCompleted
//                                     ? AppColors.primary
//                                     : Colors.grey,
//                               ),
//                             ),
//
//                             const SizedBox(height: 2),
//
//                             /// DATE
//                             Text(
//                               steps[index].date,
//                               textAlign: TextAlign.center,
//                               style: TextStyles.f7w400mGray6,
//                             ),
//
//
//
//                             /// DOWNLOAD ICON
//                             // const SizedBox(height: 6),
//                             // if (steps[index].date.isNotEmpty)
//                             //   Icon(
//                             //     Icons.download,
//                             //     size: 16,
//                             //     color: AppColors.primary,
//                             //   ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// ✅ STATUS TEXT MAP
//   String _mapStatus(String? status) {
//     switch (status) {
//       case "QUOTATION":
//         return "Quotation";
//       case "ORDER_CONFIRMED":
//         return "Order Confirmed";
//       case "LR_CREATED":
//         return "LR/Bilty";
//       case "SETTLED":
//         return "Settled";
//       default:
//         return status ?? "-";
//     }
//   }
//
//   /// ✅ DATE FORMAT
//   String _formatDate(String? date) {
//     if (date == null || date.isEmpty) return "";
//
//     final d = DateTime.tryParse(date);
//     if (d == null) return date;
//
//     return "${d.day.toString().padLeft(2, '0')} "
//         "${_monthName(d.month)} ${d.year}, "
//         "${_formatTime(d)}";
//   }
//
//   String _monthName(int month) {
//     const months = [
//       "Jan", "Feb", "Mar", "Apr", "May", "Jun",
//       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
//     ];
//     return months[month - 1];
//   }
//
//   String _formatTime(DateTime d) {
//     final hour = d.hour > 12 ? d.hour - 12 : d.hour;
//     final period = d.hour >= 12 ? "pm" : "am";
//
//     return "${hour.toString().padLeft(2, '0')}:"
//         "${d.minute.toString().padLeft(2, '0')} $period";
//   }
// }
//
// class _StepData {
//   final String title;
//   final String date;
//
//   _StepData(this.title, this.date);
// }
//
// class OrderStatusStepper extends StatelessWidget {
//   final List<StatusLogs> logs;
//
//   const OrderStatusStepper({super.key, required this.logs});
//
//   @override
//   Widget build(BuildContext context) {
//     /// ✅ FIXED FLOW
//     final List<String> allSteps = [
//       "QUOTATION",
//       "ORDER_CONFIRMED",
//       "LR_CREATED",
//       "SETTLED",
//     ];
//
//     /// ✅ SORT LOGS
//     final sortedLogs = [...logs];
//     sortedLogs.sort((a, b) =>
//         (a.changedAt ?? "").compareTo(b.changedAt ?? ""));
//
//     /// ✅ CURRENT INDEX
//     int currentIndex = -1;
//
//     if (sortedLogs.isNotEmpty) {
//       final latestStatus = sortedLogs.last.status;
//       currentIndex = allSteps.indexWhere((e) => e == latestStatus);
//     }
//
//     /// ✅ MAP EACH STEP TO ITS OWN LOG (NO WRONG DATE NOW)
//     final steps = allSteps.map((status) {
//       StatusLogs? log;
//
//       try {
//         log = sortedLogs.firstWhere((e) => e.status == status);
//       } catch (_) {
//         log = null;
//       }
//
//       return _StepData(
//         _mapStatus(status),
//         log != null ? _formatDate(log.changedAt) : "",
//       );
//     }).toList();
//
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: List.generate(steps.length, (index) {
//             final isCompleted = currentIndex >= 0 && index <= currentIndex;
//
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     /// ✅ PERFECT ALIGNMENT FIX
//                     SizedBox(
//                       height: 34, // SAME AS CIRCLE
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           /// LEFT LINE
//                           if (index != 0)
//                             Align(
//                               alignment: Alignment.center,
//                               child: Container(
//                                 width: 40,
//                                 height: 2,
//                                 color: index <= currentIndex && currentIndex != -1
//                                     ? AppColors.primary
//                                     : Colors.grey.shade300,
//                               ),
//                             ),
//
//                           /// CIRCLE
//                           Container(
//                             width: 34,
//                             height: 34,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: isCompleted
//                                     ? AppColors.primary
//                                     : Colors.grey.shade300,
//                                 width: 2,
//                               ),
//                             ),
//                             child: isCompleted
//                                 ? const Icon(
//                               Icons.check,
//                               size: 18,
//                             )
//                                 : null,
//                           ),
//
//                           /// RIGHT LINE
//                           if (index != steps.length - 1)
//                             Align(
//                               alignment: Alignment.center,
//                               child: Container(
//                                 width: 40,
//                                 height: 2,
//                                 color: index < currentIndex && currentIndex != -1
//                                     ? AppColors.primary
//                                     : Colors.grey.shade300,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 6),
//
//                     /// TITLE
//                     Text(
//                       steps[index].title,
//                       style: TextStyles.f8w600mGray9.copyWith(
//                         color: isCompleted
//                             ? AppColors.primary
//                             : Colors.grey,
//                       ),
//                     ),
//
//                     const SizedBox(height: 2),
//
//                     /// DATE (NOW CORRECT PER STEP)
//                     Text(
//                       steps[index].date,
//                       style: TextStyles.f7w400mGray6,
//                     ),
//
//                     const SizedBox(height: 6),
//
//                     /// DOWNLOAD ICON (ONLY WHEN STEP EXISTS)
//                     if (steps[index].date.isNotEmpty)
//                       Icon(
//                         Icons.download,
//                         size: 16,
//                         color: AppColors.primary,
//                       ),
//                   ],
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
//
//   /// ✅ STATUS MAP
//   String _mapStatus(String? status) {
//     switch (status) {
//       case "QUOTATION":
//         return "Quotation";
//       case "ORDER_CONFIRMED":
//         return "Order Confirmed";
//       case "LR_CREATED":
//         return "LR/Bilty";
//       case "SETTLED":
//         return "Settled";
//       default:
//         return status ?? "-";
//     }
//   }
//
//   /// ✅ DATE FORMAT
//   String _formatDate(String? date) {
//     if (date == null || date.isEmpty) return "";
//
//     final d = DateTime.tryParse(date);
//     if (d == null) return date;
//
//     return "${d.day.toString().padLeft(2, '0')} "
//         "${_monthName(d.month)} ${d.year}, "
//         "${_formatTime(d)}";
//   }
//
//   String _monthName(int month) {
//     const months = [
//       "Jan","Feb","Mar","Apr","May","Jun",
//       "Jul","Aug","Sep","Oct","Nov","Dec"
//     ];
//     return months[month - 1];
//   }
//
//   String _formatTime(DateTime d) {
//     final hour = d.hour > 12 ? d.hour - 12 : d.hour;
//     final period = d.hour >= 12 ? "pm" : "am";
//
//     return "${hour.toString().padLeft(2, '0')}:"
//         "${d.minute.toString().padLeft(2, '0')} $period";
//   }
// }
//
// class _StepData {
//   final String title;
//   final String date;
//
//   _StepData(this.title, this.date);
// }

/*
class OrderStatusStepper extends StatelessWidget {
  final int currentStep;

  const OrderStatusStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
     // _StepData("Survey list", "Jan 12, 2026 6:07 pm"),
      _StepData("Quotation", "Jan 14, 2026 11:25 am"),
      _StepData("Order Confirmed", "Jan 16, 2026 4:32 pm"),
      _StepData("LR/Bilty", "Feb 5, 2026 7:08 am"),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ WHITE BACKGROUND
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index <= currentStep;

            return Row(
              children: [

                Column(
                  children: [

                    /// LINE + CIRCLE
                    Row(
                      children: [

                        if (index != 0)
                          Container(
                            width: 40,
                            height: 2,
                            color: isCompleted
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),

                        /// CIRCLE
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: isCompleted
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                              ? Padding(
                            padding: const EdgeInsets.all(6),
                            child: SvgPicture.asset(
                              "assets/icons/stepper_image.svg",
                              fit: BoxFit.contain,
                            ),
                          )
                              : null,
                        ),

                        if (index != steps.length - 1)
                          Container(
                            width: 40,
                            height: 2,
                            color: index < currentStep
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// TITLE
                    Text(
                      steps[index].title,
                      style: TextStyles.f8w600mGray9,
                    ),

                    const SizedBox(height: 2),

                    /// DATE
                    Text(
                      steps[index].date,
                      style: TextStyles.f7w400mGray6,
                    ),

                    const SizedBox(height: 6),

                    /// DOWNLOAD ICON
                    Icon(
                      Icons.download,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

*/
