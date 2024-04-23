import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// Dsiplay ratings.
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
      log('Error getting average rating: $e');
    }

    // Default to 0 if there are no ratings or an error occurs
    return 0;
  }

  static Future<int> getRatingCount(String userId) async {
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

        // Return the length of the ratings array
        log('no of ratings${ratings.length}');
        return ratings.length;
      }
    } catch (e) {
      log('Error getting rating count: $e');
    }

    // Default to 0 if there are no ratings or an error occurs
    return 0;
  }
}
