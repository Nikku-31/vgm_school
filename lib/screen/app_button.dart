import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title2;
  final VoidCallback onPress1;

  const AppButton({
    super.key,
    required this.title2,
    required this.onPress1,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress1,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: double.infinity,
          height: 50, // Explicit height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              title2,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}