import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import '../../globals/app_colors.dart';
import '../job_creation_form.dart';

// User Home Screen.
class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String userId = '';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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
          const Center(
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
              icon: const Icon(
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
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Active Jobs',
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('jobs')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final List<DocumentSnapshot> jobs = snapshot.data!.docs;

                      if (jobs.isEmpty) {
                        return const Center(
                          child: Text('No active tasks!'),
                        );
                      }
                      void deleteJob(String jobId) {
                        FirebaseFirestore.instance
                            .collection('jobs')
                            .doc(jobId)
                            .delete()
                            .then((_) {
                          log('Job deleted successfully');
                        }).catchError((error) {
                          log('Error deleting job: $error');
                        });
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                                            title: const Text('Job'),
                                            actions: [
                                              DropdownButton<String>(
                                                icon:
                                                    const Icon(Icons.more_vert),
                                                onChanged: (String? value) {
                                                  if (value == 'edit') {
                                                    showEditDialog(
                                                        context, jobId);
                                                  } else if (value ==
                                                      'delete') {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Confirm Deletion'),
                                                          content: const Text(
                                                              'Are you sure you want to delete this job?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                _titleController
                                                                        .text =
                                                                    job['title'];
                                                                _rateController
                                                                        .text =
                                                                    job['rate'];
                                                                _descriptionController
                                                                        .text =
                                                                    job['description'];
                                                                Navigator.pop(
                                                                    context); // Close dialog
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                deleteJob(
                                                                    jobId);
                                                                Navigator.pop(
                                                                    context); // Close dialog
                                                              },
                                                              child: const Text(
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
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Title : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['title'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Requirment : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['requirment'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Description : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['description'] ??
                                                            '',
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Address : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['adress'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Created by : ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['createdby'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Expected Rate : Rs ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        job['rate'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    color:
                                                        AppColors.buttonColor1,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                    elevation: 5.0,
                                                    height: 40,
                                                    child: const Text('Back'),
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
                                  trailing: const Icon(Icons.arrow_forward_ios),
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
                                          const SizedBox(
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
                                          const SizedBox(
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

// Function to get current user id.
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      log('Current User ID: $userId');
      return userId;
    } else {
      log('No user is currently signed in.');
      return null;
    }
  }

// Show edit dialog.
  void showEditDialog(BuildContext context, String docId) {
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
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Job Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a job title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Job Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a job description';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _rateController,
                  decoration: const InputDecoration(
                      labelText: 'Expected rate (Rs/day)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the expected rate';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid numeric value';
                    }

                    return null;
                  },
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
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
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              elevation: 1,
              child: Text(
                'Cancel',
                style: AppTextStyles.normalText1().copyWith(fontSize: 20),
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  String newtitle = _titleController.text;
                  String newDescription = _descriptionController.text;
                  String newRate = _rateController.text;
                  updateUserData(newtitle, newDescription, docId, newRate);
                });

                Navigator.of(context)
                    .popUntil(ModalRoute.withName("/userHome"));
              },
              color: AppColors.buttonColor1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
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

// Function to update user data to firestore.
  Future<void> updateUserData(String newtitle, String newDescription,
      String docId, String newRate) async {
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
