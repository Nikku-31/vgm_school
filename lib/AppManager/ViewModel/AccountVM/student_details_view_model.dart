import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/AccountM/student_info_model.dart';
import '../../Service/AccountS/get_student_info_sevice.dart';

class StudentDetailViewModel extends ChangeNotifier {
  final StudentDetailService _service = StudentDetailService();

  StudentDetailModel? student;
  bool isLoading = false;
  String? errorMessage;
  String? savedContact;

  Future<void>setContactNumber(String number) async{
    savedContact=number;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_contact", number);

    notifyListeners();
  }
  Future<void> loadSavedContact() async {
    final prefs = await SharedPreferences.getInstance();
    savedContact = prefs.getString("saved_contact");

    notifyListeners();
  }
  File? profileImage;
  // SAVE IMAGE PATH
  Future<void> setProfileImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();

    // Permanent file name
    final String newPath = '${directory.path}/profile_image.png';

    // Copy image permanently
    final File newImage = await image.copy(newPath);

    profileImage = newImage;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile_image_path", newPath);

    notifyListeners();
  }
  // LOAD SAVED IMAGE ON APP START
  Future<void> loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    String? imagePath = prefs.getString("profile_image_path");

    if (imagePath != null && File(imagePath).existsSync()) {
      profileImage = File(imagePath);
    }

    savedContact = prefs.getString("saved_contact");

    notifyListeners();
  }
  Future<void> getStudentDetails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      student = await _service.fetchStudentInfo();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
