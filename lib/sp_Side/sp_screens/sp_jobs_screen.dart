import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
            final jobId = job.id;

            return Hero(
              tag: 'ListTile-Hero-$jobId',
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Text(job['title'] ?? ''),
                            SizedBox(width: 100,),
                            Text(job['requirment']?? ''),
                          ],
                        ),
                        Text('Created by: ${job['createdby']}'),
                      ],
                    ),
                    subtitle: Text('Click to know more.'),
                    tileColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text('Job')),
                            body:Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  SizedBox(height: 30,),
                                  Row(
                                    children: [
                                      Text('Title : ',style: TextStyle(fontSize: 20),),
                                      Text(job['title'] ?? '',style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text('Requirment : ',style: TextStyle(fontSize: 20),),
                                      Text(job['requirment'] ?? '',style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text('Description : ',style: TextStyle(fontSize: 20),),
                                      Text(job['description'] ?? '',style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text('Address : ',style: TextStyle(fontSize: 20),),
                                      Text(job['adress'] ?? '',style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text('Created by : ',style: TextStyle(fontSize: 20),),
                                      Text(job['createdby'] ?? '',style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text('Mobile No. : ',style: TextStyle(fontSize: 20),),
                                      Text(job['mobile'] ?? '',style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text('Expected Rate : ',style: TextStyle(fontSize: 20),),
                                      Text(job['rate'] ?? '',style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  MaterialButton(
                                    onPressed: (){Navigator.pop(context);},child: Text('Back'),
                                    color: Colors.green,
                                  )
                                ],
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