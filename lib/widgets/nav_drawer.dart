import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/components/drawer/gf_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/sorting_details.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User user;

  String name = 'Test User',
      email = 'test@gmail.com ',
      url = 'https://picsum.photos/200/300';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GFDrawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SafeArea(
              child: InkWell(
                  onTap: () {},
                  child: Container(
                    color: primarycolor,
                    height: 80,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(url),
                              radius: 30,
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              name,
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                            ),
                            Text(
                              email,
                              style: GoogleFonts.poppins(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.016,
                                  color: Colors.black),
                            )
                          ],
                        )
                      ],
                    ),
                  ))),
          ListTile(
            title: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'Home',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                'View Sorting Algorithms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SortDetailsScreen()),
              );
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
