import 'package:flutter/material.dart';
import 'package:skill_hire/screens/intro.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillHire',
      home: IntroScreen(),
    );
  }
}