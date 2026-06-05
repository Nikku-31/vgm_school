import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';
import '../../Model/AccountM/student_info_model.dart';

class StudentDetailService {
  Future<StudentDetailModel> fetchStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt('user_id') ?? 0;

    final response = await http.get(Uri.parse("${ApiConstants.GetStudentInfoById}?id=$userId"),);
    if (response.statusCode == 200) {
      return StudentDetailModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load student details");
    }
  }
}
