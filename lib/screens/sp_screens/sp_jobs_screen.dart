import 'package:flutter/material.dart';

class SpJobs extends StatefulWidget {
  const SpJobs({super.key});

  @override
  State<SpJobs> createState() => _SpJobsState();
}

class _SpJobsState extends State<SpJobs> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          Center(child: Text('Available Jobs',style: TextStyle(fontSize: 25),))
        ],
      ),
    );
  }
}
