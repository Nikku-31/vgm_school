import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/TimeTableM/tb_model.dart';

class TbService {

  Future<List<TbModel>> getTimeTable(int stdId) async {

    final url = Uri.parse("${ApiConstants.GetTimeTableByClass}?StdId=$stdId");

    print("TimeTable URI: $url");

    final response = await http.get(url);

    print("TimeTable Response: ${response.body}");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => TbModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load TimeTable");
    }
  }
}
