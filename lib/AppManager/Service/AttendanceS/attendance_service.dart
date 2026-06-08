import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/AttendanceM/attendance_model.dart';

class AttendanceService {
  Future<AttendanceModel?> getAttendance(int studentId, String date) async {
    try {
      final String url =
          "${ApiConstants.getStudentAttendance}?studentId=$studentId&date=$date";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          return AttendanceModel.fromJson(data[0]);
        } else if (data is Map<String, dynamic>) {
          return AttendanceModel.fromJson(data);
        }
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}