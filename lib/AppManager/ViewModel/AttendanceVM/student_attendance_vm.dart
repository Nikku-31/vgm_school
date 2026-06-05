import 'package:flutter/material.dart';
import '../../Model/AttendanceM/student_attendance_model.dart';
import '../../Service/AttendanceS/student_attendance_service.dart';

class StudentAttendanceVM extends ChangeNotifier {
  final StudentAttendanceService _service = StudentAttendanceService();

  List<StudentAttendanceModel> attendanceList = [];
  bool isLoading = false;

  // 🔥 Fetch range data
  Future<void> fetchAttendanceList(
      int studentId, DateTime from, DateTime to) async {
    isLoading = true;
    notifyListeners();

    try {
      String format(DateTime d) =>
          "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

      final data = await _service.getAttendanceList(
        studentId,
        format(from),
        format(to),
      );

      attendanceList = data; // ✅ safe assign
    } catch (e) {
      debugPrint("Student Attendance API Error: $e");
      attendanceList = []; // ✅ fallback
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔹 Get status for selected day
  String? getStatusForDay(DateTime day) {
    try {
      for (var item in attendanceList) {
        if (item.date.year == day.year &&
            item.date.month == day.month &&
            item.date.day == day.day) {
          return item.status;
        }
      }
    } catch (e) {
      debugPrint("Status Error: $e");
    }
    return null;
  }

  // 🔥 Monthly percentage
  double getMonthlyAttendancePercentage(DateTime month) {
    if (attendanceList.isEmpty) return 0;

    int totalDays = 0;
    int presentDays = 0;

    for (var item in attendanceList) {
      if (item.date.month == month.month &&
          item.date.year == month.year) {
        totalDays++;

        if (item.status == "P") {
          presentDays++;
        }
      }
    }

    if (totalDays == 0) return 0;

    return (presentDays / totalDays) * 100;
  }
}