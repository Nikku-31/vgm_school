import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../Model/FeedbackM/feedback_model.dart';

class FeedbackService {
  Future<bool> saveFeedback(FeedbackModel feedback) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.saveStudentFeedback),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(feedback.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["succeeded"] == true;
      }

      return false;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}