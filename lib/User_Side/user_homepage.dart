import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:skill_hire/User_Side/user_screens/user_homescreen.dart';
import 'package:skill_hire/User_Side/user_screens/user_providers_screen.dart';
import 'package:skill_hire/User_Side/user_screens/user_profile.dart';

import '../globals/app_Colors.dart';
import '../globals/app_textStyle.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<Widget> screenList = [
    UserHome(),
    UserProviders(),
    UserProfile(),
  ];
  int homeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBgColor,
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainBgColor2,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Text('SkillHire',style: AppTextStyles.heading2Normal(),),
          ),
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
                  icon: Icons.home_repair_service,
                  text: 'Providers',
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
