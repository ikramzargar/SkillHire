import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../globals/app_colors.dart';
import '../../globals/app_textStyle.dart';
import '../../models/providers_details_screen.dart';

// Providers screen for user.
class UserProviders extends StatefulWidget {
  const UserProviders({super.key});

  @override
  State<UserProviders> createState() => _UserProvidersState();
}

class _UserProvidersState extends State<UserProviders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // Get providers from firebase
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

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text('No available service providers.'),
            );
          } else {
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final spData = docs[index].data();

                if (spData is Map<String, dynamic>) {
                  return Hero(
                    tag: 'ListTile-Hero-$spData',
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        child: ListTile(
                          tileColor: AppColors.mainBgColor2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          trailing: const CircleAvatar(
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Name :',
                                    style: AppTextStyles.tileText(),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      spData['name'] ?? '',
                                      maxLines: 2,
                                      style: AppTextStyles.tileText(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Profession :',
                                    style: AppTextStyles.tileText(),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    spData['profession'] ?? '',
                                    style: AppTextStyles.tileText(),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Experience :',
                                    style: AppTextStyles.tileText(),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    spData['experience'] ?? '',
                                    style: AppTextStyles.tileText(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProviderDetailsScreen(spData: spData),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          }
        },
      ),
    );
  }
}
