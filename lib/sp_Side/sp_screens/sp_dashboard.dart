import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skill_hire/globals/app_colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';

// Dashboard for Service Provider
class SpDashboard extends StatefulWidget {
  const SpDashboard({super.key});

  @override
  State<SpDashboard> createState() => _SpDashboardState();
}

class _SpDashboardState extends State<SpDashboard> {
  bool status = true;
  late FirebaseFirestore _firestore;
  late DocumentReference _docRef;
  String? userId = '';

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    getCurrentUserId();
    if (userId != null) {
      _docRef = _firestore.collection('spdata').doc(userId);
      _docRef.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          setState(() {
            status = docSnapshot['available'] ?? true;
          });
        }
      });
    }
  }

// Function to get current user id.
  void getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
  }

// Function to update availibility switch.
  void _updateSwitchState(bool newValue) {
    setState(() {
      status = newValue;
    });

    _docRef.set({'available': newValue}, SetOptions(merge: true)).then((_) {
      log('Switch state updated in Firestore');
    }).catchError((error) {
      log('Failed to update switch state: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Image.asset(
              'images/logo.png',
              scale: 1.5,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              'Welcome!',
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.mainBgColor2,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Availability',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Switch(
                    value: status,
                    activeColor: AppColors.otherColor,
                    onChanged: (bool value) {
                      setState(() {
                        _updateSwitchState(value);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Click on the button to toggle availability.',
              style: AppTextStyles.normalText1().copyWith(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'My Ratings',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: StreamBuilder<DocumentSnapshot>(
              // Get ratings from FireStore.
              stream: _firestore.collection('Ratings').doc(userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var data = snapshot.data!.data() as Map<String, dynamic>?;

                  if (data != null &&
                      data['ratings'] != null &&
                      data['names'] != null) {
                    List<dynamic> ratings = data['ratings'];
                    List<dynamic> names = data['names'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(ratings.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.mainBgColor2,
                                width: 3.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: ratings[index].toDouble(),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 30,
                                        unratedColor: Colors.grey[300],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('(${ratings[index]})'),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        'By : ',
                                        style: AppTextStyles.normalText1()
                                            .copyWith(fontSize: 20),
                                      ),
                                      Text(
                                        '${names[index]}',
                                        style: AppTextStyles.normalText1()
                                            .copyWith(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }
                }

                return const Center(
                  child: Text(
                    'No ratings yet!',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
