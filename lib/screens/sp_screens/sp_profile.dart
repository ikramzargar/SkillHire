import 'package:flutter/material.dart';

class SpProfile extends StatefulWidget {
  const SpProfile({super.key});

  @override
  State<SpProfile> createState() => _SpProfileState();
}

class _SpProfileState extends State<SpProfile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            height: 10,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(60), // Image radius
                child: Image.asset('images/logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Welcome Service Provider!', style: TextStyle(fontSize: 35)),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  'Name :',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Ikram zargar',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  'Email :',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    'ikramxargar@gmail.com',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    maxLines: 2, // Limit to 2 lines
                    overflow:
                    TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  'Mobile No. :',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '6005588250',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: MaterialButton(
              onPressed: () {},
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 25),
              ),
              color: Colors.green,
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Developed by',style: TextStyle(fontSize: 20),),
                SizedBox(height: 10,),
                Text('Ikram Zargar',style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10,),
                Text('www.ikramzargar.netlify.app',style: TextStyle(fontSize: 20),
                ),
              ],),
          ),
        ],
      ),
    );
  }
}
