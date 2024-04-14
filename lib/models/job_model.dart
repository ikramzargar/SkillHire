import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String title;
  String description;
  String userId;

  Job({
    required this.title,
    required this.description,
    required this.userId,
  });
}

// Firestore Service
class FirestoreService {
  final CollectionReference jobsCollection =
  FirebaseFirestore.instance.collection('jobs');

  Future<void> createJob(Job job) async {
    await jobsCollection.add({
      'title': job.title,
      'description': job.description,
      'userId': job.userId,
    });
  }
// Implement update and delete methods similarly
}