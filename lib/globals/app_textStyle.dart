import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {

static TextStyle heading1(){
  return GoogleFonts.oswald(
    fontSize: 60,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
}

}
