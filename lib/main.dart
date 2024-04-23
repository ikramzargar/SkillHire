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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => Register(),
        '/userForm': (context) => UserForm(),
        '/spForm': (context) => SpForm(),
        '/spHome': (context) => SpHomePage(),
        '/spDashboard': (context) => SpDashboard(),
        '/spJobs': (context) => SpJobs(),
        '/spProfile': (context) => SpProfile(),
        '/userHome': (context) => UserHomePage(),
        '/userDashboard': (context) => UserDashboard(),
        '/userProfile': (context) => UserProfile(),
      },
      debugShowCheckedModeBanner: false,
      title: 'SkillHire',
    );
  }
}
