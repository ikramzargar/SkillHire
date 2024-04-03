import 'package:flutter/material.dart';
import 'package:skill_hire/globals/app_textStyle.dart';

class SpForm extends StatefulWidget {
  const SpForm({super.key});

  @override
  State<SpForm> createState() => _SpFormState();
}

class _SpFormState extends State<SpForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController professionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text('Let`s get you started.',
                    style: AppTextStyles.heading1()),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 2)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Mobile No.',
                    style: TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: noController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    style: TextStyle(fontSize: 30),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Adress',
                    style: TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: addressController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 2)),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Profession',
                    style: TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: professionController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 2)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {},
              color: Colors.green,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
