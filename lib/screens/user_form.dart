import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:skill_hire/location_service.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    getLocation();
    super.initState();
  }
  late   double lat;
  late double lon;
  Future<void> getLocation() async {
    try {
      Location location = Location(); // Create an instance of Location
      await location.getCurrentLocation(); // Retrieve current location
      setState(() {
        lat = location.latitude;
        lon = location.longitude;
        print(lat);
        print(lon);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text('Let`s get you started.',
                    style: AppTextStyles.heading1()),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 2)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Mobile No.',
                    style: TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: noController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    style: TextStyle(fontSize: 30),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Adress',
                    style: TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: addressController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 2)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  String? userid = getCurrentUserId();
                  saveUserData(nameController.text, noController.text,
                      addressController.text, userid!);
                });
              },
              color: Colors.green,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveUserData(String name, String mobileNo,
      String address, String userid) async {
    try {
      await FirebaseFirestore.instance.collection('userdata').add({
        'name': name,
        'mobileNo': mobileNo,
        'address': address,
        'userid' : userid,
        // Add more fields as needed
      });
      print('User data saved successfully!');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;
      print('Current User ID: $userId');
      return userId;
    } else {
      print('No user is currently signed in.');
      return null;
    }
  }
}
