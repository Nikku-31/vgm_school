import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/AccountM/change_password_model.dart';
import '../../Service/AccountS/change_password_service.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final ChangePasswordService _service = ChangePasswordService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String?> updatePassword(String oldPass, String newPass) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('user_id');

      if (userId == null) throw Exception("User session not found");

      final request = ChangePasswordRequest(
        studentId: userId,
        oldPassword: oldPass,
        newPassword: newPass,
      );

      final response = await _service.changePassword(request);
      _isLoading = false;
      notifyListeners();
      return response.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}