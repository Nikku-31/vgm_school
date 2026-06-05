import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_new/core/constants/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Added this

import '../AppManager/ViewModel/AttendanceVM/attendance_vm.dart';
import '../AppManager/ViewModel/AttendanceVM/student_attendance_vm.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    _selectedDay = today;
    _focusedDay = today;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAttendanceWithDynamicId(today); // ✅ Dynamic ID function
    });
  }

  // ✅ Helper function to get ID from SharedPreferences and call APIs
  Future<void> _fetchAttendanceWithDynamicId(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final int? sId = prefs.getInt('user_id'); // Using the key you saved at Login

    if (sId != null && mounted) {
      // FIRST API → dots
      context.read<AttendanceVM>().fetchMonthlyAttendance(sId, date);

      // SECOND API → selected date
      context.read<StudentAttendanceVM>().fetchAttendanceList(
        sId,
        DateTime(date.year, date.month, 1),
        DateTime(date.year, date.month + 1, 0),
      );
    } else {
      debugPrint("Error: Student ID not found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.background),
        title: Text(
          "Attendance",
          style: GoogleFonts.poppins(color: AppColors.background),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// 📅 Calendar with loader
          Consumer<AttendanceVM>(
            builder: (context, vm, child) {
              return Stack(
                children: [
                  TableCalendar(
                    firstDay: DateTime(2000),
                    lastDay: DateTime.now(),
                    focusedDay: _focusedDay,

                    selectedDayPredicate: (day) {
                      return _selectedDay != null &&
                          isSameDay(_selectedDay, day);
                    },

                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },

                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });

                      // ✅ Page change par bhi dynamic ID call
                      _fetchAttendanceWithDynamicId(focusedDay);
                    },

                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.5), // Today color slight different
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),

                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// 🔥 DOTS (FIRST API)
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final status = vm.getStatusForDay(day);

                        Color? dotColor;

                        // ✅ Added "P" check to match your VM/Model status
                        if (day.weekday == DateTime.sunday) {
                          dotColor = Colors.blue;
                        } else if (status == "Present" || status == "P") {
                          dotColor = Colors.green;
                        } else if (status == "Absent" || status == "A") {
                          dotColor = Colors.red;
                        } else if (status != null) {
                          dotColor = Colors.orange; // For other statuses
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${day.day}"),
                            if (dotColor != null)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                ],
              );
            },
          ),

          const SizedBox(height: 20),

          /// 📌 Selected Date + Status (SECOND API)
          Consumer<StudentAttendanceVM>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                );
              }

              final status = _selectedDay == null
                  ? null
                  : vm.getStatusForDay(_selectedDay!);

              return Column(
                children: [
                  Text(
                    _selectedDay == null
                        ? "Select a date"
                        : "Selected Date: ${_selectedDay!.day.toString().padLeft(2, '0')}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.year}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (_selectedDay == null)
                    const SizedBox()

                  else if (status == null)
                    Text(
                      "No Record",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    )

                  else
                    Text(
                      (status == "P" || status == "Present")
                          ? "Present"
                          : (status == "A" || status == "Absent")
                          ? "Absent"
                          : "Holiday",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: (status == "P" || status == "Present")
                            ? Colors.green
                            : (status == "A" || status == "Absent")
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}