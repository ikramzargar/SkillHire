import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../screens/login.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = '';
   String email = '';
   String mobileNum = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('userdata')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          print('User Data Retrieved Successfully: ${userData.data()}');
          setState(() {
            name = userData['name'] ?? '';
            email = userData['email'] ?? '';
            mobileNum = userData['mobileNo'] ?? '';
            _isLoading = false;
          });
        } else {
          print('User Data Does Not Exist for UserID: ${user.uid}');
        }
      } else {
        print('No User is Currently Signed In');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error Fetching User Data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(60),
                child: Image.asset('images/logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Welcome User!', style: TextStyle(fontSize: 35)),
          ),
          SizedBox(height: 40),
          buildUserInfo('Name', name),
          SizedBox(height: 30),
          buildUserInfo('Email', email),
          SizedBox(height: 30),
          buildUserInfo('Mobile No.', mobileNum),
          SizedBox(height: 30),
          Center(
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  logout(context);
                });
              },
              child: Text('Log Out', style: TextStyle(fontSize: 25)),
              color: Colors.green,
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Developed by', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('Ikram Zargar', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('www.ikramzargar.netlify.app', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(label + ' :', style: TextStyle(fontSize: 25)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 25),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
