import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_hire/globals/app_Colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:skill_hire/location_service.dart';
import 'package:skill_hire/sp_Side/sp_homepage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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

  Future<void> getLocation() async {
    try {
      Location location = Location();
      await location.getCurrentLocation();
      setState(() {
        lat = location.latitude!;
        lon = location.longitude!;
        print(lon + lat);
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
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.mainBgColor2,
                borderRadius: BorderRadius.only(
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
                      keyboardType: TextInputType.number, maxLength: 10),
                  _buildTextField('Address', addressController),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profession',
                        style: AppTextStyles.normalText1(),
                      ),
                      SizedBox(
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
                            padding: EdgeInsets.symmetric(
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
                      SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Experience (years)',
                        style: AppTextStyles.normalText1(),
                      ),
                      SizedBox(
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
                            padding: EdgeInsets.symmetric(
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
                      SizedBox(height: 15),
                    ],
                  ),
                  _buildTextField('Rate (Rs/Day)', rateController,
                      keyboardType: TextInputType.number, maxLength: 4),
                ],
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) => SpMainPage()));
                  saveSpData();
                });
              },
              color: AppColors.buttonColor1,
              child: Text(
                'Save',
                style: AppTextStyles.normalText1(),
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              elevation: 1,
              height: 40,
            ),
            const SizedBox(height: 30),
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
          style: AppTextStyles.normalText1(),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: AppTextStyles.textfieldStyle1(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

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
        print('User data saved successfully!');
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error saving user data: $e');
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
    // Basic phone number validation (accepts 10 digits)
    return input.length == 10 && int.tryParse(input) != null;
  }
}
