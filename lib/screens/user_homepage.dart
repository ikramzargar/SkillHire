import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
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
            GButton(icon: Icons.home_repair_service,text: 'Providers',),
            GButton(icon: Icons.person,text: 'Profile',)
          ]),
        ),
      ),
    );
  }
}
