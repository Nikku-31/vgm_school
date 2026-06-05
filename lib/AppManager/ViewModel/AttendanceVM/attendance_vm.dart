import 'package:flutter/material.dart';
import 'dart:convert'; // jsonEncode ke liye
import '../../Model/AttendanceM/attendance_model.dart';
import '../../Service/AttendanceS/attendance_service.dart';

class AttendanceVM extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();

  AttendanceModel? attendance;
  bool isLoading = false;
  List<AttendanceModel> monthlyData = [];

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> fetchAttendance(int studentId, DateTime date) async {
    isLoading = true;
    notifyListeners();
    try {
      String formattedDate = _formatDate(date);
      attendance = await _service.getAttendance(studentId, formattedDate);
    } catch (e) {
      debugPrint("Single API Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔥 Monthly API - Ab sirf EK baar print karega
  Future<void> fetchMonthlyAttendance(int studentId, DateTime month) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      monthlyData.clear();

      DateTime firstDay = DateTime(month.year, month.month, 1);
      DateTime lastDay = DateTime(month.year, month.month + 1, 0);

      List<Future<AttendanceModel?>> requests = [];

      for (int i = 0; i < lastDay.day; i++) {
        DateTime day = firstDay.add(Duration(days: i));
        String formattedDate = _formatDate(day);
        requests.add(_service.getAttendance(studentId, formattedDate));
      }

      // ✅ Parallel calls (Intezaar karega saari 30 calls khatam hone ka)
      final results = await Future.wait(requests);
      monthlyData = results.whereType<AttendanceModel>().toList();

      // 🔥 EK BAR PRINT: URL aur Poora Response JSON format mein
      if (monthlyData.isNotEmpty) {
        String sampleUrl = "https://dbs.online-tech.in/api/StudentApi/GetStudentAttendance?studentId=$studentId&date=${_formatDate(firstDay)}";

        // Saare records ko ek map mein convert karke dikhane ke liye
        List<Map<String, dynamic>> rawResponse = monthlyData.map((e) => {
          "date": _formatDate(e.date),
          "status": e.status
        }).toList();

        debugPrint("-----------------------------------------------------------------------");
        debugPrint("📡 API URL (Sample): $sampleUrl");
        debugPrint("📥 TOTAL RESPONSE: ${jsonEncode(rawResponse)}"); // Poora data ek line mein
        debugPrint("📊 STATUS: Data loaded for Student $studentId | Total: ${monthlyData.length}");
        debugPrint("-----------------------------------------------------------------------");
      }

    } catch (e) {
      debugPrint("❌ Monthly API Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? getStatusForDay(DateTime day) {
    if (monthlyData.isEmpty) return null;
    try {
      final record = monthlyData.firstWhere(
            (item) =>
        item.date.year == day.year &&
            item.date.month == day.month &&
            item.date.day == day.day,
        orElse: () => AttendanceModel(studentId: 0, date: day, status: ""),
      );
      return record.status.isEmpty ? null : record.status;
    } catch (e) {
      return null;
    }
  }
}