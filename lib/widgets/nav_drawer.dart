import 'package:flutter/material.dart';
import 'package:getflutter/components/drawer/gf_drawer.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/allcategories.dart';
import 'package:hamro_gadgets/wishlist.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return GFDrawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SafeArea(
              child: InkWell(
                onTap: () {
    },
                child: Container(
                  color: primarycolor,
                  height: 80,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 18,
                        ),
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Sign In/Sign Up',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          ListTile(
            title: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'Home',
                style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 0.5,
            color: Colors.black26,
          ),
          ListTile(
            title: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'Shop by Category',
                style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {
Navigator.push(context,MaterialPageRoute(builder:(context)=>AllCategories()),);
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 0.5,
            color: Colors.black26,
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 0.5,
            color: Colors.black26,
          ),
          ListTile(
            title: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'My Wishlist',
                style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {
          Navigator.push(context,MaterialPageRoute(builder:(context)=>WishlistScreen()));
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 0.5,
            color: Colors.black26,
          ),
          ListTile(
            title: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'My Orders',
                style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {

            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 0.5,
            color: Colors.black26,
          ),
          ListTile(
            title: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'My Account',
                style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {

            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 0.5,
            color: Colors.black26,
          ),
          ListTile(
            title: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'App Settings',
                style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {

            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 0.5,
            color: Colors.black26,
          ),
          ListTile(
            title: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'Log Out',
                style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {

            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 0.5,
            color: Colors.black26,
          ),

        ],
      ),
    );
  }
}
