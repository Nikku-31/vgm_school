import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_new/core/constants/app_strings.dart';
import 'package:school_new/screen/attendance_screen.dart';
import 'package:school_new/screen/event.dart';
import '../AppManager/Model/AccountM/send_login_model.dart';
import '../AppManager/Service/NotificationS/notification_service.dart';
import '../AppManager/ViewModel/AccountVM/send_login_viewModel.dart';
import '../AppManager/ViewModel/AccountVM/student_details_view_model.dart';
import '../AppManager/ViewModel/AttendanceVM/student_attendance_vm.dart';
import '../AppManager/ViewModel/DashboardVM/dashboard_vm.dart';
import '../AppManager/ViewModel/HomeWorkVM/upcoming_classes_vm.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/text_styles.dart';
import '../screen/change_password.dart';
import '../screen/deposite_screen.dart';
import '../screen/fees_due.dart';
import '../screen/homework.dart';
import '../screen/language.dart';
import '../screen/news_page.dart';
import '../screen/notification_screen.dart';
import '../screen/pending_screen.dart';
import '../screen/profile.dart';
import '../screen/result.dart';
import '../screen/time_table.dart';
import '../screen/classes.dart';
import 'login_screen.dart';

class Dashboard extends StatefulWidget {
  final Student? student;
  const Dashboard({super.key, this.student});

  @override
  State<Dashboard> createState() => _DashboardState(
  );
}

class _DashboardState extends State<Dashboard> {

  bool isCardVisible(DashboardVM vm, String name) {
    return vm.dashboardList.any(
          (e) =>
      (e.name ?? "").toLowerCase().trim() == name.toLowerCase().trim() &&
          e.isActive == true,
    );
  }

  int _selectedIndex = 0;
  bool isMenuOpen = false;
  bool isPageLoading = true;

  @override
  void initState() {
    super.initState();

    int notificationCount = 0;
    final notificationService = NotificationService();

    notificationService.requestNotificationPermission();

    notificationService.getDeviceToken().then((token) {
      print("TOKEN: $token");
    });

    notificationService.firebaseInit(context);

    notificationService.setupInteractMessage(context);

    // App opened from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {},
    );

    // Background notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        _handleNotificationTap(message);
      },
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) async {

      setState(() {
        isPageLoading = true;
      });

      final studentVM =
      context.read<StudentDetailViewModel>();

      // Student details
      await studentVM.getStudentDetails();
      await studentVM.loadLocalData();

      final studentId =
          studentVM.student?.studentId ?? 0;

      // All APIs together
      await Future.wait([

        context
            .read<DashboardVM>()
            .fetchDashboard(),

        context
            .read<StudentAttendanceVM>()
            .fetchAttendanceList(
          1,
          DateTime.now().copyWith(day: 1),
          DateTime.now(),
        ),

        if (studentId > 0)
          context
              .read<UpcomingClassesVM>()
              .fetchUpcomingClasses(
            studentId,
          ),
      ]);

      if (mounted) {
        setState(() {
          isPageLoading = false;
        });
      }
    });
  }
  void _handleNotificationTap(RemoteMessage message) {
    // Your UI is driven by bloc's state.currentIndex, so drive the bloc:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          // MAIN UI
          SizedBox.expand(
              child: isPageLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _selectedIndex == 0
                  ? Column(
                children: [

                  // HEADER
                  Container(
                    padding: const EdgeInsets.only(top: 60, left: 20, right: 40),
                    height: 140,
                    width: double.infinity,
                    color: AppColors.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        // Left Side
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // MENU ICON
                            GestureDetector(
                              onTap: () {
                                setState(() {isMenuOpen = !isMenuOpen;
                                });
                              },
                              child: const Icon(
                                Icons.menu,
                                color: AppColors.background,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Name & Class
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer<StudentDetailViewModel>(
                                  builder: (context, vm, child) {
                                    //loading
                                    if(vm.isLoading){
                                      return const Center(child: Padding(padding: EdgeInsets.only(),
                                        child: CircularProgressIndicator(
                                          color: AppColors.background,
                                        ),),);
                                    }

                                    if (vm.student == null) {
                                      return const SizedBox();
                                    }

                                    final student = vm.student!;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          student.studentName ?? "-" ,
                                          style: AppTextStyles.heading.copyWith(
                                            color: AppColors.background,
                                            fontSize: 24,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          "Class - ${student.className ?? ""} ${student.sectionName ?? ""} ",
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.background,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Profile Icon
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfile(),
                                ),
                              );
                            },
                            child: Consumer<StudentDetailViewModel>(
                              builder: (context, vm, child) {
                                final student = vm.student;

                                return CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: vm.profileImage != null
                                        ? Image.file(
                                      vm.profileImage!,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                        : (student != null &&
                                        student.studentPhoto.isNotEmpty)
                                        ? Image.network(
                                      "https://vgm.online-tech.in${student.studentPhoto}",
                                      width: 70,
                                      height: 70,

                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person_outline,
                                          size: 40,
                                          color: AppColors.primary,
                                        );
                                      },
                                    )
                                        : const Icon(
                                      Icons.person_outline,
                                      size: 40,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // BODY SECTION
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15,right: 20,top:15, bottom: 15),
                        child: Consumer<DashboardVM>(
                          builder: (context, vm, child) {
                            return LayoutBuilder(
                              builder: (context, constraints) {

                                double width = constraints.maxWidth;

                                int crossAxisCount = width > 900
                                    ? 5 : width > 600
                                    ? 4 : 3;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GridView.count(
                                      padding: EdgeInsets.zero,
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: 0.95,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,

                                      children: [

                                        // ATTENDANCE
                                        if (isCardVisible(vm, "Attendance"))
                                          Consumer<StudentAttendanceVM>(
                                            builder: (context, vm2, child) {
                                              double percent = vm2
                                                  .getMonthlyAttendancePercentage(
                                                DateTime.now(),
                                              );

                                              return infoCard(
                                                icon: Icons.school_outlined,
                                                title:
                                                "${percent.toStringAsFixed(1)}%",
                                                subtitle: AppStrings.get(
                                                  context,
                                                  "attendance",
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                      const AttendanceScreen(),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),

                                        // FEES
                                        if (isCardVisible(vm, "Fees Collection"))
                                          infoCard(
                                            icon: Icons.currency_rupee_outlined,
                                            title: "₹",
                                            subtitle: AppStrings.get(
                                              context,
                                              'fees_collection',
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                  const FeesScreen(),
                                                ),
                                              );
                                            },
                                          ),

                                        // DEPOSIT
                                        if (isCardVisible(vm, "Deposite Fee"))
                                          menuCard(
                                            CupertinoIcons.money_dollar_circle,
                                            AppStrings.get(
                                                context,
                                                'deposit_fee'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const DepositeScreen(),
                                                ),
                                              );
                                            },
                                          ),

                                        // PENDING
                                        if (isCardVisible(vm, "Pending Fee"))
                                          menuCard(
                                            CupertinoIcons.hourglass,
                                            AppStrings.get(
                                                context,
                                                'pending_fee'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const PendingScreen(),
                                                ),
                                              );
                                            },
                                          ),

                                        // TIME TABLE
                                        if (isCardVisible(vm, "Time Table"))
                                          menuCard(
                                            CupertinoIcons.calendar,
                                            AppStrings.get(
                                                context,
                                                'time_table'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const TimeTable(),
                                                ),
                                              );
                                            },
                                          ),

                                        // ASSIGNMENT
                                        if (isCardVisible(vm, "Assignment"))
                                          menuCard(
                                            CupertinoIcons.book,
                                            AppStrings.get(
                                                context,
                                                'assignment'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const HomeWork(),
                                                ),
                                              );
                                            },
                                          ),

                                        // RESULT
                                        if (isCardVisible(vm, "Exam Result"))
                                          menuCard(
                                            CupertinoIcons.doc_text,
                                            AppStrings.get(
                                                context,
                                                'exam_result'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const Result(),
                                                ),
                                              );
                                            },
                                          ),

                                        // NEWS
                                        if (isCardVisible(vm, "Notices"))
                                          menuCard(
                                            CupertinoIcons.news,
                                            AppStrings.get(
                                                context,
                                                'Notices'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const NewsPage(),
                                                ),
                                              );
                                            },
                                          ),
                                        if (isCardVisible(vm, "Events"))
                                          menuCard(
                                            CupertinoIcons.doc_text,
                                            AppStrings.get(
                                                context,
                                                'Events'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const Event(),
                                                ),
                                              );
                                            },
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    Row(
                                      children: [
                                        Container(
                                          height: 24,
                                          width: 4,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        Text(
                                          "Upcoming Classes",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const Spacer(),

                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => const ClassesScreen(),
                                              ),
                                            );
                                          },

                                          child: Text(
                                            "View all",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),


                                    Consumer<UpcomingClassesVM>(
                                      builder: (context, vm, child) {

                                        if (vm.isLoading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        if (vm.classes.isEmpty) {
                                          return Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 35,
                                            ),
                                            decoration: BoxDecoration(
                                              color:AppColors.background,
                                              border: Border.all(
                                                color: AppColors.primary,
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "No Data Available",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          );
                                        }

                                        return ListView.builder(
                                          padding: const EdgeInsets.only(top: 15),
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: vm.classes.length,
                                          itemBuilder: (context, index) {

                                            var item = vm.classes[index];

                                            return Container(
                                              margin: EdgeInsets.zero,
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10,),
                                              decoration: BoxDecoration(
                                                color:AppColors.background,
                                                border: Border.all(
                                                  color: AppColors.primary,
                                                  width: 1.5,
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),

                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  // Date + Day
                                                  Row(
                                                    children: [

                                                      Icon(
                                                        Icons.calendar_today,
                                                        size: 16,
                                                        color: AppColors.primary,
                                                      ),

                                                      const SizedBox(width: 5),

                                                      Text(
                                                        "${item.currentDate ?? ""}",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                        ),
                                                      ),

                                                      const Spacer(),

                                                      Container(
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors.primary.withOpacity(.1),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Text(
                                                          "${item.day ?? ""}",
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
                                                            color: AppColors.primary,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 10),

                                                  // Subject
                                                  Text(
                                                    "${item.subjectName ?? ""}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 8),

                                                  // Teacher + Time
                                                  Text(
                                                    "${item.teacherName ?? ""}",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 5),

                                                  Text(
                                                    "${item.fromTime ?? ""} - ${item.toTime ?? ""}",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],

              )
                  : _selectedIndex == 1
                  ? const NotificationScreen()
                  : const EditProfile()
          ),
          // DARK OVERLAY
          if (isMenuOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  isMenuOpen = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          // SLIDE MENU
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),

            left: isMenuOpen ? 0 : -250,
            top: 0,
            bottom: 0,
            child: Container(
              width: 250,
              height: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  // Profile Section
                  ListTile(

                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                          CupertinoIcons.person,
                          color: AppColors.primary),
                    ),
                    title: Text(AppStrings.get(context, 'Student Profile'),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      setState(() => isMenuOpen = false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfile(),
                        ),
                      );
                    },
                  ),

                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: Text(AppStrings.get(context, 'Language'),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      setState(() => isMenuOpen = false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Language(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.password),
                    title: Text(AppStrings.get(context, "change_password"),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      setState(() => isMenuOpen = false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassword(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.square_arrow_right),
                    title: Text(AppStrings.get(context, 'Logout'),
                      style: GoogleFonts.poppins(fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(AppStrings.get(context, 'logout'),
                            style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                          content: Text(AppStrings.get(context, 'logout_confirm'),
                            style: GoogleFonts.poppins(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(AppStrings.get(context, 'Cancel'),
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Provider.of<SendLoginViewModel>(context, listen: false)
                                    .logout();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                      (route) => false,
                                );
                              },
                              child: Text(
                                "Logout",
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text("TechErpfi"),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.bell), label: "Notification"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final List<List<Color>> gradients = [
      [Color(0xffFF6B6B), Color(0xffFF8E53)],
      [Color(0xff4E54C8), Color(0xff8F94FB)],
      [Color(0xff11998E), Color(0xff38EF7D)],
      [Color(0xffFC5C7D), Color(0xff6A82FB)],
      [Color(0xffF7971E), Color(0xffFFD200)],
      [Color(0xff834D9B), Color(0xffD04ED6)],
      [Color(0xff00B4DB), Color(0xff0083B0)],
      [Color(0xff56ab2f), Color(0xffa8e063)],
    ];
    int colorIndex = subtitle.hashCode % gradients.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: gradients[colorIndex],
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget menuCard(
      IconData icon,
      String title, {
        VoidCallback? onTap,
      }) {

    final List<List<Color>> gradients = [
      [Color(0xff00B4DB), Color(0xff0083B0)],
      [Color(0xffFF6B6B), Color(0xffFF8E53)],
      [Color(0xff56ab2f), Color(0xffa8e063)],
      [Color(0xffFF6B6B), Color(0xffFF8E53)],
      [Color(0xff4E54C8), Color(0xff8F94FB)],
      [Color(0xff834D9B), Color(0xffD04ED6)],

    ];


    int colorIndex = title.hashCode % gradients.length;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {

          double cardWidth = constraints.maxWidth;
          double iconBoxSize = cardWidth * .38;
          double iconSize = cardWidth * .18;
          double textSize = cardWidth * .10;

          return Container(
            padding: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  height: iconBoxSize,
                  width: iconBoxSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: gradients[colorIndex],
                    ),
                  ),

                  child: Icon(
                    icon,
                    color: AppColors.background,
                    size: iconSize,
                  ),
                ),

                SizedBox(
                  height: constraints.maxHeight * .08,
                ),

                Flexible(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}