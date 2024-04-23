import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skill_hire/globals/app_colors.dart';
import 'package:skill_hire/globals/app_textStyle.dart';

//Splash Screen.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                text: 'Skill',
                style: AppTextStyles.heading1(),
                children: [
                  TextSpan(
                    text: 'Hire',
                    style: AppTextStyles.heading1blue(),
                  ),
                ],
              ),
            ),
          ),
          Center(child: Image.asset('images/logo.png')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'It`s',
              style: AppTextStyles.heading1(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Fast',
                  textStyle: AppTextStyles.heading1blue(),
                ),
                TyperAnimatedText(
                  'Reliable',
                  textStyle: AppTextStyles.heading1blue(),
                ),
                TyperAnimatedText(
                  'Secure',
                  textStyle: AppTextStyles.heading1blue(),
                ),
              ],
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
              repeatForever: true,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: MaterialButton(
              color: AppColors.buttonColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () async {
                // Request location permission
                var status = await Permission.location.request();
                if (status.isGranted) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  // Permission is not granted, show a dialog and close the app
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Permission Required'),
                      content: const Text(
                          'Please grant location permission to proceed.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Close the app when permission is denied
                            SystemNavigator.pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Let`s Start',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
