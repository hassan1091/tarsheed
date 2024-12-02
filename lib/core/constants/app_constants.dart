import 'package:flutter/material.dart';

class AppConstants {
  // App-wide static text
  static const String appName = 'Tarsheed';

  // Color constants
  static const Color primaryColor = Color(0xFF007FFF);
  static const Color safeColor = Color(0xFF7300FF);
  static const Color backgroundColor = Color(0x2E2E3EFF);
  static const Color safeBackgroundColor = Color(0x2E9A2EFF);
  static const ShapeBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    side: BorderSide(color: Colors.white),
  );
}

enum Periodic { daily, monthly, yearly }
