import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../AppManager/ViewModel/HomeWorkVM/hw_viewm.dart';
import '../core/constants/app_colors.dart';
import '../AppManager/ViewModel/AccountVM/student_details_view_model.dart';

class HomeWork extends StatefulWidget {
  const HomeWork({super.key});

  @override
  State<HomeWork> createState() => _HomeWorkState();
}

class _HomeWorkState extends State<HomeWork> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final studentVM =
      Provider.of<StudentDetailViewModel>(context, listen: false);

      // Agar student details load nahi hui hain to pehle load karo
      if (studentVM.student == null) {
        await studentVM.getStudentDetails();
      }

      if (studentVM.student != null) {
        Provider.of<HwViewModel>(context, listen: false).getHomework(
          classId: studentVM.student!.classId,
          sectionId: studentVM.student!.sectionId,
          date:
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
        );
      }
    });
  }
  String getMonthName(int month) {
    const months = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HwViewModel>(
      builder: (context, vm, child) {

        final filteredHomework = vm.filterByDate(_selectedDay);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              "Home Work",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  color: AppColors.primary
              ),
            ),
          ),
          body: Column(
            children: [

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${getMonthName(_focusedDay.month)} ${_focusedDay.year}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _calendarFormat =
                        _calendarFormat == CalendarFormat.week
                            ? CalendarFormat.month
                            : CalendarFormat.week;
                      });
                    },
                    child: Icon(
                      _calendarFormat == CalendarFormat.week
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      size: 26,
                    ),
                  ),
                ],
              ),
              // Calendar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TableCalendar(
                  firstDay: DateTime.utc(2001),
                  lastDay: DateTime.utc(2030),
                  focusedDay: _focusedDay,
                  headerVisible: false,
                  calendarFormat: _calendarFormat,

                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },

                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    final studentVM =
                    Provider.of<StudentDetailViewModel>(context, listen: false);

                    String formattedDate =
                        "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";

                    Provider.of<HwViewModel>(context, listen: false).getHomework(
                      classId: studentVM.student!.classId,
                      sectionId: studentVM.student!.sectionId,
                      date: formattedDate,
                    );
                  },
                  calendarStyle:  CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF42A5F5),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFFAB47BC),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle:  TextStyle(color: Colors.white),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Homework List
              Expanded(
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredHomework.isEmpty
                    ? const Center(
                  child: Text(
                    "No Homework this Date",
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredHomework.length,
                  itemBuilder: (context, index) {
                    final hw = filteredHomework[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${hw.subjectName} - ${hw.title}",
                                style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text("Remarks: ${hw.remarks}"),
                              const SizedBox(height: 6),
                              Text(
                                "Class: ${hw.className} | Section: ${hw.sectionName}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
