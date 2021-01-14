import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/otpscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phnno;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  void verify(number) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${number}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('=====================');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        _verificationId = verificationId;
        print(_verificationId);
        if (_verificationId != null) {
          Fluttertoast.showToast(
              msg: 'Code sent', toastLength: Toast.LENGTH_SHORT);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(_verificationId, phnno)));
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        // backgroundColor: primarycolor,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: Image.asset('assets/images/hamrologo.jpeg'),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(100.0),
              //   child: Text('Login',
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: height * 0.04)),
              // ),
              Center(
                child: Container(
                  height: height * 0.4,
                  width: width * 0.8,
                  child: Card(
                      color: secondarycolor,
                      elevation: 4.0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('Welcome to Hamro Gadgets',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.025)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                hintText: 'Please enter your phone number',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  phnno = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: height * 0.05,
                              width: width * 0.4,
                              child: RaisedButton(
                                color: primarycolor,
                                onPressed: () {
                                  setState(() {
                                    phnno = _phoneNumberController.text;
                                  });
                                  verify(phnno);
                                },
                                child: Text('Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
