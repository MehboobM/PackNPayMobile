import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../repositry/Dashboard_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  Map<String, int> calendarEvents = {};
  bool isLoading = false;

  DateTime visibleMonth = DateTime.now();
  DateTimeRange? selectedRange;

  List<DateTime> monthsToShow = [];

  late PageController controller;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();

    /// SHOW CURRENT MONTH BY DEFAULT
    visibleMonth = DateTime(now.year, now.month);

    monthsToShow = [
      DateTime(now.year, now.month)
    ];

    controller = PageController(initialPage: 0);
    fetchCalendar(visibleMonth);
  }
  Future<void> fetchCalendar(DateTime month) async {
    try {
      setState(() => isLoading = true);

      final data = await DashboardService().getCalendarData(
        year: month.year,
        month: month.month,
      );

      setState(() {
        calendarEvents = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  List<DateTime> getMonthDays(DateTime month) {
    int days = DateTime(month.year, month.month + 1, 0).day;

    return List.generate(
      days,
          (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  List<TableRow> buildCalendar(DateTime month) {

    List<DateTime> days = getMonthDays(month);

    List<TableRow> rows = [];
    List<Widget> cells = [];

    int startWeekday = days.first.weekday % 7;

    for (int i = 0; i < startWeekday; i++) {
      cells.add(Container(height: 60));
    }

    for (var date in days) {

      int day = date.day;

      String key =
          "${date.year.toString().padLeft(4, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.day.toString().padLeft(2, '0')}";

      int? count = calendarEvents[key];

      bool isToday =
          date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

      Widget cell;

      if (count != null && count > 0) {
        cell = Container(
          height: 60,
          color: const Color(0xff7CF2A1),
          child: Stack(
            children: [
              Positioned(
                top: 6,
                left: 6,
                child: Text(
                  DateFormat("MMM d").format(date),
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ),
              Center(
                child: Text(
                  "$count/10",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              )
            ],
          ),
        );
      }
      else {
        cell = Container(
          height: 60,
          padding: const EdgeInsets.only(top: 6, left: 6),
          decoration: isToday
              ? BoxDecoration(
            border: Border.all(
              color: const Color(0xff2F2D7E),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
          )
              : null,
          child: Text(
            "${date.day}",
            style: TextStyles.f8w500mWhite.copyWith(
              color: AppColors.mGray5,
            ),
          ),
        );
      }

      cells.add(cell);

      if (cells.length == 7) {
        rows.add(TableRow(children: List.from(cells)));
        cells.clear();
      }
    }

    if (cells.isNotEmpty) {
      while (cells.length < 7) {
        cells.add(Container());
      }
      rows.add(TableRow(children: cells));
    }

    return rows;
  }

  /// GENERATE MONTH LIST FROM RANGE
  List<DateTime> generateMonths(DateTime start, DateTime end) {

    List<DateTime> months = [];

    DateTime current = DateTime(start.year, start.month);
    DateTime last = DateTime(end.year, end.month);

    while (current.isBefore(last) || current.isAtSameMomentAs(last)) {
      months.add(current);
      current = DateTime(current.year, current.month + 1);
    }

    return months;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        /// HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                DateFormat('MMMM, yyyy').format(visibleMonth),
                style: TextStyles.f14w600Primary.copyWith(
                  color: AppColors.mGray9,
                )
              ),

              Row(
                children: [

                  /// SELECT RANGE
                  GestureDetector(
                    onTap: () async {
                      DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        List<DateTime> months =
                        generateMonths(picked.start, picked.end);

                        setState(() {
                          selectedRange = picked;
                          monthsToShow = months;
                          visibleMonth = months.first;
                          controller = PageController(initialPage: 0);
                        });

                        fetchCalendar(visibleMonth);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            selectedRange == null
                                ? "Select Range"
                                : "${DateFormat('MMM dd, yyyy').format(selectedRange!.start)} - ${DateFormat('MMM dd, yyyy').format(selectedRange!.end)}",
                            style: TextStyles.f11w600mWhite.copyWith(
                              color: AppColors.mGray9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// RESET BUTTON
                  if (selectedRange != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRange = null;
                          monthsToShow = [DateTime.now()];
                          visibleMonth = monthsToShow.first;
                          controller = PageController(initialPage: 0);
                        });

                        fetchCalendar(visibleMonth);
                      },
                      child: const Icon(Icons.close, size: 20),
                    )
                ],
              )
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// CALENDAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xffE5E7EB)),
            ),
            child: Column(
              children: [

                /// WEEK HEADER
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xff2F2D7E),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _WeekText("SUN"),
                      _WeekText("MON"),
                      _WeekText("TUE"),
                      _WeekText("WED"),
                      _WeekText("THU"),
                      _WeekText("FRI"),
                      _WeekText("SAT"),
                    ],
                  ),
                ),

                /// MONTH VIEW
                SizedBox(
                    height: 290,
                    child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: controller,
                      itemCount: monthsToShow.length,
                      onPageChanged: (index) {
                        setState(() {
                          visibleMonth = monthsToShow[index];
                        });

                        fetchCalendar(visibleMonth); // ✅ ADD THIS
                      },
                      itemBuilder: (context, index) {

                        DateTime monthDate = monthsToShow[index];

                        return Table(
                          border: const TableBorder(
                            horizontalInside: BorderSide(color: Color(0xffECECEC)),
                            verticalInside: BorderSide(color: Color(0xffECECEC)),
                          ),
                          children: buildCalendar(monthDate),
                        );
                      },
                    )
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _WeekText extends StatelessWidget {

  final String text;

  const _WeekText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.f8w500mWhite,
    );
  }
}