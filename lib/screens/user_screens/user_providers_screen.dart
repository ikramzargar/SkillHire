import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProviders extends StatefulWidget {
  @override
  State<UserProviders> createState() => _UserProvidersState();
}

class _UserProvidersState extends State<UserProviders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('spdata')
            .where('available', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text('No available service providers.'),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final spData = docs[index].data();

              if (spData is Map<String, dynamic>) {
                final name = spData['name'] as String?;
                final profession = spData['profession'] as String?;

                return ListTile(
                  title: Text(name ?? 'No Name'),
                  subtitle: Text(profession ?? 'No Profession'),
                );
              }
              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
