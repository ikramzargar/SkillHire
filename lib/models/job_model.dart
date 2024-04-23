import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

//Defines thte properties of a job.
class Job {
  String title;
  String description;
  String userId;
  String? requirment;
  String rate;
  String adress;
  String createdby;
  String mobile;
  double lat;
  double lon;

  Job({
    required this.title,
    required this.description,
    required this.userId,
    required this.requirment,
    required this.rate,
    required this.adress,
    required this.createdby,
    required this.mobile,
    required this.lat,
    required this.lon,
  });
}

//Handles firestore service for the job creation.
class FirestoreService {
  final CollectionReference jobsCollection =
      FirebaseFirestore.instance.collection('jobs');
//Creates a job.
  Future<void> createJob(Job job) async {
    DocumentReference jobRef =
        FirebaseFirestore.instance.collection('jobs').doc();

    await jobRef.set({
      'title': job.title,
      'description': job.description,
      'userId': job.userId,
      'requirment': job.requirment,
      'adress': job.adress,
      'createdby': job.createdby,
      'rate': job.rate,
      'mobile': job.mobile,
      'lat': job.lat,
      'lon': job.lon,
      'documentId': jobRef.id,
    });
   //Print job creation to console.
    log('New job created with document ID: ${jobRef.id}');
  }
}
