import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/AccountVM/student_details_view_model.dart';
import '../core/constants/app_colors.dart';
import '../screen/widgets/edit_profile_shimmer.dart';
import 'edit_profile_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<StudentDetailViewModel>();

      await vm.getStudentDetails();
      await vm.loadLocalData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<StudentDetailViewModel>(
        builder: (context, vm, child) {

          if (vm.isLoading) {
            return const EditProfileShimmer();
          }

          if (vm.student == null) {
            return const Center(child: Text("No Profile Data Found"));
          }

          final student = vm.student!;

          return SingleChildScrollView(
            child: Column(
              children: [

                /// ======= BLUE HEADER =======
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      top: 50, left: 20, right: 20, bottom: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [

                      // Profile Image
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            top: 0, left: 20, right: 20, bottom: 0),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // LEFT SIDE PROFILE IMAGE
                            Stack(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    color: Colors.white,
                                  ),
                                  child: ClipOval(
                                    child: vm.profileImage != null
                                        ? Image.file(
                                      vm.profileImage!,
                                      fit: BoxFit.cover,
                                    )
                                        : (student.studentPhoto.isNotEmpty)
                                        ? Image.network(
                                      "https://vgm.online-tech.in${student.studentPhoto}", // Base URL + /StudentsFiles/...
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 45,
                                          color: AppColors.primary,
                                        );
                                      },
                                    )
                                        : const Icon(
                                      Icons.person,
                                      size: 45,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                //Edit profile page
                                // Positioned(
                                //     bottom:0,
                                //     right:0,
                                //     child: GestureDetector(onTap: (){
                                //   // Navigator.push(context, MaterialPageRoute(builder: (
                                //   //     context)=> const EditProfileScreen()));
                                // },
                                //
                                // // child: Container(
                                // //   padding: const EdgeInsets.all(6),
                                // //   decoration: BoxDecoration(
                                // //     color: Colors.white,
                                // //     shape: BoxShape.circle,
                                // //     border: Border.all(color: AppColors.primary,width: 1),
                                // //   ),
                                // //   child: const Icon(Icons.edit,size: 9,
                                // //   color: AppColors.primary,),
                                // // ),
                                //     )
                                // )
                              ],
                            ),

                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    student.studentName ?? "-",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "Class : ${student.className ?? ""}  ${student.sectionName ?? ""}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "Admission No: ${student.admissionNo ?? "-"}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [

                      _buildField("Academic Year",
                          student.sessionName),

                      _buildField("Campus",
                          student.schoolName),

                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              "Pickup",
                              student.pickupTime,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildField(
                              "Drop",
                              student.dropTime,
                            ),
                          ),
                        ],
                      ),

                      _buildField("Address",
                          student.address, maxLines: 2),
                      const SizedBox(height: 5,),
                      // PARENT DETAILS TITLE
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Parent Details",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      _buildField("Father Name",
                          student.fatherName),

                      _buildField("Mother Name",
                          student.motherName),

                      _buildField("Contact",
                          student.mobile),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(String title, String? value,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            (value == null || value.isEmpty) ? "-" : value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Divider(),
        ],
      ),
    );
  }
}