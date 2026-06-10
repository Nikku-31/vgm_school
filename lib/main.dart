import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:school_new/screen/widgets/language_provider.dart';
import 'package:school_new/screen/widgets/myhttoverrides.dart';
import 'package:school_new/widget/splash_screen.dart';
import 'AppManager/ViewModel/AccountVM/change_password_view_model.dart';
import 'AppManager/ViewModel/AccountVM/send_login_viewModel.dart';
import 'AppManager/ViewModel/AccountVM/student_details_view_model.dart';
import 'AppManager/ViewModel/AttendanceVM/attendance_vm.dart';
import 'AppManager/ViewModel/AttendanceVM/student_attendance_vm.dart';
import 'AppManager/ViewModel/DashboardVM/dashboard_vm.dart';
import 'AppManager/ViewModel/EventVM/event_vm.dart';
import 'AppManager/ViewModel/FeesVM/get_student_fee_view_model.dart';
import 'AppManager/ViewModel/FeesVM/save_fee_view_model.dart';
import 'AppManager/ViewModel/HomeWorkVM/hw_viewm.dart';
import 'AppManager/ViewModel/HomeWorkVM/upcoming_classes_vm.dart';
import 'AppManager/ViewModel/NoificationVM/news_view_model.dart';


///  Background Handler (Required)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(" BACKGROUND MESSAGE: ${message.notification?.title}");
}
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  ///  Initialize Firebase
  await Firebase.initializeApp();

  ///  Register background handler
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );
  ///  Request Permission (IMPORTANT)
  await FirebaseMessaging.instance.requestPermission();

  //  Get FCM Token
  String? token = await FirebaseMessaging.instance.getToken();
  print(" FCM TOKEN: $token");

  ///  Foreground Notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(" FOREGROUND MESSAGE: ${message.notification?.title}");
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentFeeViewModel()),
        ChangeNotifierProvider(create: (_) => SaveFeeViewModel()),
        ChangeNotifierProvider(create: (_) => SendLoginViewModel()),
        ChangeNotifierProvider(create: (_) => StudentDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceVM()),
        ChangeNotifierProvider(create: (_) => StudentAttendanceVM()),
        ChangeNotifierProvider(create: (_) => NewsViewModel()),
        ChangeNotifierProvider(create: (_) => HwViewModel(),),
        ChangeNotifierProvider(create: (_) => DashboardVM(),),
        ChangeNotifierProvider(create: (_) => UpcomingClassesVM(),),
        ChangeNotifierProvider(create: (_) => EventViewModel(),),
        ChangeNotifierProvider(create: (_) => LanguageProvider()..loadLanguage(),),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          locale: langProvider.locale,

          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
          ],

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: const SplashScreen(),
        );
      },
    );
  }
}