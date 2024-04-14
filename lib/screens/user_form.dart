import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:skill_hire/location_service.dart';
import 'package:skill_hire/screens/user_homepage.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  late double lat;
  late double lon;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      Location location = Location();
      await location.getCurrentLocation();
      setState(() {
        lat = location.latitude!;
        lon = location.longitude!;
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
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Let\'s get you started.',
                  style: AppTextStyles.heading1(),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField('Name', nameController),
                  SizedBox(height: 30),
                  _buildTextField('Mobile No.', noController,
                      keyboardType: TextInputType.number, maxLength: 10),
                  SizedBox(height: 30),
                  _buildTextField('Address', addressController),
                ],
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: () {
                setState(() {
                  saveUserData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) => UserHomePage()));
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

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType, int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 30),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Future<void> saveUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        String? userEmail = user.email;

        await FirebaseFirestore.instance
            .collection('userdata')
            .doc(userId)
            .set({
          'name': nameController.text,
          'mobileNo': noController.text,
          'address': addressController.text,
          'userId': userId,
          'email': userEmail,
          'latitude': lat,
          'longitude': lon,
        });
        print('User data saved successfully!');
            } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
// }
