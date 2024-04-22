import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_hire/globals/app_textStyle.dart';

import '../../globals/app_Colors.dart';
import '../../job_creation_form.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String userId = '';

  TextEditingController _titleController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    userId = getCurrentUserId()!;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'images/logo.png',
              scale: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome!',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Create a Job',
                        style: AppTextStyles.heading2Normal(),
                      ),
                      content: JobCreationForm(),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.add,
                size: 50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Click on the add button to add a job.',
              style: AppTextStyles.normalText1(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Active Jobs',
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(height: 10),
          Container(
            //height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('jobs')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final List<DocumentSnapshot> jobs = snapshot.data!.docs;

                      if (jobs.isEmpty) {
                        return Center(
                          child: Text('No active tasks!'),
                        );
                      }
                      void deleteJob(String jobId) {
                        FirebaseFirestore.instance
                            .collection('jobs')
                            .doc(
                                jobId) // Assuming job.id is the document ID of the job
                            .delete()
                            .then((_) {
                          // Job deleted successfully
                          print('Job deleted successfully');
                        }).catchError((error) {
                          // Error deleting job
                          print('Error deleting job: $error');
                          // Handle error (show message, log error, etc.)
                        });
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          final jobId = job['documentId'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            child: Hero(
                              tag: 'ListTile-Hero-$jobId',
                              child: Material(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) {
                                        return Scaffold(
                                          appBar: AppBar(
                                            title: Text('Job'),
                                            actions: [
                                              DropdownButton<String>(
                                                icon: Icon(Icons.more_vert),
                                                onChanged: (String? value) {
                                                  if (value == 'edit') {
                                                    showEditDialog(context, jobId);
                                                  } else if (value ==
                                                      'delete') {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirm Deletion'),
                                                          content: Text(
                                                              'Are you sure you want to delete this job?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                _titleController.text = job['title'];
                                                                _rateController.text = job['rate'];
                                                                _descriptionController.text = job['description'];
                                                                Navigator.pop(
                                                                    context); // Close dialog
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                deleteJob(
                                                                    jobId);
                                                                Navigator.pop(
                                                                    context); // Close dialog
                                                              },
                                                              child: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                items: <String>[
                                                  'edit',
                                                  'delete'
                                                ].map((String option) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: option,
                                                    child: Text(option),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                          backgroundColor:
                                              AppColors.mainBgColor,
                                          body: SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Title : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['title'] ?? '',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Requirment : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['requirment'] ?? '',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Description : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['description'] ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Address : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['adress'] ?? '',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Created by : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['createdby'] ?? '',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Mobile No. : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['mobile'] ?? '',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Expected Rate : Rs ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['rate'] ?? '',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Back'),
                                                    color:
                                                        AppColors.buttonColor1,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                    elevation: 5.0,
                                                    height: 40,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Title :',
                                            style: AppTextStyles.tileText(),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              job['title'] ?? '',
                                              maxLines: 2,
                                              style: AppTextStyles.tileText(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ), //
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Requirment :',
                                            style: AppTextStyles.tileText(),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              job['requirment'] ?? '',
                                              style: AppTextStyles.tileText(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  tileColor: AppColors.mainBgColor2,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
  void showEditDialog(BuildContext context , String docId) {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.mainBgColor,
          title: Text(
            'Edit Profile',
            style: AppTextStyles.heading2Normal(),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller:_titleController,
                  decoration: InputDecoration(
                      labelText: 'Title', labelStyle: AppTextStyles.normalText1()),
                  style: AppTextStyles.normalText1(),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: AppTextStyles.normalText1()),
                  style: AppTextStyles.normalText1(),
                  // keyboardType: TextInputType.phone,
                  // maxLength: 10,
                ),
                SizedBox(height: 10,),
                TextField(
                  controller:_rateController,
                  decoration: InputDecoration(
                      labelText: 'Rate', labelStyle: AppTextStyles.normalText1()),
                  style: AppTextStyles.normalText1(),
                ),
              ],
            ),
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
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              elevation: 1,
            ),
            MaterialButton(
              onPressed: () {
                String newtitle = _titleController.text;
                String newDescription = _descriptionController.text;
                String newRate = _rateController.text;

                updateUserData(newtitle, newDescription,docId, newRate);
                Navigator.pop(context); // Close the dialog
              },
              color: AppColors.buttonColor1,
              child: Text(
                'Save',
                style: AppTextStyles.normalText1().copyWith(fontSize: 20),
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              elevation: 1,
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUserData(String newtitle, String newDescription , String docId, String newRate) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Validate new name and mobile number before updating Firestore
        if (newtitle.trim().isNotEmpty && newDescription.trim().isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('jobs')
              .doc(docId)
              .update({
            'title': newtitle,
            'description': newDescription,
            'rate': newRate,
          });

          print('User data updated successfully');
        } else {
          print('Name or mobile number cannot be empty');
          // Show an error message or handle invalid input case
        }
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error updating user data: $e');
      // Handle Firestore update error
    }
  }
}

