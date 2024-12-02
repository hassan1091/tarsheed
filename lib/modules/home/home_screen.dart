import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';
import 'package:tarsheed/modules/home/blocs/home_bloc/home_bloc.dart';
import 'package:tarsheed/modules/home/views/home_view.dart';
import 'package:tarsheed/modules/home/views/report_view.dart';
import 'package:tarsheed/modules/home/views/routines_view.dart';
import 'package:tarsheed/modules/main/main_screen.dart';
import 'package:tarsheed/modules/profile/bloc/profile_bloc.dart';
import 'package:tarsheed/modules/profile/profile_screen.dart';
import 'package:tarsheed/services/firebase/auth_firebase_service.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = _pageController.initialPage;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        AppTheme.showSnackBar(context, message.notification!.body ?? "");
        context.read<HomeBloc>().add(LoadHomeEvent());
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        context.read<HomeBloc>().add(LoadHomeEvent());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSafeMode = Theme.of(context).colorScheme.background !=
        AppConstants.safeBackgroundColor;
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text(AppConstants.appName),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
        leading: IconButton(
          icon: const Icon(CupertinoIcons.person_crop_circle),
          onPressed: () => profilePressed(context),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: const [
          RoutinesView(),
          HomeView(),
          ReportView(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isSafeMode
          ? null
          : const Card(
              color: Colors.purple,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Safe Mode Is Active",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_open),
            label: "Routines",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Report",
          ),
        ],
      ),
    );
  }

  void logout(context) {
    AuthFirebaseService().signOut().then(
      (_) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const MainScreen(),
            ),
            (_) => false);
      },
    ).onError((error, stackTrace) {
      if (error is PublicException) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    });
  }

  Future<void> profilePressed(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ProfileBloc(),
            child: const ProfileScreen(),
          ),
        ));
  }
}
