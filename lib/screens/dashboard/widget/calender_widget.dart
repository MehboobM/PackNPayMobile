import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {

  DateTime visibleMonth = DateTime.now();
  DateTimeRange? selectedRange;

  final int baseYear = 2000;

  late PageController controller;

  @override
  void initState() {
    super.initState();

    int initialPage =
        (DateTime.now().year - baseYear) * 12 + DateTime.now().month;

    controller = PageController(initialPage: initialPage);
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

      bool isGreenDay = day == 1;
      bool isPinkDay = day == 18;

      bool isToday =
          date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

      Widget cell;

      if (isGreenDay) {
        cell = Container(
          height: 60,
          color: const Color(0xff7CF2A1),
          child: Stack(
            children: [
              Positioned(
                top: 6,
                left: 6,
                child: Text(
                  DateFormat("MMMM d").format(date),
                  style: const TextStyle(fontSize: 11,color: Colors.black54),
                ),
              ),
              const Center(
                child: Text(
                  "10/10",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
                ),
              )
            ],
          ),
        );
      }
      else if (isPinkDay) {
        cell = Container(
          height: 60,
          color: const Color(0xffF3D6DA),
          child: Stack(
            children: [
              Positioned(
                top: 6,
                left: 6,
                child: Text(
                  DateFormat("MMMM d").format(date),
                  style: const TextStyle(fontSize: 11,color: Colors.black54),
                ),
              ),
              const Center(
                child: Text(
                  "10/10",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
                ),
              )
            ],
          ),
        );
      }
      else {
        cell = Container(
          height: 60,
          padding: const EdgeInsets.only(top: 6,left: 6),
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
            style: GoogleFonts.inter(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: isToday ? const Color(0xff2F2D7E) : Colors.grey,
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
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              GestureDetector(
                onTap: () async {

                  DateTimeRange? picked =
                  await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {

                    selectedRange = picked;

                    int page =
                        (picked.start.year - baseYear) * 12 + picked.start.month;

                    controller.animateToPage(
                      page,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );

                    setState(() {
                      visibleMonth =
                          DateTime(picked.start.year, picked.start.month);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xffE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,size: 16),
                      const SizedBox(width: 6),

                      Text(
                        selectedRange == null
                            ? "Select Range"
                            : "${DateFormat('MMM dd, yyyy').format(selectedRange!.start)} - ${DateFormat('MMM dd, yyyy').format(selectedRange!.end)}",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down,size: 18)
                    ],
                  ),
                ),
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

                /// MONTH SCROLL
                SizedBox(
                  height: 290,
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: controller,
                    onPageChanged: (index){

                      int year = baseYear + (index ~/ 12);
                      int month = (index % 12) + 1;

                      setState(() {
                        visibleMonth = DateTime(year, month);
                      });
                    },
                    itemBuilder: (context,index){

                      int year = baseYear + (index ~/ 12);
                      int month = (index % 12) + 1;

                      DateTime monthDate = DateTime(year, month);

                      return Table(
                        border: const TableBorder(
                          horizontalInside: BorderSide(color: Color(0xffECECEC)),
                          verticalInside: BorderSide(color: Color(0xffECECEC)),
                        ),
                        children: buildCalendar(monthDate),
                      );
                    },
                  ),
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
      style: GoogleFonts.inter(
        fontSize: 8,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}