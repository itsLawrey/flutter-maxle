import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/app_provider.dart';
import 'day_workouts_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text('HISTORY', style: GoogleFonts.outfit(letterSpacing: 1.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) async {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DayWorkoutsScreen(selectedDate: selectedDay),
                      ),
                    );
                    if (mounted) {
                      setState(() {
                        _selectedDay = null;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    weekendTextStyle: const TextStyle(color: Colors.white60),
                    todayDecoration: BoxDecoration(
                      color: const Color(0xFFBB86FC).withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xFF03DAC6),
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: Color(0xFF03DAC6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    formatButtonVisible: false,
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                  eventLoader: (day) {
                    return [];
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      return null;
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      return _buildDayCell(context, day, provider);
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return _buildDayCell(
                        context,
                        day,
                        provider,
                        isToday: true,
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return _buildDayCell(
                        context,
                        day,
                        provider,
                        isSelected: true,
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      // Optional: dim outside days
                      return null;
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    AppProvider provider, {
    bool isToday = false,
    bool isSelected = false,
  }) {
    Color? bgColor;
    Color textColor = Colors.white;
    BoxBorder? border;

    if (provider.isMonthComplete(day)) {
      // Diamond look: Cyan
      bgColor = Colors.cyanAccent.withValues(alpha: 0.2);
      border = Border.all(color: Colors.cyanAccent, width: 2);
      textColor = Colors.cyanAccent;
    } else if (provider.isWeekComplete(day)) {
      // Golden look: Amber
      bgColor = Colors.amber.withValues(alpha: 0.2);
      border = Border.all(color: Colors.amber, width: 2);
      textColor = Colors.amber;
    } else if (provider.isDayComplete(day)) {
      // Regular check-in: Orange
      bgColor = Colors.deepOrange.withValues(alpha: 0.2);
      border = Border.all(color: Colors.deepOrange, width: 2);
      textColor = Colors.deepOrange;
    } else if (isSelected) {
      bgColor = const Color(0xFF03DAC6).withValues(alpha: 0.3);
      border = Border.all(color: const Color(0xFF03DAC6));
    } else if (isToday) {
      // No background for today, handled with dot below
    }

    Widget cellContent = Text(
      '${day.day}',
      style: GoogleFonts.outfit(color: textColor, fontWeight: FontWeight.bold),
    );

    if (isToday) {
      cellContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          cellContent,
          const SizedBox(height: 4),
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF03DAC6),
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: cellContent,
    );
  }
}
