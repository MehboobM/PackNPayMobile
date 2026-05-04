import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../models/order_detail_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';


class ShipmentStatusStepper extends StatelessWidget {
  final List<StatusLogs> logs;

  const ShipmentStatusStepper({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    /// ✅ FILTER ONLY SHIPMENT LOGS
    final shipmentLogs =
    logs.where((e) => e.statusType == "SHIPMENT").toList();

    /// ✅ SORT BY DATE
    shipmentLogs.sort(
          (a, b) => (a.changedAt ?? "").compareTo(b.changedAt ?? ""),
    );

    /// ✅ DEFINE FLOW
    final List<String> allSteps = [
      "SHIFTING_STARTED",
      "PICKUP_COMPLETED",
      "SHIFTING_COMPLETED",
      "SETTLED",
    ];

    /// ✅ FIND CURRENT STEP
    int currentIndex = -1;

    if (shipmentLogs.isNotEmpty) {
      final latestLog = shipmentLogs.last;
      currentIndex = allSteps.indexOf(latestLog.status ?? "");
    }

    /// 🚨 IMPORTANT FIX:
    final bool hasShipment = shipmentLogs.isNotEmpty;

    /// ✅ BUILD STEP DATA
    final steps = allSteps.map((status) {
      StatusLogs? log;

      try {
        log = shipmentLogs.firstWhere((e) => e.status == status);
      } catch (_) {
        log = null;
      }

      return {
        "title": _mapStatus(status),
        "date": log != null ? _formatDate(log.changedAt) : "",
      };
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("order.shipmentStatus".tr(), style: TextStyles.f12w600Gray9),
          const SizedBox(height: 16),

          SizedBox(
            height: 70,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final stepWidth = totalWidth / steps.length;

                return Stack(
                  children: [
                    /// ✅ FULL GREY LINE
                    Positioned(
                      top: 10,
                      left: stepWidth / 2,
                      right: stepWidth / 2,
                      child: Container(
                        height: 2,
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),

                    /// ✅ ACTIVE LINE (ONLY IF DATA EXISTS)
                    if (hasShipment && currentIndex > 0)
                      Positioned(
                        top: 10,
                        left: stepWidth / 2,
                        width: stepWidth * currentIndex,
                        child: Container(
                          height: 2,
                          color: AppColors.primary,
                        ),
                      ),

                    /// ✅ STEPS
                    Row(
                      children: List.generate(steps.length, (index) {
                        final isCompleted =
                            hasShipment && index <= currentIndex;

                        return Expanded(
                          child: Column(
                            children: [
                              /// 🔥 CIRCLE
                              _buildCircle(
                                index,
                                currentIndex,
                                hasShipment,
                              ),

                              const SizedBox(height: 8),

                              /// TITLE
                              Text(
                                steps[index]["title"]!,
                                textAlign: TextAlign.center,
                                style: TextStyles.f8w600mGray9.copyWith(
                                  color: isCompleted
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 4),

                              /// DATE
                              Text(
                                steps[index]["date"]!,
                                textAlign: TextAlign.center,
                                style: TextStyles.f7w400mGray6,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ FIXED CIRCLE LOGIC
  Widget _buildCircle(int index, int currentIndex, bool hasShipment) {
    /// 🚨 NO DATA → ALL GREY
    if (!hasShipment) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 4),
        ),
      );
    }

    /// ✅ COMPLETED
    if (index < currentIndex) {
      return Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 12, color: Colors.white),
      );
    }

    /// ✅ CURRENT
    else if (index == currentIndex) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 4),
        ),
      );
    }

    /// ✅ FUTURE
    else {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 4),
        ),
      );
    }
  }

  /// ✅ MAP STATUS
  String _mapStatus(String status) {
    switch (status) {
      case "SHIFTING_STARTED":
        return "Shifting Started";
      case "PICKUP_COMPLETED":
        return "Pickup Completed";
      case "SHIFTING_COMPLETED":
        return "Shifting Completed";
      case "SETTLED":
        return "Settled";
      default:
        return status;
    }
  }

  /// ✅ FORMAT DATE
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
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
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


/*
class ShipmentStatusStepper extends StatelessWidget {
  final List<StatusLogs> logs;

  const ShipmentStatusStepper({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    /// ✅ FILTER ONLY SHIPMENT LOGS
    final shipmentLogs = logs
        .where((e) => e.statusType == "SHIPMENT")
        .toList();

    /// ✅ SORT BY DATE
    shipmentLogs.sort(
          (a, b) => (a.changedAt ?? "").compareTo(b.changedAt ?? ""),
    );

    /// ✅ DEFINE FLOW
    final List<String> allSteps = [
      "SHIFTING_STARTED",
      "PICKUP_COMPLETED",
      "SHIFTING_COMPLETED",
      "SETTLED",
    ];

    /// ✅ FIND CURRENT STEP
    int currentIndex = -1;
    StatusLogs? latestLog;

    if (shipmentLogs.isNotEmpty) {
      latestLog = shipmentLogs.last;
      currentIndex = allSteps.indexOf(latestLog.status ?? "");
    }

    /// ✅ BUILD STEP DATA
    final steps = allSteps.map((status) {
      StatusLogs? log;

      try {
        log = shipmentLogs.firstWhere((e) => e.status == status);
      } catch (_) {
        log = null;
      }

      return {
        "title": _mapStatus(status),
        "date": log != null ? _formatDate(log.changedAt) : "",
      };
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Shipment Status", style: TextStyles.f12w600Gray9),
          const SizedBox(height: 16),

          SizedBox(
            height: 60,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final stepWidth = totalWidth / steps.length;

                return Stack(
                  children: [
                    /// GREY LINE
                    Positioned(
                      top: 10,
                      left: stepWidth / 2,
                      right: stepWidth / 2,
                      child: Container(
                        height: 2,
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),

                    /// ACTIVE LINE
                    Positioned(
                      top: 10,
                      left: stepWidth / 2,
                      width: currentIndex <= 0
                          ? 0
                          : stepWidth * currentIndex,
                      child: Container(
                        height: 2,
                        color: AppColors.primary,
                      ),
                    ),

                    /// STEPS
                    Row(
                      children: List.generate(steps.length, (index) {
                        final isCompleted =
                            currentIndex >= 0 && index <= currentIndex;

                        return Expanded(
                          child: Column(
                            children: [
                              /// CIRCLE
                              _buildCircle(index, currentIndex),

                              const SizedBox(height: 8),

                              /// TITLE
                              Text(
                                steps[index]["title"]!,
                                textAlign: TextAlign.center,
                                style: TextStyles.f8w600mGray9.copyWith(
                                  color: isCompleted
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 4),

                              /// DATE
                              Text(
                                steps[index]["date"]!,
                                textAlign: TextAlign.center,
                                style: TextStyles.f7w400mGray6,
                              ),

                              const SizedBox(height: 4),

                              /// VIEW BUTTON (only if completed)
                              // if (steps[index]["date"]!.isNotEmpty)
                              //   GestureDetector(
                              //     onTap: () {
                              //       debugPrint("View clicked: $index");
                              //     },
                              //     child: Text(
                              //       "View",
                              //       style: TextStyle(
                              //         fontSize: 11,
                              //         color: AppColors.primary,
                              //         decoration: TextDecoration.underline,
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ CIRCLE UI
  Widget _buildCircle(int index, int currentIndex) {
    if (index < currentIndex) {
      return Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 12, color: Colors.white),
      );
    } else if (index == currentIndex) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 4),
        ),
      );
    } else {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 4),
        ),
      );
    }
  }

  /// ✅ MAP STATUS
  String _mapStatus(String status) {
    switch (status) {
      case "SHIFTING_STARTED":
        return "Shifting Started";
      case "PICKUP_COMPLETED":
        return "Pickup Completed";
      case "SHIFTING_COMPLETED":
        return "Shifting Completed";
      case "SETTLED":
        return "Settled";
      default:
        return status;
    }
  }

  /// ✅ FORMAT DATE
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
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
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
*/



// class ShipmentStatusStepper extends StatelessWidget {
//   final int currentStep;
//
//   const ShipmentStatusStepper({super.key, required this.currentStep});
//
//   @override
//   Widget build(BuildContext context) {
//     final steps = [
//       {
//         "title": "Shifting Started",
//         "date": "Jan 12, 2026 6:07 pm",
//       },
//       {
//         "title": "Pickup Completed",
//         "date": "Jan 14, 2026 11:25 am",
//       },
//       {
//         "title": "Shifting Completed",
//         "date": "Jan 16, 2026 4:32 pm",
//       },
//       {
//         "title": "Settled",
//         "date": "Feb 5, 2026 7:08 am",
//       },
//     ];
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// TITLE
//           Text("Shipment Status", style: TextStyles.f12w600Gray9),
//
//           const SizedBox(height: 16),
//
//           SizedBox(
//             height: 80,
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 final totalWidth = constraints.maxWidth;
//                 final stepWidth = totalWidth / steps.length;
//
//                 return Stack(
//                   children: [
//                     /// 🔥 FULL GREY LINE (center aligned with circles)
//                     Positioned(
//                       top: 10,
//                       left: stepWidth / 2,
//                       right: stepWidth / 2,
//                       child: Container(
//                         height: 2,
//                         color: const Color(0xFFE0E0E0),
//                       ),
//                     ),
//
//                     /// 🔥 ACTIVE BLUE LINE (CENTER → CENTER FIXED)
//                     Positioned(
//                       top: 10,
//                       left: stepWidth / 2,
//                       width: stepWidth * currentStep,
//                       child: Container(
//                         height: 2,
//                         color: AppColors.primary,
//                       ),
//                     ),
//
//                     /// STEPS
//                     Row(
//                       children: List.generate(steps.length, (index) {
//                         return Expanded(
//                           child: Column(
//                             children: [
//                               /// CIRCLE
//                               Transform.translate(
//                                 offset: const Offset(0, -2),
//                                 child: _buildCircle(index),
//                               ),
//
//                               const SizedBox(height: 8),
//
//                               /// TITLE
//                               Text(
//                                 steps[index]["title"]!,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyles.f8w600mGray9.copyWith(
//                                   color: index <= currentStep
//                                       ? AppColors.primary
//                                       : Colors.black,
//                                 ),
//                               ),
//
//                               const SizedBox(height: 4),
//
//                               /// DATE
//                               Text(
//                                 steps[index]["date"]!,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyles.f7w400mGray6,
//                               ),
//
//                               const SizedBox(height: 4),
//
//                               /// 🔥 VIEW ONLY FOR COMPLETED + CURRENT
//                               if (index <= currentStep)
//                                 GestureDetector(
//                                   onTap: () {
//                                     debugPrint("View clicked: $index");
//                                   },
//                                   child: Text(
//                                     index == currentStep
//                                         ? "View"
//                                         : "View",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w500,
//                                       decoration:
//                                       TextDecoration.underline,
//                                       decorationColor:
//                                       AppColors.primary,
//                                       decorationThickness: 1.5,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCircle(int index) {
//     if (index < currentStep) {
//       return Container(
//         width: 20,
//         height: 20,
//         decoration: const BoxDecoration(
//           color: AppColors.primary,
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(Icons.check, size: 12, color: Colors.white),
//       );
//     } else if (index == currentStep) {
//       return Container(
//         width: 20,
//         height: 20,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: AppColors.primary,
//             width: 5,
//           ),
//         ),
//       );
//     } else {
//       return Container(
//         width: 20,
//         height: 20,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: const Color(0xFFE0E0E0),
//             width: 5,
//           ),
//         ),
//       );
//     }
//   }
// }