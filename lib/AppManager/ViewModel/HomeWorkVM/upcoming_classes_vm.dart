import 'package:flutter/material.dart';
import '../../Model/HomeWorkM/upcoming_classes_model.dart';
import '../../Service/Home_WorkS/upcoming_classes_service.dart';

class UpcomingClassesVM extends ChangeNotifier {

  final UpcomingClassesService _service =
  UpcomingClassesService();

  bool isLoading = false;

  List<UpcomingClassesModel> classes = [];

  Future<void> fetchUpcomingClasses(
      int studentId) async {

    isLoading = true;
    notifyListeners();

    try {

      classes = await _service
          .getUpcomingClasses(studentId);

    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}