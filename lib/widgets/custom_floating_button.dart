import 'package:flutter/material.dart';
import 'package:hamro_gadgets/Bookmarks.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/screens.dart';
import 'package:hamro_gadgets/home_screen.dart';
import 'package:hamro_gadgets/services/database_helper.dart';

class CustomFloatingButton extends StatefulWidget {
  final CurrentScreen currentScreen;
  CustomFloatingButton(this.currentScreen);
  @override
  _CustomFloatingButtonState createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton> with SingleTickerProviderStateMixin{
  List<Cart> cartItems = [];
  int total;
  final dbHelper = DatabaseHelper.instance;
//  final dbRef = FirebaseDatabase.instance.reference();
//  FirebaseAuth mAuth = FirebaseAuth.instance;
  int newQty;
  void getAllItems() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    setState(() {
      total = cartItems.length;
    });
  }
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen;
  int currentTab;
  AnimationController _controller;

//  final double pi = math.pi;
  final double tilt90Degrees = 360;
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

  @override
  Widget build(BuildContext context) {
      getAllItems();
    return FloatingActionButton(
      heroTag: null,
      child: AnimatedBuilder(
        animation: _controller,
        child: angle == 0
            ? Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(
              Icons.shopping_cart_outlined,
              size: 36,
              color: Color(0xFF6b3600),
            ),
            total != null
                ? total > 0
                ? Positioned(
              bottom:
              MediaQuery.of(context).size.height * 0.0265,
              left: MediaQuery.of(context).size.height * 0.023,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: Text(
                    total.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            )
                : Container()
                : Container(),
          ],
        )
            : Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(
              Icons.shopping_cart_outlined,
              size: 36,
              color: Color(0xFF6b3600),
            ),
            total != null
                ? total > 0
                ? Positioned(
              bottom:
              MediaQuery.of(context).size.height * 0.0265,
              left: MediaQuery.of(context).size.height * 0.023,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: Text(
                    total.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            )
                : Container()
                : Container(),
          ],
        ),
        builder: (context, child) => Transform.rotate(
          angle: angle,
          child: child,
        ),
      ),
      backgroundColor: primarycolor,
      elevation: 8.0,
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return BookmarksScreen();
            }));
      },
    );
  }
}


