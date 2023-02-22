import 'package:flutter/material.dart';

import 'constant.dart';

class AppThemes {
  static final kThemeData = ThemeData.dark().copyWith(
    primaryColor: Constants.primaryColor,
    scaffoldBackgroundColor: const Color(0xFFffffff),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.blueAccent,
      primary: Constants.blue500,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Constants.blue500,
      foregroundColor: Colors.white,
    ),
  );
}