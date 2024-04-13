//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:skill_hire/globals/app_textStyle.dart';
// import 'package:skill_hire/location_service.dart';
//
// class SpForm extends StatefulWidget {
//   const SpForm({super.key});
//
//   @override
//   State<SpForm> createState() => _SpFormState();
// }
//
// class _SpFormState extends State<SpForm> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController noController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController professionController = TextEditingController();
//   TextEditingController experienceController = TextEditingController();
//   TextEditingController rateController = TextEditingController();
//
//  @override
//   void initState() {
//     getLocation();
//     super.initState();
//   }
// late   double lat;
//   late double lon;
//   Future<void> getLocation() async {
//     try {
//       Location location = Location(); // Create an instance of Location
//       await location.getCurrentLocation(); // Retrieve current location
//       setState(() {
//         lat = location.latitude;
//         lon = location.longitude;
//         print(lat);
//         print(lon);
//       });
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         child: Column(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30)),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Text('Let`s get you started.',
//                     style: AppTextStyles.heading1()),
//               ),
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'Name',
//                     style: TextStyle(
//                       fontSize: 30,
//                     ),
//                   ),
//                   TextField(
//                     controller: nameController,
//                     style: TextStyle(fontSize: 20),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 2)),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Text(
//                     'Mobile No.',
//                     style: TextStyle(fontSize: 30),
//                   ),
//                   TextField(
//                     controller: noController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 10,
//                     style: TextStyle(fontSize: 30),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.black, width: 2),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Text(
//                     'Adress',
//                     style: TextStyle(fontSize: 30),
//                   ),
//                   TextField(
//                     controller: addressController,
//                     style: TextStyle(fontSize: 20),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 2)),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Text(
//                     'Profession',
//                     style: TextStyle(fontSize: 30),
//                   ),
//                   TextField(
//                     controller: professionController,
//                     style: TextStyle(fontSize: 20),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 2)),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Text(
//                     'Experience (In Years)',
//                     style: TextStyle(fontSize: 30),
//                   ),
//                   TextField(
//                     controller: experienceController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 2,
//                     style: TextStyle(fontSize: 20),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide:
//                           BorderSide(color: Colors.black, width: 2)),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Text(
//                     'Rate (Rs/Day)',
//                     style: TextStyle(fontSize: 30),
//                   ),
//                   TextField(
//                     controller: rateController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 4,
//                     style: TextStyle(fontSize: 20),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide:
//                           BorderSide(color: Colors.black, width: 2)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             MaterialButton(
//               onPressed: () {
//                 setState(() {
//                   String? userid = getCurrentUserId();
//                   savespData(nameController.text, noController.text,
//                       addressController.text, professionController.text , userid!);
//                 });
//               },
//               color: Colors.green,
//               child: Text(
//                 'Save',
//                 style: TextStyle(fontSize: 25),
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> savespData(
//       String name, String mobileNo, String address, String profession , String userid) async {
//     try {
//       await FirebaseFirestore.instance.collection('spdata').add({
//         'name': name,
//         'mobileNo': mobileNo,
//         'address': address,
//         'profession': profession,
//         'userid' : userid,
//         // Add more fields as needed
//       });
//       print('User data saved successfully!');
//     } catch (e) {
//       print('Error saving user data: $e');
//     }
//   }
//
//   String? getCurrentUserId() {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       String userId = user.uid;
//       print('Current User ID: $userId');
//       return userId;
//     } else {
//       print('No user is currently signed in.');
//       return null;
//     }
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:skill_hire/location_service.dart';
import 'package:skill_hire/screens/sp_homepage.dart';

class SpForm extends StatefulWidget {
  const SpForm({Key? key}) : super(key: key);

  @override
  State<SpForm> createState() => _SpFormState();
}

class _SpFormState extends State<SpForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController rateController = TextEditingController();
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
        lat = location.latitude;
        lon = location.longitude;
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
                  _buildTextField('Mobile No.', noController,
                      keyboardType: TextInputType.number, maxLength: 10),
                  _buildTextField('Address', addressController),
                  _buildTextField('Profession', professionController),
                  _buildTextField('Experience (Years)', experienceController,
                      keyboardType: TextInputType.number, maxLength: 2),
                  _buildTextField('Rate (Rs/Day)', rateController,
                      keyboardType: TextInputType.number, maxLength: 4),
                ],
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) => SpHomePage()));
                  saveSpData();
                });
              },
              color: Colors.green,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 25),
              ),
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

  void saveSpData() async {
    try {
      String? userId = getCurrentUserId();
      if (userId != null) {
        await FirebaseFirestore.instance.collection('spdata').add({
          'name': nameController.text,
          'mobileNo': noController.text,
          'address': addressController.text,
          'profession': professionController.text,
          'experience': experienceController.text,
          'rate': rateController.text,
          'userId': userId,
          'latitude': lat,
          'longitude': lon,
        });
        print('Service provider data saved successfully!');
      } else {
        print('User ID is null. Unable to save data.');
      }
    } catch (e) {
      print('Error saving service provider data: $e');
    }
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      print('No user is currently signed in.');
      return null;
    }
  }
}
