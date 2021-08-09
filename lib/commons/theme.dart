import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryColor = Color(0xFFFFFFFF);
final Color primaryLightColor = Color(0xFFFFFFFF);
final Color primaryDarkColor = Color(0xFFCCCCCC);
final Color secondaryColor = Color(0xFFEE022C);
final Color secondaryDarkColor = Color(0xFFB30004);
final Color primaryTextColor = Color(0xFF000000);
final Color secondaryTextColor = Color(0xFFFFFFFF);

final TextTheme myTextTheme = TextTheme(
  headline1: GoogleFonts.tajawal(
      fontSize: 112, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.tajawal(
      fontSize: 70, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.tajawal(fontSize: 56, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.tajawal(
      fontSize: 40, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.tajawal(fontSize: 28, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.tajawal(
      fontSize: 23, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.tajawal(
      fontSize: 19, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.tajawal(
      fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.montserrat(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

ThemeData lightTheme = ThemeData(
  primaryColor: primaryColor,
  accentColor: secondaryColor,
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  appBarTheme: AppBarTheme(
    textTheme: myTextTheme.apply(bodyColor: primaryTextColor),
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: secondaryColor,
    unselectedItemColor: Colors.grey,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: secondaryColor,
      textStyle: TextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: primaryDarkColor,
  accentColor: secondaryDarkColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  appBarTheme: AppBarTheme(
    textTheme: myTextTheme.apply(bodyColor: Colors.white),
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: secondaryColor,
    unselectedItemColor: Colors.grey,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: secondaryColor,
      textStyle: TextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
);
