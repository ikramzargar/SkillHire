import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:skill_hire/globals/app_colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import '../../screens/login.dart';

// Users profile screen.
class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = '';
  String email = '';
  String mobileNum = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

// Function to fetch user data.
  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userdata = await FirebaseFirestore.instance
            .collection('userdata')
            .doc(user.uid)
            .get();
        if (userdata.exists) {
          log('Sp Data Retrieved Successfully: ${userdata.data()}');
          setState(() {
            name = userdata['name'] ?? '';
            email = userdata['email'] ?? '';
            mobileNum = userdata['mobileNo'] ?? '';
          });
        } else {
          log('User Data Does Not Exist for UserID: ${user.uid}');
        }
      } else {
        log('No User is Currently Signed In');
        setState(() {});
      }
    } catch (e) {
      log('Error Fetching User Data: $e');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'images/logo.png',
              scale: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Welcome User !',
                style: AppTextStyles.heading2Normal()
                    .copyWith(fontSize: 30, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 30),
          buildUserInfo('Name', name),
          const SizedBox(height: 30),
          buildUserInfo('Email', email),
          const SizedBox(height: 30),
          buildUserInfo('Mobile No.', mobileNum),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5.0,
                height: 40,
                onPressed: () {
                  showEditDialog(context);
                },
                color: AppColors.buttonColor1,
                child: const Text('Edit', style: TextStyle(fontSize: 25)),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    logout(context);
                  });
                },
                color: AppColors.buttonColor1,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                elevation: 5.0,
                height: 40,
                child: const Text('Log Out', style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Developed by', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('Ikram Zargar', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('www.ikramzargar.netlify.app',
                    style: TextStyle(fontSize: 20)),
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
          Text('$label :', style: AppTextStyles.normalText1()),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 25),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

// Function to logout
  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void showEditDialog(BuildContext context) {
    _nameController.text = name;
    _mobileController.text = mobileNum;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.mainBgColor,
          title: Text(
            'Edit Profile',
            style: AppTextStyles.heading2Normal(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: AppTextStyles.normalText1(),
                ),
                style: AppTextStyles.normalText1(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: AppTextStyles.normalText1(),
                ),
                style: AppTextStyles.normalText1(),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), // Allow only numbers
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: AppColors.buttonColor1,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 1,
              child: Text(
                'Cancel',
                style: AppTextStyles.normalText1().copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(width: 10),
            MaterialButton(
              onPressed: () {
                if (_validateFields()) {
                  String newName = _nameController.text;
                  String newMobileNum = _mobileController.text;
                  updateUserData(newName, newMobileNum);
                  Navigator.pop(context); // Close the dialog
                }
              },
              color: AppColors.buttonColor1,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 1,
              child: Text(
                'Save',
                style: AppTextStyles.normalText1().copyWith(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

// Validate profile edit form.
  bool _validateFields() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return false;
    }

    if (_mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your mobile number')),
      );
      return false;
    }

    return true;
  }

// Update user data to firestore.
  Future<void> updateUserData(String newName, String newMobileNum) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (newName.trim().isNotEmpty && newMobileNum.trim().isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('userdata')
              .doc(user.uid)
              .update({
            'name': newName,
            'mobileNo': newMobileNum,
          });
          setState(() {
            name = newName;
            mobileNum = newMobileNum;
          });
          log('User data updated successfully');
        } else {
          log('Name or mobile number cannot be empty');
        }
      } else {
        log('No user is currently signed in');
      }
    } catch (e) {
      log('Error updating user data: $e');
    }
  }
}
