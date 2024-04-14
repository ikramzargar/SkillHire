import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class SpJobs extends StatefulWidget {
//   const SpJobs({super.key});
//
//   @override
//   State<SpJobs> createState() => _SpJobsState();
// }
//
// class _SpJobsState extends State<SpJobs> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(height: 20,),
//           Center(child: Text('Available Jobs',style: TextStyle(fontSize: 25),))
//         ],
//       ),
//     );
//   }
// }

class SpJobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final jobs = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            final jobId = job.id; // Get the Firestore document ID

            return Hero(
              tag: 'ListTile-Hero-$jobId',
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    title: Text(job['title'] ?? ''),
                    subtitle: Text('Created by: ${job['userId']}'),
                    tileColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text(job['title'] ?? '')),
                            body: Center(
                              child: Hero(
                                tag: 'ListTile-Hero-$jobId',
                                child: Material(
                                  child: ListTile(
                                    title: Text(job['title'] ?? ''),
                                    subtitle: Text('Created by: ${job['userId']}'),
                                    tileColor: Colors.green,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
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
        // return ListView.builder(
        //   itemCount: jobs.length,
        //   itemBuilder: (context, index) {
        //     final job = jobs[index];
        //     return Hero(
        //       tag: 'ListTile-Hero',
        //       // Wrap the ListTile in a Material widget so the ListTile has someplace
        //       // to draw the animated colors during the hero transition.
        //       child: Material(
        //         child: ListTile(
        //           title: const Text('ListTile with Hero'),
        //           subtitle: const Text('Tap here for Hero transition'),
        //           tileColor: Colors.cyan,
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute<Widget>(builder: (BuildContext context) {
        //                 return Scaffold(
        //                   appBar: AppBar(title: const Text('ListTile Hero')),
        //                   body: Center(
        //                     child: Hero(
        //                       tag: 'ListTile-Hero',
        //                       child: Material(
        //                         child: ListTile(
        //                           title: const Text('ListTile with Hero'),
        //                           subtitle: const Text('Tap here to go back'),
        //                           tileColor: Colors.blue[700],
        //                           onTap: () {
        //                             Navigator.pop(context);
        //                           },
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 );
        //               }),
        //             );
        //           },
        //         ),
        //       ),
        //     );
        //
        //     //   ListTile(
        //     //   title: Text(job['title'] ?? ''),
        //     //   subtitle: Text('Created by: ${job['userId']}'),
        //     //   // Add more job details as needed
        //     // );
        //   },
        // );
      },
    );
  }



}
class AddTaskScreen extends StatelessWidget {
  late String newTask;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20),)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.lightBlueAccent,
              ),),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText){
                newTask = newText;
              },
            ),
            ElevatedButton(
              child: Text('Add', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}