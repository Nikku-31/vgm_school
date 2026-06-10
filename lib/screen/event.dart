import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../AppManager/ViewModel/EventVM/event_vm.dart';
import '../core/constants/app_colors.dart';

class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EventViewModel>().fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(
        builder: (context, vm, child) {
          final selectedEvents = vm.getEventsForDay(_selectedDay);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              iconTheme: IconThemeData(color: AppColors.background),
              title: Text(
                "Event",
                style: GoogleFonts.poppins(color: AppColors.background),
              ),
            ),
            body: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2035),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  eventLoader: (day) {
                    return vm.getEventsForDay(day);
                  },

                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },

                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),

                  calendarStyle: CalendarStyle(
                    todayDecoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Date: ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (vm.isLoading)
                        const CircularProgressIndicator()
                      else if (selectedEvents.isNotEmpty)
                        Text(
                          selectedEvents.first.eventTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        )
                      else
                        const Text("No Events"),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
