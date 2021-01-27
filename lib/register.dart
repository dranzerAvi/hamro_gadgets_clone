import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/login_screen.dart';
import 'package:hamro_gadgets/otpscreen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String phnno;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  void check( String phnNo) async{
    await FirebaseFirestore.instance.collection('Users').get().then((value) {
      for(int i=0;i<value.docs.length;i++){
        print(value.docs[i]['phoneNumber']);
        if(phnNo==value.docs[i]['phoneNumber']){
          Fluttertoast.showToast(
              msg: 'You are already registered', gravity: ToastGravity.BOTTOM);

        }
        else{
         verify(phnno);
        }
      }
    });

  }
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(_verificationId, phnno,'register')));
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Stack(
          children: [
            Positioned(
                top:height*0.08,
                right:width*0.30,
                left:width*0.30,
                child:Image.asset('assets/images/hamrologo.jpeg',)

            ),
//              Padding(
//                padding: const EdgeInsets.all(100.0),
//                child: Image.asset('assets/images/hamrologo.jpeg'),
//              ),
            // Padding(
            //   padding: const EdgeInsets.all(100.0),
            //   child: Text('Login',
            //       style: TextStyle(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //           fontSize: height * 0.04)),
            // ),
            Positioned(
                bottom:0.0,
                child:Diagonal(position:DiagonalPosition.TOP_RIGHT,clipHeight: height*0.2,child:Container(height:height*0.6,width:width,color:primarycolor),)

            ),
            Positioned(
              child: Center(
                child: Container(
                  height: height * 0.5,
                  width: width * 0.8,
                  child: Card(

                      elevation: 4.0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Text('REGISTER',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.03)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:8.0,right:12.0,left:20.0),
                              child: Row(
                                children: [
                                  Text('Enter your Phone Number',style:GoogleFonts.poppins(color:Colors.black,fontSize:height*0.02,fontWeight:FontWeight.bold)),
                                  Text('*',style:TextStyle(color:Colors.red))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:20.0,left:20,top:8.0),
                              child: Container(
                                decoration:BoxDecoration(border:Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(right:8.0,left:8.0),
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:'Your number'
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        phnno = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: InkWell(
                                onTap:(){
                                  setState(() {
                                    phnno = _phoneNumberController.text;
                                  });
                                 check('+91${phnno}');
                                },
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.4,
                                  decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child:
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('Submit',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:20.0,top:8.0),
                              child: Row(
                                children: [
                                  Text('Already have an account?',style:GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.w600,fontSize:height*0.02)),
                                  InkWell(onTap:(){
                                    Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>LoginScreen()));
                                  },child: Text(' Login',style:GoogleFonts.poppins(decoration:TextDecoration.underline,color:primarycolor,fontWeight: FontWeight.w600,fontSize:height*0.02))),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),

            ),


          ],
        )

    );
  }
}
