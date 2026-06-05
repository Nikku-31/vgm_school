import 'package:flutter/material.dart';
import '../../Model/TimeTableM/tb_model.dart';
import '../../Service/TimeTableS/tb_service.dart';

class TbViewModel extends ChangeNotifier {

  final TbService _service = TbService();

  List<TbModel> _timeTable = [];
  bool _isLoading = false;

  List<TbModel> get timeTable => _timeTable;
  bool get isLoading => _isLoading;

  Future<void> fetchTimeTable(int stdId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _timeTable = await _service.getTimeTable(stdId);
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Group by day
  Map<String, List<TbModel>> get groupedByDay {
    Map<String, List<TbModel>> data = {};

    for (var item in _timeTable) {
      if (!data.containsKey(item.day)) {
        data[item.day] = [];
      }
      data[item.day]!.add(item);
    }

    return data;
  }
}
