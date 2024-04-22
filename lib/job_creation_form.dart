import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals/app_Colors.dart';
import 'globals/app_textStyle.dart';
import 'models/job_model.dart';

class JobCreationForm extends StatefulWidget {
  @override
  _JobCreationFormState createState() => _JobCreationFormState();
}

class _JobCreationFormState extends State<JobCreationForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  String userId = '';
  String name = '';
  String adress = '';
  String mobileNum = '';
  double lat = 0;
  double lon = 0;
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
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Job Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job title';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profession',
                  style: TextStyle(fontSize: 18),
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
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      height: 40,
                      width: 300,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      customHeights: _getCustomItemsHeights(givenlist: professions),
                    ),
                    iconStyleData: const IconStyleData(
                      openMenuIcon: Icon(Icons.arrow_drop_up),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Job Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job description';
                }
                return null;
              },
              maxLines: 1,
            ),
            TextFormField(
              controller: rateController,
              decoration: InputDecoration(labelText: 'Expected rate (Rs/day)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the expected rate';
                }
                // Validate if the entered value is numeric
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid numeric value';
                }

                return null;
              },
              maxLength: 4,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only digits
              ],
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(fontSize: 20)),
                  color: AppColors.buttonColor1,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 5.0,
                ),
                SizedBox(width: 20,),
                MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, proceed with saving the job
                      saveJob();
                    }
                  },
                  child: Text('Save', style: TextStyle(fontSize: 20)),
                  color: AppColors.buttonColor1,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 5.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            userId = userData['userId'] ?? '';
            name = userData['name'] ?? '';
            adress = userData['address'] ?? '';
            mobileNum = userData['mobileNo'] ?? '';
            lat = userData['latitude'] ?? '';
            lon = userData['longitude'] ?? '';
          });
        } else {
          print('User Data Does Not Exist for UserID: ${user.uid}');
        }
      } else {
        print('No User is Currently Signed In');
      }
    } catch (e) {
      print('Error Fetching User Data: $e');
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
          // If it's not the last item, add a divider
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
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  void saveJob() {
    final jobTitle = titleController.text;
    final jobDescription = descriptionController.text;
    final jobRate = rateController.text;
    FirestoreService().createJob(Job(
      title: jobTitle,
      description: jobDescription,
      userId: userId,
      requirment: profession,
      rate: jobRate,
      createdby: name,
      mobile: mobileNum,
      adress: adress,
      lat: lat,
      lon: lon,
    ));
    Navigator.of(context).pop();
  }
}
