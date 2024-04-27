import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skill_hire/User_Side/user_form.dart';
import 'package:skill_hire/User_Side/user_homepage.dart';
import 'package:skill_hire/User_Side/user_screens/user_dashboard.dart';
import 'package:skill_hire/User_Side/user_screens/user_profile.dart';
import 'package:skill_hire/screens/intro.dart';
import 'package:skill_hire/screens/login.dart';
import 'package:skill_hire/sp_Side/sp_form.dart';
import 'package:skill_hire/sp_Side/sp_homepage.dart';
import 'package:skill_hire/sp_Side/sp_screens/sp_dashboard.dart';
import 'package:skill_hire/sp_Side/sp_screens/sp_jobs_screen.dart';
import 'package:skill_hire/sp_Side/sp_screens/sp_profile.dart';
import 'screens/register.dart';
// Main fuction.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const Register(),
        '/userForm': (context) => const UserForm(),
        '/spForm': (context) => const SpForm(),
        '/spHome': (context) => const SpHomePage(),
        '/spDashboard': (context) => const SpDashboard(),
        '/spJobs': (context) => const SpJobs(),
        '/spProfile': (context) => const SpProfile(),
        '/userHome': (context) => const UserHomePage(),
        '/userDashboard': (context) => const UserDashboard(),
        '/userProfile': (context) => const UserProfile(),
      },
      debugShowCheckedModeBanner: false,
      title: 'SkillHire',
    );
  }
}
