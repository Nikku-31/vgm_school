import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_new/core/constants/api_constants.dart';
import '../../Model/AccountM/send_login_model.dart';

class SendLoginService {
  static const String _url =(ApiConstants.login);

  static Future<SendLoginResponse> login(
      SendLoginRequest request) async {

    final uri = Uri.parse(_url);

    print("🔹 LOGIN API URL: $uri");
    print("🔹 REQUEST BODY: ${jsonEncode(request.toJson())}");


    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("🔹 STATUS CODE: ${response.statusCode}");
    print("🔹 RESPONSE BODY: ${response.body}");
    print("🔹 STATUS CODE: ${response.statusCode}");
    print("🔹 HEADERS: ${response.headers}");

    if (response.statusCode == 200) {
      return SendLoginResponse.fromJson(
        jsonDecode(response.body), // ✅ FIX
      );
    } else {
      throw Exception("Login failed");
    }
  }
}