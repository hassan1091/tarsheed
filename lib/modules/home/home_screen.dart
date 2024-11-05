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
import 'package:tarsheed/services/firebase/auth_firebase_service.dart';
import 'package:tarsheed/services/firebase/firebase_service.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          const RoutinesView(),
          BlocProvider(
            create: (context) => HomeBloc()..add(LoadHomeEvent()),
            child: const HomeView(),
          ),
          const ReportView(),
        ],
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
    await FirebaseService().getUserDevices();
  }
}
