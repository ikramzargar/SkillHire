import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:skill_hire/globals/app_Colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:skill_hire/sp_Side/sp_screens/sp_homescreen.dart';
import 'package:skill_hire/sp_Side/sp_screens/sp_jobs_screen.dart';
import 'package:skill_hire/sp_Side/sp_screens/sp_profile.dart';

class SpMainPage extends StatefulWidget {
  const SpMainPage({super.key});

  @override
  State<SpMainPage> createState() => _SpMainPageState();
}

class _SpMainPageState extends State<SpMainPage> {
  List<Widget> screenList = [
    SpHome(),
    SpJobs(),
    SpProfile(),
  ];
  int homeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainBgColor2,
        title: Center(
          child: Text('SkillHire',style: AppTextStyles.heading2Normal(),),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: AppColors.mainBgColor2,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
              selectedIndex: homeIndex,
              onTabChange: (index) {
                setState(() {
                  homeIndex = index;
                });
              },
              backgroundColor: AppColors.mainBgColor2,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: AppColors.buttonColor1,
              gap: 10,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.work,
                  text: 'Jobs',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                )
              ]),
        ),
      ),
      body: IndexedStack(
        children: screenList,
        index: homeIndex,
      ),
    );
  }
}
