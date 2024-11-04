import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/firebase_options.dart';
import 'package:tarsheed/screens/home/home_screen.dart';
import 'package:tarsheed/screens/main/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
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
      home: FirebaseAuth.instance.currentUser == null
          ? const MainScreen()
          : const HomeScreen(),
    );
  }
}
