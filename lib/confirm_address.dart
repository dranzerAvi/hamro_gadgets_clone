import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';

import 'package:url_launcher/url_launcher.dart';

class ConfirmAddress extends StatefulWidget {
  String location;
  ConfirmAddress(this.location);
  @override
  _ConfirmAddressState createState() => _ConfirmAddressState();
}

class _ConfirmAddressState extends State<ConfirmAddress> {
  final locationselected = TextEditingController();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  GlobalKey key = new GlobalKey();
  String area;
  String emirate2;
  String emirate;
  String state = 'Bagmati';
  List<String> emiratesname = [];
  List<String> areaname = [];
  var id = '';
  var minimumOrderValue = '150';

  void addAddress() async {
    User user =  FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('phoneNumber', isEqualTo: user.phoneNumber)
        .snapshots()
        .listen((event) {
      setState(() {
        id = event.docs[0].id;
      });
      print(event.docs[0].id);
      print(id);
    });
  }

  void setaddress(String id) async {
    (id != null && id != '')
        ? await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .collection('Address')
        .add({
      'address': locationselected.text,
      'city': hnocontroller.text,
      'state':state,
      'zip': localitycontroller.text,

    })
        : print('not');
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    locationselected.text = widget.location;

    addAddress();

    super.initState();
  }

  final hnocontroller = TextEditingController();
  final localitycontroller = TextEditingController();
  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?   phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key:scaffoldState,
        appBar: AppBar(
          backgroundColor: primarycolor,
         centerTitle: true,
         title:Text('HamroGadgets',style:GoogleFonts.poppins())
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key:_formkey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text('Complete your Address',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: height * 0.025,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value == '')
                          return 'Required field';
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide(color: Color(0xFF6b3600))),
                      ),
                      maxLines: 2,
                      controller: locationselected,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value == '')
                          return 'Required field';
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: BorderSide(color: Color(0xFF6b3600))),
                          hintText: 'City'),
                      controller: hnocontroller,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                    child: Container(
                        width: height * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButtonHideUnderline(
                              child: new DropdownButtonFormField<String>(
                                validator: (value) =>
                                value == null
                                    ? 'field required'
                                    : null,
                                value: state,
                                items: <String>[
                                  'Bagmati',
                                  'Lumbini',
                                  'Karnali',
                                  'Sudurpashchim'
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    state = val;
                                  });
                                },
                              ),
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value == '')
                          return 'Required field';
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: BorderSide(color: Color(0xFF6b3600))),
                          hintText: 'Zip/Postal Code'),
                      controller: localitycontroller,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  InkWell(
                      onTap: () async {
                        if(_formkey.currentState.validate()){
                          setaddress(id);
                        }
                       else{
                          Fluttertoast.showToast(
                              msg: 'Address required',
                              toastLength: Toast.LENGTH_SHORT);
                        }
                      },
                   child:Container(
                       height: height * 0.08,
                       width: width * 0.9,
                       decoration: BoxDecoration(
                           color: primarycolor,
                           borderRadius: BorderRadius.all(Radius.circular(5.0))),
                       child: Center(
                           child: Text('Save Address',
                               style: TextStyle(
                                   fontSize: height * 0.025,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white))))


                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
