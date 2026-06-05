import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_new/screen/widgets/language_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_colors.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String? selectedLanguage;   //  null initially
  bool isLoading = true;

  final List<String> languages = [
    "English (United States)",
    "Hindi (भारत)"
  ];

  @override
  void initState() {
    super.initState();
    loadSelectedLanguage();
  }

  Future<void> loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString("selected_language");

    setState(() {
      selectedLanguage = savedLanguage ?? languages.first;
      isLoading = false;
    });
  }

  Future<void> saveSelectedLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected_language", language);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(Localizations.localeOf(context).languageCode == 'hi'
            ? "भाषा चुनें"
            : "Select Language",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedLanguage,
              dropdownColor: Colors.white,
              items: languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(
                    language,
                    style: GoogleFonts.poppins(),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                setState(() {
                  selectedLanguage = newValue!;
                });
                await saveSelectedLanguage(newValue!);
                 //change app language
                if (newValue.contains("Hindi")){
                  context.read<LanguageProvider>().changeLanguage('hi');
                } else{
                  context.read<LanguageProvider>().changeLanguage('en');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}