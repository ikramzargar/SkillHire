// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../globals/app_Colors.dart';
// import '../../globals/app_textStyle.dart';
//
// class JobDetailsScreen extends StatefulWidget {
//   final DocumentSnapshot<Map<String, dynamic>> jobSnapshot;
//
//   const JobDetailsScreen({Key? key, required this.jobSnapshot}) : super(key: key);
//
//   @override
//   State<JobDetailsScreen> createState() => _JobDetailsScreenState();
// }
//
// class _JobDetailsScreenState extends State<JobDetailsScreen> {
//   late Map<String, dynamic> job;
//
//   @override
//   void initState() {
//     super.initState();
//     job = widget.jobSnapshot.data() ?? {};
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Job Details'),
//       ),
//       backgroundColor: AppColors.mainBgColor,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildDetailRow('Title:', job['title'] ?? ''),
//             _buildDetailRow('Requirment:', job['requirment'] ?? ''),
//             _buildDetailRow('Description:', job['description'] ?? ''),
//             _buildDetailRow('Address:', job['address'] ?? ''),
//             _buildDetailRow('Created by:', job['createdby'] ?? ''),
//             _buildDetailRow('Mobile No.:', job['mobile'] ?? ''),
//             _buildDetailRow('Expected Rate (Rs):', job['rate'] ?? ''),
//             SizedBox(height: 20),
//             MaterialButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Back'),
//               color: AppColors.buttonColor1,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               elevation: 5.0,
//               height: 40,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$label ',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(fontSize: 18),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
