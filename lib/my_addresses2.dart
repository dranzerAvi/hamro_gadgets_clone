import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hamro_gadgets/Constants/address.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/checkout.dart';
import 'package:hamro_gadgets/confirm_address.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAddresses2 extends StatefulWidget {
  String id;
  MyAddresses2(this.id);
  @override
  _MyAddresses2State createState() => _MyAddresses2State();
}

class _MyAddresses2State extends State<MyAddresses2> {
  LocationResult location;

  LocationResult result;
  var id;
  // void showPlacePicker() async {
  //   print('called');
  //   result = await Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) =>
  //           PlacePicker("AIzaSyAXFXYI7PBgP9KRqFHp19_eSg-vVQU-CRw")));
  //   setState(() {
  //     location = result.formattedAddress;
  //   });
  //   // Handle the result in your way
  //   print(location);
  //   if (location != null) {
  //     Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => ConfirmAddress(location)));
  //   }
  // }

  List<Address> alladresses = [];
  List<Widget> addressCards = [];
  void alladdresses() async {
    setState(() {
      alladresses.clear();
      print(alladresses.length);
    });

    print('--------------');
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.id)
        .collection('Address')
        .snapshots()
        .forEach((element) {
      element.docs.forEach((element) {
        setState(() {
          Address add = Address(element['address'], element['city'],
              element['state'], element['zip']);
          alladresses.add(add);
        });
        print(id);
        print(alladresses.length);
      });
    });
  }

  @override
  void initState() {
    print(widget.id);
//    setState(() {
//      alladresses.clear();
//      print(alladresses.length);
//    });
//
//    alladdresses();
    super.initState();
  }

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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: primarycolor,
//        actions: [
//          InkWell(
//              onTap: () {
//                launch('tel:+919027553376');
//              },
//              child: Icon(Icons.phone, color: Color(0xFF6b3600))),
//          SizedBox(
//            width: 8,
//          ),
//          InkWell(
//              onTap: () {
//                launchWhatsApp(
//                    phone: '7060222315', message: 'Check out this awesome app');
//              },
//              child: Container(
//                  alignment: Alignment.center,
//                  child: FaIcon(FontAwesomeIcons.whatsapp,
//                      color: Color(0xFF6b3600)))),
//          SizedBox(width: 8),
//          InkWell(
//              onTap: () {
////                print(1);
//                launch(
//                    'mailto:work.axactstudios@gmail.com?subject=Complaint/Feedback&body=Type your views here.');
//              },
//              child: Icon(Icons.mail, color: Color(0xFF6b3600))),
//          SizedBox(
//            width: 10,
//          )
//        ],
        elevation: 0.0,
        centerTitle: true,
        title: Text(
            'HamroGadgets',
            style:GoogleFonts.poppins()
        ),
      ),
      body: Container(
          child: SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.id)
                              .collection('Address')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snap) {
                            if (snap.hasData &&
                                !snap.hasError &&
                                snap.data != null) {
                              alladresses.clear();
                              for (int i = 0; i < snap.data.docs.length; i++) {
                                print(snap.data.docs.length);
                                Address add = Address(
                                  snap.data.docs[i]['address'],
                                  snap.data.docs[i]['city'],
                                  snap.data.docs[i]['state'],
                                  snap.data.docs[i]['zip'],
                                );
                                alladresses.add(add);
                                print(alladresses.length);
                              }
                              return alladresses.length != 0
                                  ? Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: Align(
                                      alignment:Alignment.topLeft,
                                      child: Text('Saved Addresses',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: height * 0.025,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: alladresses.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var item = alladresses[index];
                                      return InkWell(
                                        onTap:()async{
                                          SharedPreferences prefs= await SharedPreferences.getInstance();
                                          var orderid =prefs.getString('Orderid');
                                          Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Checkout(item.address,item.city,item.state,item.zip,orderid)));
                                        },
                                        child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                    Alignment.bottomLeft,
                                                    child: Text(
                                                        'Address :  ${item.address}'),
                                                  ),
                                                  (item.city != null &&
                                                      item.city != '')
                                                      ? Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                          'City : ${item.city}'))
                                                      : Text(''),
                                                  item.state != null
                                                      ? Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                          'State : ${item.state}'))
                                                      : Container(),
                                                  item.zip != null
                                                      ? Align(
                                                      alignment:
                                                      Alignment.bottomLeft,
                                                      child: Text(
                                                          'Zip Code : ${item.zip}'))
                                                      : Container()
                                                ],
                                              ),
                                            )),
                                      );
                                    },
                                  )
                                ],
                              )
                                  : Container();
                            } else {
                              return Container();
                            }
                          })),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                        onTap: () async {
                          LocationResult result = await showLocationPicker(
                            context,
                            'AIzaSyAXFXYI7PBgP9KRqFHp19_eSg-vVQU-CRw',
                            initialCenter: LatLng(31.1975844, 29.9598339),
                            automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                            myLocationButtonEnabled: true,
                            // requiredGPS: true,
                            layersButtonEnabled: true,
                            countries: ['AE'],

//                      resultCardAlignment: Alignment.bottomCenter,
//                       desiredAccuracy: LocationAccuracy.best,
                          );
                          print("result = $result");
                          setState(() {
                            location = result;
                            if (location != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ConfirmAddress(location.address)));
                            }
                          });
//                                  _locationDialog(context);
//                                   showPlacePicker();
//                                   Navigator.push(context, MaterialPageRoute(
//                                       builder: (BuildContext context) {
//                                     return LocationScreen();
//                                   }));
//
                        },
                        child: Container(
                            height: height * 0.08,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                                color: primarycolor,
                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: Center(
                                child: Text('+ Add new address',
                                    style: TextStyle(
                                        fontSize: height * 0.025,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))))),



                  ),
                ] ),
          )
      ) ,
    );

  }
}

