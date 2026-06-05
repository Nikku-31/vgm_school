import 'dart:convert';
import 'package:flutter/material.dart'; // Added for debugPrint
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/FeesM/get_student_fee_model.dart';

class StudentFeeService {
  static Future<StudentFeeResponse> fetchFees(int admissionNo, int month) async {
    // Note: We use the month parameter selected by the user
    final url = Uri.parse("${ApiConstants.GetStudentFeeForMonthYear}?admissionNo=$admissionNo&month=$month&financialYear=2025-2026");
    debugPrint("URL: $url");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return StudentFeeResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load fees');
    }
  }
}