import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//Contains all the Text Styles used in the app.
class AppTextStyles {
  static TextStyle heading1() {
    return GoogleFonts.oswald(
      fontSize: 60,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle heading1blue() {
    return GoogleFonts.oswald(
      fontSize: 60,
      color: Color(0xff2E279D),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle heading2() {
    return GoogleFonts.oswald(
      fontSize: 40,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle heading2Normal() {
    return GoogleFonts.oswald(
      fontSize: 40,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle heading2white() {
    return GoogleFonts.oswald(
      fontSize: 40,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle normalText1() {
    return GoogleFonts.openSans(
      fontSize: 25,
      color: Colors.black,
    );
  }

  static TextStyle tileText() {
    return GoogleFonts.openSans(
      fontSize: 18,
      color: Colors.black,
    );
  }

  static TextStyle normalText1White() {
    return GoogleFonts.openSans(
      fontSize: 25,
      color: Colors.white,
    );
  }

  static TextStyle textfieldStyle1() {
    return GoogleFonts.openSans(
      fontSize: 17,
      color: Colors.black,
    );
  }
}
