import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../AppManager/ViewModel/FeedbackVM/feedback_vm.dart';
import '../core/constants/app_colors.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: AppColors.background,
        ),
        title: Text(
          "Feedback",
          style: GoogleFonts.poppins(
            color: AppColors.background,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<FeedbackViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter title";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Description",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter description";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: vm.isLoading
                          ? null
                          : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        /// Dynamic Student Id
                        int studentId = 47;

                        bool success =
                        await vm.submitFeedback(
                          studentId: studentId,
                          title: titleController.text.trim(),
                          description:
                          descriptionController.text.trim(),
                        );

                        if (success) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Feedback Submitted Successfully"),
                            ),
                          );

                          titleController.clear();
                          descriptionController.clear();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                              Text("Something went wrong"),
                            ),
                          );
                        }
                      },
                      child: vm.isLoading
                          ? const CircularProgressIndicator(
                        color: AppColors.background,
                      )
                          : Text(
                        "Submit Feedback",
                        style: GoogleFonts.poppins(
                          color: AppColors.background,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}