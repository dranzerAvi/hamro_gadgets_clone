import 'dart:io';

import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path/path.dart' as p;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _name=TextEditingController();
  TextEditingController _email=TextEditingController();

  TextEditingController _state=TextEditingController();
  TextEditingController _address=TextEditingController();
  String name,email,url,state,street;
  void getdetails()async{
    User user= await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('Users').where('userId',isEqualTo: user.uid).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
         name=element['name'];
         email=element['email'];
         url=element['ImageURL'];
         state=element['state'];
         street=element['street'];
         _name.text=name;
         _email.text=email;
         _state.text=state;
         _address.text=street;
        });
      });
    });

  }
  @override
  void initState() {
    getdetails();
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  File file;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  String fileName = '';
  bool _isLoading = false;

  double _progress = 0;


  Future filePicker(BuildContext context, state, key) async {
    try {
      print(1);
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
      print(1);
      state.setState(() {
        fileName = p.basename(file.path);
      });
      print(fileName);
      Fluttertoast.showToast(msg: 'Uploading...', gravity: ToastGravity.BOTTOM);
      state.setState(() {});
      _uploadFile(file, fileName, context, state, key);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
  void _uploadFile(File file, String filename, context, state, key) async {
    final FirebaseStorage _storage =
    FirebaseStorage(storageBucket: 'gs://hamrogadgets-941ea.appspot.com/');
    User user =  FirebaseAuth.instance.currentUser;

    StorageReference storageReference;
    storageReference = _storage
        .ref()
        .child("Users/${DateTime.now().millisecondsSinceEpoch}/profileImage");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Download,
      textDirection: TextDirection.ltr,
      isDismissible: false,
    );
    pr.style(
      progressWidget: CircularProgressIndicator(),
      message: 'Uploading photo...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    await pr.show();
    uploadTask.events.listen((event) {
      state.setState(() {
        _isLoading = true;
        _progress = (event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble()) *
            100;
        print('${_progress.toStringAsFixed(2)}%');
        pr.update(
          progress: double.parse(_progress.toStringAsFixed(2)),
          maxProgress: 100.0,
        );
      });
    }).onError((error) {
      key.currentState.showSnackBar(new SnackBar(
        content: new Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    });

    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    url = (await downloadUrl.ref.getDownloadURL());

    Fluttertoast.showToast(
        msg: 'Upload Complete', gravity: ToastGravity.BOTTOM);
    state.setState(() async {
      print("URL is $url");
      await pr.hide();
    });
  }
  void createUser(String name,String email,String state,String address,String url)async{
    await FirebaseFirestore.instance.collection('Users').doc(firebaseAuth.currentUser.uid).update({
      'userId':firebaseAuth.currentUser.uid,

      'ImageURL':url,
      'name':name,
      'email':email,
      'role':'Hamroxxxx',
      'state':state,
      'street':address

    });
Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ProfileScreen()));
  }
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:Colors.white,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body:Stack(
          children: [
            Positioned(
                top:height*0.08,
                right:width*0.30,
                left:width*0.30,
                child:Image.asset('assets/images/hamrologo.jpeg',)

            ),
            Positioned(
                bottom:0.0,
                child:Diagonal(position:DiagonalPosition.TOP_RIGHT,clipHeight: height*0.2,child:Container(height:height*0.6,width:width,color:primarycolor),)

            ),
            Positioned(
              top:height*0.2,
              left:width*0.1,
              child: Center(
                child: Container(
                  height: height * 0.75,
                  width: width * 0.8,
                  child: Card(

                      elevation: 4.0,
                      child: Form(
                        key:_formkey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Text('MY PROFILE',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: height * 0.03)),
                              ),
                              Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          url == null ? 'https://picsum.photos/200' : url),
                                      minRadius: 70.0,
                                      maxRadius: 70.0,
                                    ),
                                  ),
                                  Positioned(
                                    left: width*0.3,
                                    top: 94,
                                    child: InkWell(
                                      onTap: () {
                                        filePicker(context, this, _scaffoldKey);
                                      },
                                      child: Icon(Icons.add_a_photo)
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0,right:12.0,left:20.0),
                                child: Row(
                                  children: [
                                    Text('Enter your Name',style:GoogleFonts.poppins(color:Colors.black,fontSize:height*0.02,fontWeight:FontWeight.bold)),
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
                                      controller: _name,
                                      validator: (value) {
                                        if (value == null || value == '')
                                          return 'Required field';
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:'Your Name'
                                      ),
                                      onChanged: (value) {
                                        setState(() {

                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0,right:12.0,left:20.0),
                                child: Row(
                                  children: [
                                    Text('Enter your email',style:GoogleFonts.poppins(color:Colors.black,fontSize:height*0.02,fontWeight:FontWeight.bold)),
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
                                      controller: _email,
                                      validator: (value) {
                                        if (value == null || value == '')
                                          return 'Required field';
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:'Your email'
                                      ),
                                      onChanged: (value) {
                                        setState(() {

                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0,right:12.0,left:20.0),
                                child: Row(
                                  children: [
                                    Text('State',style:GoogleFonts.poppins(color:Colors.black,fontSize:height*0.02,fontWeight:FontWeight.bold)),
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
                                      controller: _state,
                                      validator: (value) {
                                        if (value == null || value == '')
                                          return 'Required field';
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:'State'
                                      ),
                                      onChanged: (value) {
                                        setState(() {

                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0,right:12.0,left:20.0),
                                child: Row(
                                  children: [
                                    Text('Address',style:GoogleFonts.poppins(color:Colors.black,fontSize:height*0.02,fontWeight:FontWeight.bold)),
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
                                      controller: _address,
                                      validator: (value) {
                                        if (value == null || value == '')
                                          return 'Required field';
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:'Address'
                                      ),
                                      onChanged: (value) {
                                        setState(() {

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
                                      if(_formkey.currentState.validate()&&url!=null||url!=''){
                                        setState(() {
                                          name=_name.text;
                                          email=_email.text;
                                          state=_state.text;
                                          street=_address.text;
                                          createUser(name, email, state, street, url);

                                        });
                                      }
                                      else{
                                        if(url==null||url==''){
                                          Fluttertoast.showToast(
                                              msg: 'Please upload profile image', toastLength: Toast.LENGTH_SHORT);
                                        }
                                        Fluttertoast.showToast(
                                            msg: 'Please fill correctly', toastLength: Toast.LENGTH_SHORT);
                                      }

                                    });

                                  },
                                  child: Container(
                                    height: height * 0.05,
                                    width: width * 0.4,
                                    decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.all(Radius.circular(20))),
                                    child:
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text('Update',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ),

                                  ),
                                ),
                              ),
//                            Padding(
//                              padding: const EdgeInsets.only(left:20.0,top:8.0),
//                              child: Row(
//                                children: [
//                                  Text('Already have an account?',style:GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.w600,fontSize:height*0.02)),
//                                  InkWell(onTap:(){Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>LoginScreen()));},child: Text(' Login',style:GoogleFonts.poppins(decoration:TextDecoration.underline,color:primarycolor,fontWeight: FontWeight.w600,fontSize:height*0.02))),
//                                ],
//                              ),
//                            ),
                              SizedBox(height:20)
                            ],
                          ),
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
