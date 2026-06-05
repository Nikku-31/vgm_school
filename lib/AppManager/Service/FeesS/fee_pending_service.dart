import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/FeesM/fee_pending_model.dart';

class PendingService {

  Future<List<PendingModel>> fetchPending(int admNo) async {

    final uri = Uri.parse(ApiConstants.StudentMonthlyPendingFee,).replace(queryParameters: {
      "addmissionNo": admNo.toString(),});

    print("REQUEST URI: $uri");
    final response = await http.get(uri);

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {

      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => PendingModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("API Failed");
    }
  }
}