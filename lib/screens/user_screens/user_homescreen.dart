import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  size: 50,
                )),
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
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(child: Text('No active tasks!',style: TextStyle(fontSize: 20),),),
          ),
        ],
      ),
    );
  }
}
