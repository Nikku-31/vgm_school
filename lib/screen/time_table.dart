import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/TimeTableVM/timetable_vm.dart';
import '../core/constants/app_colors.dart';

class TimeTable extends StatelessWidget {
  const TimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TbViewModel()..fetchTimeTable(1),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "Time Table",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: AppColors.primary
            ),
          ),
        ),
        body: Consumer<TbViewModel>(
          builder: (context, vm, child) {

            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.timeTable.isEmpty) {
              return const Center(child: Text("No Data Found"));
            }

            final grouped = vm.groupedByDay;

            return ListView(
              padding: const EdgeInsets.all(10),
              children: grouped.entries.map((entry) {

                return Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// DAY
                        Text(
                          entry.key.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Divider(height: 25),

                        /// PERIOD LIST
                        Column(
                          children: entry.value.map((item) {

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// Class & Section
                                  Text(
                                    "Class: ${item.className}  |  Section: ${item.sectionName}",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  /// Time
                                  Text(
                                    "Time: ${item.fromTime} - ${item.toTime}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  /// Subject
                                  Text(
                                    "Subject: ${item.subjectName}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  /// Teacher
                                  Text(
                                    "Teacher: ${item.employeeName}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  /// IDs small text
                                  Text(
                                    "ID: ${item.id} | ClassId: ${item.classId} | SubjectId: ${item.subjectId} | EmployeeId: ${item.employeeId}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );

                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );

              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
