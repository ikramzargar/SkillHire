import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:skill_hire/services/location_service.dart';
import '../globals/app_colors.dart';

// User form.
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

// Function to get user location.
  Future<void> getLocation() async {
    try {
      Location location = Location();
      await location.getCurrentLocation();
      setState(() {
        lat = location.latitude!;
        lon = location.longitude!;
      });
    } catch (e) {
      log('Error getting location: $e');
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
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.mainBgColor2,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Let\'s get you started.',
                  style: AppTextStyles.heading2Normal(),
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
                  const SizedBox(height: 30),
                  _buildTextField('Mobile No.', noController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatter: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                  const SizedBox(height: 30),
                  _buildTextField('Address', addressController),
                ],
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: _validateForm,
              color: AppColors.buttonColor1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              elevation: 1,
              height: 40,
              child: Text(
                'Save',
                style: AppTextStyles.normalText1(),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget build method.
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatter, // Added input formatter parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.normalText1(),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatter, // Set input formatters
          style: AppTextStyles.textfieldStyle1(),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

// Validation function.
  Future<void> _validateForm() async {
    if (nameController.text.isEmpty ||
        noController.text.isEmpty ||
        addressController.text.isEmpty ||
        !isValidPhoneNumber(noController.text)) {
      // Show error message if any of the fields is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill out all fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // All fields are filled, proceed to save data
      saveUserData();
      Navigator.pushReplacementNamed(
        context,
        '/userHome',
      );
    }
  }

// Function to save user data.
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
        CollectionReference ref =
            FirebaseFirestore.instance.collection('users');
        ref.doc(userId).update({'data': true});
        log('User data saved successfully!');
      } else {
        log('No user is currently signed in.');
      }
    } catch (e) {
      log('Error saving user data: $e');
    }
  }

  bool isValidPhoneNumber(String input) {
    return input.length == 10 && int.tryParse(input) != null;
  }
}
