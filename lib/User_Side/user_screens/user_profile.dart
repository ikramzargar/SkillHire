import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:skill_hire/globals/app_colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:skill_hire/User_Side/job_creation_form.dart';

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

  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userdata = await FirebaseFirestore.instance
            .collection('userdata')
            .doc(user.uid)
            .get();
        if (userdata.exists) {
          print('Sp Data Retrieved Successfully: ${userdata.data()}');
          setState(() {
            name = userdata['name'] ?? '';
            email = userdata['email'] ?? '';
            mobileNum = userdata['mobileNo'] ?? '';
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
          SizedBox(height: 30),
          buildUserInfo('Name', name),
          SizedBox(height: 30),
          buildUserInfo('Email', email),
          SizedBox(height: 30),
          buildUserInfo('Mobile No.', mobileNum),
          SizedBox(height: 30),
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
                child: Text('Edit', style: TextStyle(fontSize: 25)),
                color: AppColors.buttonColor1,
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    logout(context);
                  });
                },
                child: Text('Log Out', style: TextStyle(fontSize: 25)),
                color: AppColors.buttonColor1,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                elevation: 5.0,
                height: 40,
              ),
            ],
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
          Text(label + ' :', style: AppTextStyles.normalText1()),
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

  void showEditDialog(BuildContext context) {
    _nameController.text = name ?? '';
    _mobileController.text = mobileNum ?? '';

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
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
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
              child: Text(
                'Cancel',
                style: AppTextStyles.normalText1().copyWith(fontSize: 20),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 1,
            ),
            SizedBox(width: 10),
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
              child: Text(
                'Save',
                style: AppTextStyles.normalText1().copyWith(fontSize: 20),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 1,
            ),
          ],
        );
      },
    );
  }

  bool _validateFields() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
      return false;
    }

    if (_mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your mobile number')),
      );
      return false;
    }

    return true;
  }

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
          print('User data updated successfully');
        } else {
          print('Name or mobile number cannot be empty');
        }
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
