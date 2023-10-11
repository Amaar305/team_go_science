import 'package:flutter/material.dart';

import '../utils/constants.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: kSecondary,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20.0, ),
      iconTheme: IconThemeData(
        // color: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    useMaterial3: true,
    colorScheme:  ColorScheme.light(
      background: kSecondary,
      primary: kPrimary,
      secondary: kSecondary,
    ));

// background: Color(0xFF9FA8DA),
//     primary: Color(0xFF7986CB),
//     secondary: Color(0xFF7986CB),