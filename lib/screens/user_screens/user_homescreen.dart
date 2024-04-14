// import 'package:flutter/material.dart';
//
// import '../../job_creation_form.dart';
//
// class UserHome extends StatefulWidget {
//   const UserHome({super.key});
//
//   @override
//   State<UserHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<UserHome> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20), // Image border
//               child: SizedBox.fromSize(
//                 size: const Size.fromRadius(60), // Image radius
//                 child: Image.asset('images/logo.png', fit: BoxFit.cover),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Welcome!',
//               style: TextStyle(fontSize: 30),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Click on the add button to add a job.',
//               style: TextStyle(fontSize: 25),
//             ),
//           ),
//           Center(
//             child: IconButton(
//                 onPressed: () {
//                   // Show the job creation dialog
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Create a Job'),
//                         content: JobCreationForm(),
//                       );
//                     },
//                   );
//                 },
//                 icon: Icon(
//                   Icons.add,
//                   size: 50,
//                 )),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Center(
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Active Jobs',
//                   style: TextStyle(fontSize: 30),
//                 ),
//               ),
//               decoration: BoxDecoration(
//                   color: Colors.green, borderRadius: BorderRadius.circular(20)),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 60),
//             child: Center(child: Text('No active tasks!',style: TextStyle(fontSize: 20),),),
//           ),
//         ],
//       ),
//     );
//   }
//
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../job_creation_form.dart'; // Import your job creation form

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
   String userId = ''; // User ID obtained from Firebase Auth

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(60),
                child: Image.asset('images/logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome!',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Click on the add button to add a job.',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                // Show the job creation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Create a Job'),
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
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Active Jobs',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('jobs')
                .where('userId', isEqualTo: userId) // Fetch jobs created by the current user
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final jobs = snapshot.data!.docs;

                if (jobs.isEmpty) {
                  return Center(
                    child: Text('No active tasks!'),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: jobs.map((job) {
                    final jobData = job.data() as Map<String, dynamic>;
                    final jobTitle = jobData['title'] ?? '';
                    final jobDescription = jobData['description'] ?? '';

                    return ListTile(
                      title: Text(jobTitle),
                      subtitle: Text(jobDescription),
                      // Additional job details or actions can be added here
                    );
                  }).toList(),
                );
              }
            },
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
}

