import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/AccountVM/send_login_viewModel.dart';
import '../core/constants/app_colors.dart';
import '../screen/app_button.dart';
import '../screen/forgor_password.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<String> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token ?? "";
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),

      // ✅ CHANGE: removed outer scroll
      body: Column(
        children: [

          // 🔵 TOP BLUE SECTION (UNCHANGED)
          Container(
            width: double.infinity,
            color: const Color(0xFF3F5DAA),
            padding: const EdgeInsets.only(
                top: 100, left: 30, right: 20, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/image/login.png",
                    height: 200,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Hi Student",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Sign in to continue",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Consumer<SendLoginViewModel>(
                      builder: (context, vm, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40),
                            _buildTextField(
                              controller: userIdController,
                              label: "User Id",
                              icon: Icons.person_outline,
                              validator: (v) =>
                              v!.isEmpty ? "Enter User Id" : null,
                            ),

                            const SizedBox(height: 20),

                            // ✅ SAME FIELD
                            _buildTextField(
                              controller: passwordController,
                              label: "Password",
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscurePassword,
                              toggleVisibility: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              validator: (v) =>
                              v!.isEmpty ? "Enter Password" : null,
                            ),

                            const SizedBox(height: 30),

                            // ✅ SAME BUTTON + SAME LOGIN LOGIC
                            vm.isLoading
                                ? const Center(
                                child: CircularProgressIndicator())
                                : AppButton(
                              title2: "SIGN IN",
                              onPress1: () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await vm.login(
                                    username: userIdController.text,
                                    password: passwordController.text,
                                  );

                                  if (success) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Dashboard(
                                            student: vm.student),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),

                            // ✅ SAME
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                      const ForgotPassword()),
                                ),
                                child: const Text("Forgot Password?"),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ NO CHANGE
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.poppins(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: toggleVisibility,
        )
            : null,
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
      validator: validator,
    );
  }
}