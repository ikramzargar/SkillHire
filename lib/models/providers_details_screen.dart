import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../globals/app_Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> spData;

  const ProviderDetailsScreen({Key? key, required this.spData})
      : super(key: key);

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen> {
  double _rating = 0.0;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save rating to Firestore

  Future<void> _saveRating(double rating, String userId, String name) async {
    try {
      // Reference to the Ratings collection
      CollectionReference ratingsCollection =
          FirebaseFirestore.instance.collection('Ratings');

      // Get the existing document snapshot
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
      print('Error saving rating: $e');
    }
  }

  String userName = '';
  double initialRating = 0;
  @override
  void initState() {
    fetchInitialRating(widget.spData['userId']);
    fetchUserName();
    super.initState();
  }
  Future<void> fetchInitialRating(String userId) async {
    try {
      double averageRating = await RatingHelper.getAverageRating(userId);
      setState(() {
        initialRating = averageRating;
      });
    } catch (e) {
      print('Error fetching initial rating: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final spId = widget.spData['userId'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Details'),
      ),
      backgroundColor: AppColors.mainBgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _buildDetailRow('Name:', widget.spData['name'] ?? ''),
            _buildDetailRow('Profession:', widget.spData['profession'] ?? ''),
            _buildDetailRow('Experience:', widget.spData['experience'] ?? ''),
            _buildDetailRow('Address:', widget.spData['address'] ?? ''),
            _buildDetailRow('Mobile No.:', widget.spData['mobileNo'] ?? ''),
            _buildDetailRow(
                'Expected Rate:', 'Rs ${widget.spData['rate'] ?? ''}'),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border(top:BorderSide(),bottom: BorderSide(),right: BorderSide(),left: BorderSide()),
              ),
              child: RatingBar.builder(
                initialRating: initialRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating:true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  setState(() {
                    _rating = newRating;
                  });
                  _saveRating(
                      newRating, spId, userName); // Call function to save rating
                },
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
              color: AppColors.buttonColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5.0,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ',
          style: TextStyle(fontSize: 20),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userdata = await FirebaseFirestore.instance
            .collection('userdata')
            .doc(user.uid)
            .get();
        if (userdata.exists) {
          print('Sp Data Retrieved Successfully: ${userdata.data()}');
          setState(() {
            userName = userdata['name'] ?? '';
          });
        } else {
          print('User Data Does Not Exist for UserID: ${user.uid}');
        }
      } else {
        print('No User is Currently Signed In');
      }
    } catch (e) {
      print('Error Fetching User Data: $e');
    }
  }
}

class RatingHelper {
  static Future<double> getAverageRating(String userId) async {
    try {
      // Reference to the Ratings collection
      CollectionReference ratingsCollection =
          FirebaseFirestore.instance.collection('Ratings');

      // Get the document snapshot for the specified userId
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await ratingsCollection.doc(userId).get()
              as DocumentSnapshot<Map<String, dynamic>>;

      if (docSnapshot.exists && docSnapshot.data() != null) {
        List<dynamic> ratings = docSnapshot.data()!['ratings'] ?? [];

        if (ratings.isNotEmpty) {
          // Calculate the average of ratings
          double sum = 0;
          for (var rating in ratings) {
            if (rating is num) {
              sum += rating;
            }
          }

          // Calculate the average rating
          double averageRating = sum / ratings.length;

          return averageRating;
        }
      }
    } catch (e) {
      print('Error getting average rating: $e');
    }

    // Default to 0 if there are no ratings or an error occurs
    return 0;
  }
}
