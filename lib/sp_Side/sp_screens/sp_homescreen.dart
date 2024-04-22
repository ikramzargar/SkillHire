import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skill_hire/globals/app_Colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';

class SpHome extends StatefulWidget {
  const SpHome({super.key});

  @override
  State<SpHome> createState() => _SpHomeState();
}

class _SpHomeState extends State<SpHome> {
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

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
  }

  void _updateSwitchState(bool newValue) {
    setState(() {
      status = newValue;
    });

    _docRef.set({'available': newValue}, SetOptions(merge: true)).then((_) {
      print('Switch state updated in Firestore');
    }).catchError((error) {
      print('Failed to update switch state: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(60), // Image radius
                child: Image.asset('images/logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome!',
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.mainBgColor2, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Availability',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
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

          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'My Ratings',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
             child:     StreamBuilder<DocumentSnapshot>(
               stream: _firestore.collection('Ratings').doc(userId).snapshots(),
               builder: (context, snapshot) {
                 if (snapshot.hasData && snapshot.data != null) {
                   var data = snapshot.data!.data() as Map<String, dynamic>?;

                   if (data != null && data['ratings'] != null && data['names'] != null){
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
                                         itemBuilder: (context, index) => Icon(
                                           Icons.star,
                                           color: Colors.amber,
                                         ),
                                         itemCount: 5,
                                         itemSize: 30,
                                         unratedColor: Colors.grey[300],
                                       ),
                                       SizedBox(width: 10,),
                                       Text('('+ ratings[index].toString()+')'),
                                     ],
                                   ),
                                   SizedBox(height: 10),
                                   Row(
                                     children: [
                                       Text('By : ',style: AppTextStyles.normalText1().copyWith(fontSize: 20),),
                                       Text(
                                         '${names[index]}',
                                           style: AppTextStyles.normalText1().copyWith(fontSize: 20),
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

                 return Center(
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
