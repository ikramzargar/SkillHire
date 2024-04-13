import 'package:flutter/material.dart';

class SpHome extends StatefulWidget {
  const SpHome({super.key});

  @override
  State<SpHome> createState() => _SpHomeState();
}

class _SpHomeState extends State<SpHome> {
  bool light = false;
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Click on the button to toggle availability.',
              style: TextStyle(fontSize: 25),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10)),
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
                    value: light,
                    activeColor: Colors.red,
                    onChanged: (bool value) {
                      setState(() {
                        light = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Center(child: Text('My Ratings', style: TextStyle(fontSize: 30),),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(child: Text('No ratings yet!',style: TextStyle(fontSize: 20),),),
          )
        ],
      ),
    );
  }
}
