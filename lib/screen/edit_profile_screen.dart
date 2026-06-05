import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_new/screen/widgets/language_provider.dart';
import '../AppManager/ViewModel/AccountVM/student_details_view_model.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final TextEditingController contactController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<StudentDetailViewModel>();

      await vm.loadLocalData();   // 👈 YE ADD KARO

      // Contact auto-fill
      if (vm.savedContact != null) {
        contactController.text = vm.savedContact!;
      } else if (vm.student != null && vm.student!.mobile != null) {
        contactController.text = vm.student!.mobile!;
      }
    });
  }

  /// PICK IMAGE
  Future<void> _pickImage(ImageSource source) async {
    final vm = context.read<StudentDetailViewModel>();

    final XFile? image =
    await _picker.pickImage(source: source, imageQuality: 70);

    if (image != null) {
      vm.setProfileImage(File(image.path));
    }
  }
  // IMAGE OPTION

  void _showImagePickerOption() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt,
                  color: AppColors.primary),
              title: Text(AppStrings.get(context, 'take_photo')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo,
                  color: AppColors.primary),
              title: Text(AppStrings.get(context, 'choose_gallery')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
  /// SAVE CONTACT
  void _saveChanges() async {
    final vm = context.read<StudentDetailViewModel>();
    String updatedContact = contactController.text.trim();

    if (updatedContact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.get(context, 'enter_contact')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await vm.setContactNumber(updatedContact);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.get(context, 'enter_contact')),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
            AppStrings.get(context, 'edit_profile'),
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Consumer<StudentDetailViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // PROFILE IMAGE
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.primary, width: 3),
                      ),
                      child: ClipOval(
                        child: vm.profileImage != null
                            ? Image.file(
                          vm.profileImage!,
                          fit: BoxFit.cover,
                        )
                            : const Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerOption,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// CONTACT
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
          AppStrings.get(context, 'contact_number'),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: AppStrings.get(context, 'enter_contact'),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: _saveChanges,
                    child: Text( AppStrings.get(context, 'save_changes'),
                    style: const TextStyle(color: Colors.white,
                    fontSize: 16),),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}