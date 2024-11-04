import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/screens/home/views/home_view.dart';

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
          child: Text('Tarsheed'),
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
          Text("Routines"),
          HomeView(),
          Text("Report"),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void profilePressed(context) {}
}
