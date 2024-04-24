import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:skill_hire/globals/app_colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:skill_hire/services/location_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// Form gor service provider.
class SpForm extends StatefulWidget {
  const SpForm({Key? key}) : super(key: key);

  @override
  State<SpForm> createState() => _SpFormState();
}

class _SpFormState extends State<SpForm> {
  final TextEditingController _nameController = TextEditingController();
  TextEditingController noController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  late double lat;
  late double lon;
  final List<String> professions = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Labour',
    'Engineer',
    'Cleaner',
    'Welder',
    'Mason',
    'Mechanic',
  ];
  String? profession;
  final List<String> experiences = [
    '1 year',
    '2 years',
    '3 years',
    '4 years',
    '5 years',
    '5+ years',
  ];
  String? experience;
  @override
  void dispose() {
    _nameController.dispose();
    noController.dispose();
    rateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

// Function to get location.
  Future<void> getLocation() async {
    try {
      Location location = Location();
      await location.getCurrentLocation();
      setState(() {
        lat = location.latitude!;
        lon = location.longitude!;
        log((lon + lat) as String);
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
                  _buildTextField('Name', _nameController),
                  _buildTextField('Mobile No.', noController,
                      isNumeric: true,
                      keyboardType: TextInputType.number,
                      maxLength: 10),
                  _buildTextField('Address', addressController),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profession',
                        style: AppTextStyles.normalText1(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: _addDividersAfterItems(professions),
                          value: profession,
                          onChanged: (String? value) {
                            setState(() {
                              profession = value!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            height: 40,
                            width: 300,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights:
                                _getCustomItemsHeights(givenlist: professions),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Experience (years)',
                        style: AppTextStyles.normalText1(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: _addDividersAfterItems(experiences),
                          value: experience,
                          onChanged: (String? value) {
                            setState(() {
                              experience = value!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            height: 40,
                            width: 300,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights:
                                _getCustomItemsHeights(givenlist: experiences),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  _buildTextField('Rate (Rs/Day)', rateController,
                      isNumeric: true,
                      keyboardType: TextInputType.number,
                      maxLength: 4),
                ],
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                if (_validateForm()) {
                  saveSpData().then((_) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/spHome',
                    );
                  });
                } else {
                  // Show a message or alert the user that the form is incomplete
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill out all required fields.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
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
            const SizedBox(height: 30),
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
    bool isNumeric = false, // Add this parameter to indicate numeric input
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.normalText1(),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: AppTextStyles.textfieldStyle1(),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          inputFormatters:
              isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  // Validation function.
  bool _validateForm() {
    // Check if the name field is empty
    if (_nameController.text.isEmpty) {
      return false;
    }

    // Check if the mobile number field is empty or invalid
    if (noController.text.isEmpty || !isValidPhoneNumber(noController.text)) {
      return false;
    }

    // Check if the address field is empty
    if (addressController.text.isEmpty) {
      return false;
    }

    // Check if the profession is selected
    if (profession == null) {
      return false;
    }

    // Check if the experience is selected
    if (experience == null) {
      return false;
    }

    // Check if the rate field is empty or invalid
    if (rateController.text.isEmpty || !isNumericOnly(rateController.text)) {
      return false;
    }

    // If all checks pass, return true
    return true;
  }

  bool isNumericOnly(String value) {
    // Check if the string contains only digits
    return value.isNotEmpty && int.tryParse(value) != null;
  }

  // Function to save data to firestore.
  Future<void> saveSpData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        String? userEmail = user.email;
        bool availability = true;

        await FirebaseFirestore.instance.collection('spdata').doc(userId).set({
          'name': _nameController.text,
          'mobileNo': noController.text,
          'address': addressController.text,
          'profession': profession,
          'experience': experience,
          'rate': rateController.text,
          'userId': userId,
          'latitude': lat,
          'longitude': lon,
          'email': userEmail,
          'available': availability,
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

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights({required List<String> givenlist}) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (givenlist.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  bool isValidPhoneNumber(String input) {
    return input.length == 10 && int.tryParse(input) != null;
  }
}
