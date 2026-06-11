import 'package:flutter/material.dart';
import '../../Model/FeedbackM/feedback_model.dart';
import '../../Service/FeedbackS/feedback_service.dart';

class FeedbackViewModel extends ChangeNotifier {
  final FeedbackService _service = FeedbackService();

  bool isLoading = false;

  Future<bool> submitFeedback({
    required int studentId,
    required String title,
    required String description,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final feedback = FeedbackModel(
        studentId: studentId,
        title: title,
        description: description,
        createdDate: DateTime.now().toIso8601String(),
      );

      final result = await _service.saveFeedback(feedback);

      isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}