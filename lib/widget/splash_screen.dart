import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/AccountVM/send_login_viewModel.dart';
import '../widget/dashboard.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final String? studentJson = prefs.getString('student_data');

    if (!mounted) return;

    if (studentJson != null) {

      // Restore student in memory
      await Provider.of<SendLoginViewModel>(context, listen: false)
          .loadSavedProfile();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const Dashboard(),
        ),
      );

    } else {

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/image/img.png'),
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}