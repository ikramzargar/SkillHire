import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skill_hire/screens/intro.dart';
import 'package:skill_hire/screens/sp_form.dart';
import 'package:skill_hire/screens/user_form.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillHire',
      home: IntroScreen(),
    );
  }
}