import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/config//firebase_options.dart';
import 'package:tarsheed/config/firebase_messaging_service.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/modules/home/blocs/home_bloc/home_bloc.dart';
import 'package:tarsheed/modules/home/blocs/routines_bloc/routines_bloc.dart';
import 'package:tarsheed/modules/home/home_screen.dart';
import 'package:tarsheed/modules/main/main_screen.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();
  FirebaseMessagingService.setupFirebaseMessaging();

  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error initializing Firebase: $e\n$stackTrace');
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _requestFirebasePermissions();
  }

  Future<void> _requestFirebasePermissions() async {
    try {
      final settings = await FirebaseMessaging.instance
          .requestPermission(criticalAlert: true);

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseMessagingService.updateFcmToken();
        }
      } else {
        _showSnackBar('Notifications permission denied');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error requesting permissions: $e\n$stackTrace');
      }
      _showSnackBar('Error requesting permissions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.darkTheme,
      home: FirebaseAuth.instance.currentUser == null
          ? const MainScreen()
          : MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => HomeBloc()..add(LoadHomeEvent())),
                BlocProvider(
                    create: (_) => RoutinesBloc()..add(LoadRoutinesEvent())),
              ],
              child: const HomeScreen(),
            ),
    );
  }

  void _showSnackBar(String message) {
    Future.microtask(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });
  }
}
