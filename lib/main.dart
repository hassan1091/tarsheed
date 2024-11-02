import 'package:flutter/material.dart';
import 'package:tarsheed/screens/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF007FFF);
    return MaterialApp(
      title: 'Tarsheed',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          background: const Color(0x2e2e3eff),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))))),
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
