import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/config//firebase_options.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/modules/home/home_screen.dart';
import 'package:tarsheed/modules/main/main_screen.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';

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
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.darkTheme,
      home: FirebaseAuth.instance.currentUser == null
          ? const MainScreen()
          : const HomeScreen(),
    );
  }
}
