import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/HomeWorkM/upcoming_classes_model.dart';

class UpcomingClassesService {

  Future<List<UpcomingClassesModel>>
  getUpcomingClasses(int studentId) async {

    final response = await http.get(
      Uri.parse(
        "https://vgm.online-tech.in/api/StudentApi/UpComingClassess?StudentId=$studentId",
      ),
    );

    if (response.statusCode == 200) {

      final List jsonData =
      jsonDecode(response.body);

      return jsonData
          .map((e) =>
          UpcomingClassesModel.fromJson(e))
          .toList();
    }

    return [];
  }
}