import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static const Color bluishClr = Colors.blueAccent;
  static const Color yellowClr = Color(0xFFFFB746);
  static const Color pinkClr = Color(0XFFFf4667);
  static const Color white = Colors.white;
  static const primaryClr = bluishClr;
  static const Color darkGreyClr = Color(0xFF121212);
  Color darkHeaderClr = Color(0xFF424242);

  static final light = ThemeData(
    backgroundColor: primaryClr,
    primaryColor: primaryClr,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryClr,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: primaryClr),
    ),
  );

  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: darkGreyClr,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: darkGreyClr),
    ),
  );
}

//sub heading style
TextStyle get largeHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Themes.white : Themes.darkGreyClr),
  );
}

//sub heading style
TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey),
  );
}

// heading style
TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

// title style
TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

// subtitle style
TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
    ),
  );
}
