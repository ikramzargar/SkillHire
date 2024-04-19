import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/job_model.dart';

class ProfileEditForm extends StatefulWidget {
  @override
  _ProfileEditFormState createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController requirmentController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  String userId = '';
  String name = '';
  String adress = '';
  String mobileNum = '';
  double lat = 0;
  double lon = 0;

  @override
  void initState() {
    //fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Job Title'),
        ),
        TextField(
          controller: requirmentController,
          decoration: InputDecoration(labelText: 'Job Requirment'),
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: 'Job Description'),
        ),
        TextField(
          controller: rateController,
          decoration: InputDecoration(labelText: 'Expected rate'),
        ),
        SizedBox(
          height: 10,
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     final jobTitle = titleController.text;
        //     final jobDescription = descriptionController.text;
        //     final jobRequirment = requirmentController.text;
        //     final jobRate = rateController.text;
        //     FirestoreService().createJob(Job(
        //       title: jobTitle,
        //       description: jobDescription,
        //       userId: userId,
        //       requirment: jobRequirment,
        //       rate: jobRate,
        //       createdby: name,
        //       mobile: mobileNum,
        //       adress: adress,
        //       lat: lat,
        //       lon: lon,
        //     ));
        //
        //     Navigator.of(context).pop();
        //   },
        //   child: Text('Create Job'),
        // ),
      ],
    );
  }

  // Future<void> fetchUserData() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       DocumentSnapshot userData = await FirebaseFirestore.instance
  //           .collection('userdata')
  //           .doc(user.uid)
  //           .get();
  //       if (userData.exists) {
  //         print('User Data Retrieved Successfully: ${userData.data()}');
  //         setState(() {
  //           userId = userData['userId'] ?? '';
  //           name = userData['name'] ?? '';
  //           adress = userData['address'] ?? '';
  //           mobileNum = userData['mobileNo'] ?? '';
  //           lat = userData['latitude'] ?? '';
  //           lon = userData['longitude'] ?? '';
  //         });
  //       } else {
  //         print('User Data Does Not Exist for UserID: ${user.uid}');
  //       }
  //     } else {
  //       print('No User is Currently Signed In');
  //     }
  //   } catch (e) {
  //     print('Error Fetching User Data: $e');
  //   }
  // }
}
