import 'package:flutter/material.dart';
import '../../Model/DashboardM/dashboard_model.dart';
import '../../Service/DashboardS/dashboard_service.dart';

class DashboardVM extends ChangeNotifier {
  final DashboardService _service = DashboardService();

  List<DashboardModel> dashboardList = [];

  bool isLoading = false;

  Future<void> fetchDashboard() async {
    try {
      isLoading = true;
      notifyListeners();

      dashboardList = await _service.getDashboard();

    } catch (e) {
      print("Dashboard Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}