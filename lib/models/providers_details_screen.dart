import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import '../globals/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../sp_Side/rating_helper.dart';
import 'package:url_launcher/url_launcher.dart';

//Show Service Providers detail.
class ProviderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> spData;

  const ProviderDetailsScreen({Key? key, required this.spData})
      : super(key: key);

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen> {
  //Function to save rating.
  Future<void> _saveRating(double rating, String userId, String name) async {
    try {
      CollectionReference ratingsCollection =
          FirebaseFirestore.instance.collection('Ratings');
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await ratingsCollection.doc(userId).get()
              as DocumentSnapshot<Map<String, dynamic>>;

      // Extract existing ratings and names arrays or initialize empty arrays
      List<dynamic> existingRatings =
          docSnapshot.exists && docSnapshot.data() != null
              ? docSnapshot.data()!['ratings'] ?? []
              : [];
      List<dynamic> existingNames =
          docSnapshot.exists && docSnapshot.data() != null
              ? docSnapshot.data()!['names'] ?? []
              : [];

      // Append the new rating and name to their respective arrays
      existingRatings.add(rating);
      existingNames.add(name);

      // Update the document with the updated ratings and names arrays
      await ratingsCollection.doc(userId).set({
        'userId': userId,
        'ratings': existingRatings,
        'names': existingNames,
      });
    } catch (e) {
      //Print error.
      log('Error saving rating: $e');
    }
  }

  String userName = '';
  double initialRating = 0;
  int noOfRatings = 0;
  @override
  void initState() {
    fetchInitialRating(widget.spData['userId']);
    fetchNoOfRatings(widget.spData['userId']);
    fetchUserName();
    super.initState();
  }

//Function to fetch initial rating.
  Future<void> fetchInitialRating(String userId) async {
    try {
      double averageRating = await RatingHelper.getAverageRating(userId);
      setState(() {
        initialRating = averageRating;
      });
    } catch (e) {
      //Print error.
      log('Error fetching initial rating: $e');
    }
  }

//Function to fetch number of ratings.
  Future<void> fetchNoOfRatings(String userId) async {
    try {
      int totalNoOfRatings = await RatingHelper.getRatingCount(userId);
      setState(() {
        noOfRatings = totalNoOfRatings;
      });
    } catch (e) {
      //Print error.
      log('Error fetching initial rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final spId = widget.spData['userId'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Details'),
      ),
      backgroundColor: AppColors.mainBgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _buildDetailRow('Name :', widget.spData['name'] ?? ''),
            const SizedBox(height: 10),
            _buildDetailRow('Profession :', widget.spData['profession'] ?? ''),
            const SizedBox(height: 10),
            _buildDetailRow('Experience :', widget.spData['experience'] ?? ''),
            const SizedBox(height: 10),
            _buildDetailRow('Address :', widget.spData['address'] ?? ''),
            const SizedBox(height: 10),
            _buildDetailRow(
                'Expected Rate :', 'Rs ${widget.spData['rate'] ?? ''}'),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  elevation: 1,
                  color: AppColors.buttonColor1,
                  onPressed: () {
                    _launchCaller(widget.spData[
                        'mobileNo']); // Call function to launch phone dialer
                  },
                  child: Row(
                    children: [
                      Text(
                        'Call ',
                        style: AppTextStyles.normalText1(),
                      ),
                      const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Ratings',
                      style:
                          AppTextStyles.heading2Normal().copyWith(fontSize: 30),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        //Build rating bar.
                        RatingBar.builder(
                          initialRating: initialRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (newRating) {
                            _saveRating(newRating, spId,
                                userName); // Call function to save rating
                          },
                        ),
                        Text('(${initialRating.toStringAsFixed(1)})'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Rated by $noOfRatings users',
                      style: AppTextStyles.normalText1().copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: AppColors.buttonColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5.0,
                height: 40,
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }

//Widget build method.
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ',
          style: AppTextStyles.normalText1(),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.normalText1(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

//Function to fetch user Name.
  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userdata = await FirebaseFirestore.instance
            .collection('userdata')
            .doc(user.uid)
            .get();
        if (userdata.exists) {
          log('User Data Retrieved Successfully: ${userdata.data()}');
          setState(() {
            userName = userdata['name'] ?? '';
          });
        } else {
          log('SpData Does Not Exist for UserID: ${user.uid}');
        }
      } else {
        log('No User is Currently Signed In');
      }
    } catch (e) {
      log('Error Fetching User Data: $e');
    }
  }

//Function to launch dialer.
  Future<void> _launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(url);
  }
}
