import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/job_model.dart';

class JobCreationForm extends StatefulWidget {
  @override
  _JobCreationFormState createState() => _JobCreationFormState();
}

class _JobCreationFormState extends State<JobCreationForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String userId = '';

  @override
  void initState() {
    userId = getCurrentUserId()!;
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
          controller: descriptionController,
          decoration: InputDecoration(labelText: 'Job Description'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle job creation here
            final jobTitle = titleController.text;
            final jobDescription = descriptionController.text;

            // Validate and save the job to Firestore or perform other actions
            // For example:
            FirestoreService().createJob(Job(title: jobTitle,
                description: jobDescription,
                userId: userId));

            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Create Job'),
        ),
      ],
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
}
