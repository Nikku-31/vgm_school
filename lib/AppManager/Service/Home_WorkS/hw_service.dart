import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/HomeWorkM/hw_model.dart';

class HwService {

  Future<List<HwModel>> fetchHomework({
    required int classId,
    required int sectionId,
    required String date,
  }) async {

    final uri = Uri.parse(
        "${ApiConstants.GetStudentHomework}?classId=$classId&SectionId=$sectionId&Date=$date"
    );

    print("REQUEST URL: $uri");

    final response = await http.get(uri);

    print("RESPONSE STATUS: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => HwModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load homework");
    }
  }
}