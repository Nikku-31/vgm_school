import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/DashboardM/dashboard_model.dart';

class DashboardService {
  Future<List<DashboardModel>> getDashboard() async {
    final response =
    await http.get(Uri.parse(ApiConstants.GetAppDashboard));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((e) => DashboardModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load dashboard");
    }
  }
}