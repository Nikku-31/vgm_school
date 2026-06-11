import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/AttendanceM/student_attendance_model.dart';

class StudentAttendanceService {
  Future<List<StudentAttendanceModel>> getAttendanceList(
      int studentId, String fromDate, String toDate) async {
    try {
      final String url =
          "${ApiConstants.studentAttendanceStatus}?studentId=$studentId&fromDate=$fromDate&toDate=$toDate";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List)
            .map((e) => StudentAttendanceModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("ERROR: $e");
      return [];
    }
  }
}