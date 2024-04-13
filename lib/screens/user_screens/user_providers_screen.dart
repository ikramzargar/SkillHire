import 'package:flutter/material.dart';

class UserProviders extends StatefulWidget {
  const UserProviders({super.key});

  @override
  State<UserProviders> createState() => _UserProvidersState();
}

class _UserProvidersState extends State<UserProviders> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          Center(child: Text('Available Providers',style: TextStyle(fontSize: 25),))
        ],
      ),
    );
  }
}
