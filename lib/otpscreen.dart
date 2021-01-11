import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/home_screen.dart';
import 'package:hamro_gadgets/login_screen.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  String id;String number;
  OtpScreen(this.id,this.number);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp;
  void verify(){


  }
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primarycolor,
      body:Column(
        children:[
          Padding(
            padding:  EdgeInsets.all(height*0.1),
            child: Text('Hamro Gadgets',style:TextStyle(color:Colors.white,fontWeight:
            FontWeight.bold,fontSize:height*0.04 )),
          ),
          Center(
            child: Container(
              height:height*0.4,
              width:width*0.8,
              child: Card(
                  elevation:4.0,
                  child:Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('Enter OTP',style:TextStyle(color:primarycolor,fontWeight: FontWeight.bold,fontSize: height*0.025)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: OTPTextField(
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldWidth: 30,
                          fieldStyle: FieldStyle.underline,
                          style: TextStyle(
                              fontSize: 17
                          ),
                          onCompleted: (pin) {
                            print("Completed: " + pin);
                            setState(() {
                              otp=pin;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height:height*0.05,
                          width:width*0.4,

                          child: RaisedButton(
                            color: primarycolor,
                            onPressed: ()async{
                              firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(verificationId: widget.id, smsCode: otp)).catchError((e){print('-------');print(e.toString());
//                              if(e.toString()!=null){
//                                Fluttertoast.showToast(
//                                    msg: 'Invalid otp', toastLength: Toast.LENGTH_SHORT);
//                              }

                              });
                                if( await firebaseAuth.currentUser.uid!=null){
                                  await FirebaseFirestore.instance.collection('Users').doc(firebaseAuth.currentUser.uid).set({
                                    'userId':firebaseAuth.currentUser.uid,
                                    'phoneNumber':'+91${widget.number}'

                                  });
                                  Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>HomeScreen()));

                                  SharedPreferences prefs= await SharedPreferences.getInstance();
                                  prefs.setString('isLogged', 'true');


                                }

    },
                            child:Text('Submit',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w500)),

                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),
          )
        ]
      )
    );
  }
}
