import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../AppManager/ViewModel/AccountVM/change_password_view_model.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import 'app_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final ChangePasswordViewModel _viewModel = ChangePasswordViewModel();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool oldObscure = true;
  bool newObscure = true;
  bool confirmObscure = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {});

      try {
        final message = await _viewModel.updatePassword(
          oldPasswordController.text.trim(),
          newPasswordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message ?? "Password changed successfully",
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: const Color(0xFFAB47BC),
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceAll("Exception: ", ""),
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) setState(() {});
      }
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(AppStrings.get(context, 'change_password'),
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: AppColors.primary
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  AppStrings.get(context, 'Your password must be at least 6 characters and should include a combination of numbers, letters and special characters (!\$@%).,'),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 40),

                _buildField(
                  controller: oldPasswordController,
                  hint:  AppStrings.get(context, 'current_password'),
                  obscure: oldObscure,
                  onToggle: () => setState(() => oldObscure = !oldObscure),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return  AppStrings.get(context, 'enter_old_password');
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                _buildField(
                  controller: newPasswordController,
                  hint: AppStrings.get(context, 'new_password'),
                  obscure: newObscure,
                  onToggle: () => setState(() => newObscure = !newObscure),
                  validator: (v) {if (v == null || v.isEmpty) {
                    return AppStrings.get(context, 'enter_password');
                  }
                  return null;
                  },
                ),

                const SizedBox(height: 20),
                _buildField(
                  controller: confirmPasswordController,
                  hint: AppStrings.get(context, 'confirm_password'),
                  obscure: confirmObscure,
                  onToggle: () => setState(() => confirmObscure = !confirmObscure),
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return AppStrings.get(context, 'password_not_match');
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                //Confirm Change Button
                _viewModel.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF42A5F5),
                  ),
                )
                    : AppButton(
                  title2: AppStrings.get(context, 'confirm_change'),
                  onPress1: _handleChangePassword,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}