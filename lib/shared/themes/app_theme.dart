import 'package:flutter/material.dart';
import 'package:tarsheed/core/constants/app_constants.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppConstants.primaryColor,
      background: AppConstants.backgroundColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    filledButtonTheme: const FilledButtonThemeData(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))))),
    ),
    useMaterial3: true,
  );
}
