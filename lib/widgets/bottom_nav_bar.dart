import 'package:flutter/material.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/screens.dart';
import 'package:hamro_gadgets/allcategories.dart';
import 'package:hamro_gadgets/home_screen.dart';
import 'package:hamro_gadgets/profile.dart';
import 'package:hamro_gadgets/search_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavigationScreen extends StatefulWidget {
  NavigationScreen({this.currentScreen});
  final CurrentScreen currentScreen;
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with SingleTickerProviderStateMixin {
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen;
  int currentTab;
  AnimationController _controller;

//  final double pi = math.pi;
  final double tilt90Degrees = 90;
  double angle = 0;

  bool get _isPanelVisible {
    return angle == tilt90Degrees ? true : false;
  }
  @override
  initState() {
    super.initState();

    currentScreen = widget.currentScreen?.currentScreen ?? HomeScreen();
    currentTab = widget.currentScreen?.tab_no ?? 0;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
//      value: 1,
      vsync: this,
    );
  }
  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  changeScreen({
    @required Widget currentScreen,
    @required int currentTab,
  }) {
    setState(() {
      this.currentScreen = currentScreen;
      this.currentTab = currentTab;
    });
  }
  void changeAngle() {
    if (angle == 0) {
      setState(() {
        angle = tilt90Degrees;
      });
    } else {
      setState(() {
        angle = 0;
      });
    }
  }
  PersistentTabController _controllerTab =
  PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return  PersistentTabView(context,
      backgroundColor: primarycolor,

      controller: _controllerTab,
      items: _navBarsItems(),
      screens: _buildScreens(),
//      showElevation: true,
//      navBarCurve: NavBarCurve.upperCorners,
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,


      navBarStyle:
      NavBarStyle.style9, // Choose the nav bar style with this property
      onItemSelected: (index) {
        print(index);
      },
    );
  }
  }


List<Widget> _buildScreens() {
  return [
    HomeScreen(),
    AllCategories(),
    SearchScreen(),
    ProfileScreen()
  ];
}
List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: ("Home"),
      activeColor: Colors.black.withOpacity(0.8),
      inactiveColor: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.category),
      title: ("Categories"),
      activeColor: Colors.black.withOpacity(0.8),
      inactiveColor: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.search),
      title: ("Search"),
      activeColor: Colors.black.withOpacity(0.8),
      inactiveColor: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.person),
      title: ("Profile"),
      activeColor: Colors.black.withOpacity(0.8),
      inactiveColor: Colors.white,
    ),
  ];
}