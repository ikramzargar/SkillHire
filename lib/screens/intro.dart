import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:skill_hire/globals/app_textStyle.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                text: 'Skill',
                style: AppTextStyles.heading1(),
                children: [
                  TextSpan(
                    text: 'Hire',
                    style: AppTextStyles.heading1()
                        .copyWith(color: Colors.green),
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
                  textStyle: AppTextStyles.heading1().copyWith(
                    color: Colors.green,
                  ),
                ),
                TyperAnimatedText(
                  'Reliable',
                  textStyle: AppTextStyles.heading1().copyWith(
                    color: Colors.green,
                  ),
                ),
                TyperAnimatedText(
                  'Secure',
                  textStyle: AppTextStyles.heading1().copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
              repeatForever: true,
            ),
          ),
          const SizedBox(height: 50,),
          Center(
            child: MaterialButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {},
              child: const  Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Let`s Start',style: TextStyle(fontSize: 30),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
