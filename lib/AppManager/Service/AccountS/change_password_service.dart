import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/AccountM/change_password_model.dart';

class ChangePasswordService {

  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) async {
    final Uri uri = Uri.parse(ApiConstants.ChangeStudentPassword);
    final String requestBody = jsonEncode(request.toJson());

    debugPrint("---------- API REQUEST (PUT) ----------");
    debugPrint("URL: $uri");
    debugPrint("BODY: $requestBody");
    debugPrint("---------------------------------------");

    try {
      // ✅ CHANGED http.post to http.put
      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      debugPrint("---------- API RESPONSE ----------");
      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");
      debugPrint("----------------------------------");

      // Check if the body is empty before decoding to avoid FormatException
      if (response.body.isEmpty) {
        if (response.statusCode == 200 || response.statusCode == 204) {
          return ChangePasswordResponse(message: "Password changed successfully.");
        } else {
          throw Exception("Server returned status ${response.statusCode} with no message.");
        }
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChangePasswordResponse.fromJson(data);
      } else {
        throw Exception(data["message"] ?? "Failed to change password");
      }
    } catch (e) {
      debugPrint("---------- API ERROR ----------");
      debugPrint("ERROR: $e");
      debugPrint("-------------------------------");
      rethrow;
    }
  }
}