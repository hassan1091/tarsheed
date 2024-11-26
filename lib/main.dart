import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/config//firebase_options.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/modules/home/blocs/home_bloc/home_bloc.dart';
import 'package:tarsheed/modules/home/blocs/routines_bloc/routines_bloc.dart';
import 'package:tarsheed/modules/home/home_screen.dart';
import 'package:tarsheed/modules/main/main_screen.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
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
          : MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => HomeBloc()..add(LoadHomeEvent()),
                ),
                BlocProvider(
                  create: (context) => RoutinesBloc()..add(LoadRoutinesEvent()),
                )
              ],
              child: const HomeScreen(),
            ),
    );
  }
}
