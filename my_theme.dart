import 'package:flutter/material.dart';


const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = Colors.grey.shade800;


final ThemeData lightTheme = ThemeData(
  primaryColor: primaryClr,
  brightness: Brightness.light,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryClr // Light theme color for AppBar
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: darkGreyClr,
  brightness: Brightness.dark,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: darkHeaderClr, // Dark theme color for AppBar
  ),
);
