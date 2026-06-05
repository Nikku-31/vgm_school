import 'package:flutter/material.dart';
import '../../Model/HomeWorkM/hw_model.dart';
import '../../Service/Home_WorkS/hw_service.dart';

class HwViewModel extends ChangeNotifier {
  final HwService _service = HwService();

  List<HwModel> _homeworks = [];
  List<HwModel> get homeworks => _homeworks;

  bool isLoading = false;
  String? errorMessage;

  /// 🔥 Get Homework (Dynamic API Call)
  Future<void> getHomework({
    required int classId,
    required int sectionId,
    required String date,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _service.fetchHomework(
        classId: classId,
        sectionId: sectionId,
        date: date,
      );

      _homeworks = result;
    } catch (e) {
      errorMessage = e.toString();
      print("ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 📅 Filter Homework by Selected Date (UI use ke liye)
  List<HwModel> filterByDate(DateTime selectedDate) {
    return _homeworks.where((hw) {
      return hw.date.year == selectedDate.year &&
          hw.date.month == selectedDate.month &&
          hw.date.day == selectedDate.day;
    }).toList();
  }

  /// 🔄 Refresh API (same params ke saath dobara call)
  Future<void> refreshHomework({
    required int classId,
    required int sectionId,
    required String date,
  }) async {
    await getHomework(
      classId: classId,
      sectionId: sectionId,
      date: date,
    );
  }

  /// 🧹 Clear Data (optional use)
  void clearHomework() {
    _homeworks = [];
    notifyListeners();
  }
}