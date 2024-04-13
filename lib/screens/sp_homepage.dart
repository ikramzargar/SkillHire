import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:skill_hire/screens/sp_screens/sp_homescreen.dart';
import 'package:skill_hire/screens/sp_screens/sp_jobs_screen.dart';
import 'package:skill_hire/screens/sp_screens/sp_profile.dart';
import 'user_screens/user_homescreen.dart';
import 'user_screens/user_profile.dart';
import 'user_screens/user_providers_screen.dart';

class SpHomePage extends StatefulWidget {
  const SpHomePage({super.key});

  @override
  State<SpHomePage> createState() => _SpHomePageState();
}

class _SpHomePageState extends State<SpHomePage> {
  List<Widget> screenList = [
    SpHome(),
    SpJobs(),
    SpProfile(),
  ];
  int homeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text('SkillHire'),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          color: Colors.green,
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
              selectedIndex: homeIndex,
              onTabChange: (index){
                setState(() {
                  homeIndex = index;
                });
              },
              backgroundColor: Colors.green,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey,
              gap: 10,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(icon: Icons.home,text: 'Home',),
                GButton(icon: Icons.work,text:  'Jobs',),
                GButton(icon: Icons.person,text: 'Profile',)
              ]),
        ),
      ),
      body: IndexedStack(children:screenList,index: homeIndex,),
    );
  }
}
