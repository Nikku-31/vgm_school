import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  // load when app starts
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString("lang_code");

    if (code != null) {
      _locale = Locale(code);
    }
    notifyListeners();
  }

  // change language
  Future<void> changeLanguage(String code) async {
    _locale = Locale(code);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lang_code", code);

    notifyListeners();
  }
}