import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skill_hire/globals/app_colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Jobs screen for service providers.
class SpJobs extends StatelessWidget {
  const SpJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Fetch jobs from firestore.
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final jobs = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            final jobId = job.id;
            final latlon = LatLng(job['lat'], job['lon']);

            return Hero(
              tag: 'ListTile-Hero-$jobId',
              child: Material(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: ListTile(
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
                              'Title :',
                              style: AppTextStyles.tileText(),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                job['title'] ?? '',
                                maxLines: 2,
                                style: AppTextStyles.tileText(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ), //
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Requirment :',
                              style: AppTextStyles.tileText(),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              job['requirment'] ?? '',
                              style: AppTextStyles.tileText(),
                            ),
                          ],
                        ),
                        Text(
                          'Created by: ${job['createdby']}',
                          style: AppTextStyles.tileText(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    tileColor: AppColors.mainBgColor2,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: const Text('Job')),
                            backgroundColor: AppColors.mainBgColor,
                            body: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Title : ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Expanded(
                                          child: Text(
                                            job['title'] ?? '',
                                            style:
                                                const TextStyle(fontSize: 20),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Requirment : ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          job['requirment'] ?? '',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Description : ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Expanded(
                                          child: Text(
                                            job['description'] ?? '',
                                            style:
                                                const TextStyle(fontSize: 20),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Address : ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Expanded(
                                          child: Text(
                                            job['adress'] ?? '',
                                            style:
                                                const TextStyle(fontSize: 20),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Created by : ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          job['createdby'] ?? '',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Expected Rate : Rs ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          job['rate'] ?? '',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MaterialButton(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                          ),
                                          elevation: 1,
                                          color: AppColors.buttonColor1,
                                          onPressed: () {
                                            _launchCaller(job['mobile']);
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Call ',
                                                style:
                                                    AppTextStyles.normalText1(),
                                              ),
                                              const Icon(
                                                Icons.phone,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: GoogleMap(
                                        // Display Google Maps.
                                        scrollGesturesEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                            target: latlon, zoom: 15),
                                        markers: {
                                          Marker(
                                            markerId:
                                                const MarkerId('location'),
                                            position: latlon,
                                            infoWindow: InfoWindow(
                                              title: job['createdby'] ?? '',
                                              snippet: job['adress'] ?? '',
                                            ),
                                          ),
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color: AppColors.buttonColor1,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      elevation: 5.0,
                                      height: 40,
                                      child: const Text('Back'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// Function to launch dialer.
  Future<void> _launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(url);
  }
}
