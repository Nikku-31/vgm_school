import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/AccountM/send_login_model.dart';
import '../../Service/AccountS/send_login_service.dart';

class SendLoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  Student? student;


  /// ✅ CALL THIS IN DASHBOARD OR PROFILE INIT
  Future<void> loadSavedProfile() async {
    if (student != null) return; // Data already in memory

    final prefs = await SharedPreferences.getInstance();
    final String? studentJson = prefs.getString('student_data');

    if (studentJson != null) {
      student = Student.fromJson(jsonDecode(studentJson));
      notifyListeners();
      debugPrint("Profile restored from local storage.");
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // ✅ Get FCM Token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM TOKEN: $fcmToken");

      final request = SendLoginRequest(
        username: username,
        password: password,
        deviceToken: fcmToken ?? "deviceToken",
      );
      final response = await SendLoginService.login(request);

      // If API says login failed
      if (response.message.contains("Invalid") || response.student == null) {
        errorMessage = response.message;
        return false;
      }

      student = response.student;

      // Wrap storage in its own try-catch so it doesn't trigger "Internet Error"
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', student!.studentId);
        await prefs.setInt('add_no', student!.admissionNo);
        await prefs.setString('student_data', jsonEncode(student!.toJson()));
      } catch (storageError) {
        debugPrint("Storage failed: $storageError");
        // We don't necessarily return false here because the login DID succeed
      }

      return true;
    } on http.ClientException {
      errorMessage = "Network error. Please check your connection.";
      return false;
    } catch (e) {
      // This catches everything else (parsing errors, null pointers, etc.)
      errorMessage = "An unexpected error occurred: $e";
      debugPrint("Login Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('student_data');
    student = null;
    notifyListeners();
  }
}