import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:skill_hire/globals/app_colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';

// Service Provider profile screen.
class SpProfile extends StatefulWidget {
  const SpProfile({Key? key}) : super(key: key);

  @override
  State<SpProfile> createState() => _SpProfileState();
}

class _SpProfileState extends State<SpProfile> {
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

// Function to fetch data from FireStore.
  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot spdata = await FirebaseFirestore.instance
            .collection('spdata')
            .doc(user.uid)
            .get();
        if (spdata.exists) {
          log('Sp Data Retrieved Successfully: ${spdata.data()}');
          setState(() {
            name = spdata['name'] ?? '';
            email = spdata['email'] ?? '';
            mobileNum = spdata['mobileNo'] ?? '';
          });
        } else {
          log('Sp Data Does Not Exist for UserID: ${user.uid}');
        }
      } else {
        log('No Sp is Currently Signed In');
      }
    } catch (e) {
      log('Error Fetching Sp Data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
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
            child: Text('Welcome Service Provider !',
                style: AppTextStyles.heading2Normal()
                    .copyWith(fontSize: 30, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 40),
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
              const SizedBox(
                width: 10,
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
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 25),
                ),
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

// Widget build method for building profile.
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

// Function to log out.
  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

// Show Profile edit dialogue.
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
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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

// Validation function.
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

// Function to update data.
  Future<void> updateUserData(String newName, String newMobileNum) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Validate new name and mobile number before updating Firestore
        if (newName.trim().isNotEmpty && newMobileNum.trim().isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('spdata')
              .doc(user.uid)
              .update({
            'name': newName,
            'mobileNo': newMobileNum,
          });
          // Update local state only if Firestore update is successful
          setState(() {
            name = newName;
            mobileNum = newMobileNum;
          });
          log('User data updated successfully');
        } else {
          log('Name or mobile number cannot be empty');
          // Show an error message or handle invalid input case
        }
      } else {
        log('No user is currently signed in');
      }
    } catch (e) {
      log('Error updating user data: $e');
      // Handle Firestore update error
    }
  }
}
