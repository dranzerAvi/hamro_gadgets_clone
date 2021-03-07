import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/area.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/home_screen.dart';
import 'package:hamro_gadgets/my_addresses2.dart';
import 'package:hamro_gadgets/my_addresses3.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout2 extends StatefulWidget {
  String address,city,state,zip,orderid;bool store;List<String>newitems=[];int rewardpoints;String imageurl;
  Checkout2(this.address,this.city,this.state,this.zip,this.orderid,this.store,this.newitems,this.rewardpoints,this.imageurl);
  @override
  _Checkout2State createState() => _Checkout2State();
}

class _Checkout2State extends State<Checkout2> {
  TextEditingController _email = TextEditingController();
  TextEditingController _first = TextEditingController();
  TextEditingController _last = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _zip = TextEditingController();
  TextEditingController _phnNo = TextEditingController();
  TextEditingController _address2 = TextEditingController();
  String state = '';
  final scaffoldState = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  GlobalKey key = new GlobalKey();
  List<Cart> cartItems = [];
  final addressController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
//  final dbRef = FirebaseDatabase.instance.reference();
  FirebaseAuth mAuth = FirebaseAuth.instance;
  int newQty;int count=0;
  User user;
var secid;
  getUserDetails() async {
    user = FirebaseAuth.instance.currentUser;
  }
  void points(){
    print(user.uid);
    FirebaseFirestore.instance.collection('Users').where('userId',isEqualTo: user.uid.trim()).get().then((value) {
      for(int i=0;i<value.docs.length;i++){
        setState(() {
          count=value.docs[i]['count'];
        });

        print('=========${count.toString()}');
      }
    } );
  }
  void up(){
    if(ShippingCharge!=''){
      FirebaseFirestore.instance.collection('Users').doc(user.uid.trim()).update({
        'count':count-(widget.rewardpoints + int.parse(ShippingCharge)),
      });
    }
   else{
      FirebaseFirestore.instance.collection('Users').doc(user.uid.trim()).update({
        'count': count - (widget.rewardpoints)
      });
    }
  }
  List<String>productsid=[];
  void proid(List<String>newitems)async{

    productsid.clear();

    await FirebaseFirestore.instance.collection('RewardProducts').snapshots().forEach((
        element) {
      for (int i = 0; i < element.docs.length; i++) {
        for (int j = 0; j < newitems.length; j++) {
          if (newitems[j] == element.docs[i]['name']) {
            setState(() {
              productsid.add(element.docs[i]['productId'].toString());
              print(element.docs[i]['productId']);
            });

          }
        }
      }
      print('Products id11:${productsid.length}');

    });
    print('Products id12:${productsid.length}');
//    if(await productsid.length>0){
//      placeOrder(type,productsid);
//    }


  }
  @override
  void initState() {
    getUserDetails();
    proid(widget.newitems);
    points();
    area();
    secid=widget.orderid;
    print('heya${secid}');
    super.initState();
  }

  String orderid;int no=0;int quantity=0;String docID;String type = 'Delivery';
  void updatepro(List<dynamic> allnames,List<int>quantities){
    FirebaseFirestore.instance.collection('RewardProducts').get().then((value) {
      for(int i =0;i<value.docs.length;i++){
        print(value.docs[i]['name']);
        for(int j=0;j<allnames.length;j++){
          if(allnames[j]==value.docs[i]['name']){
            print('---------------------------${allnames[j]}');
            print('---------------------------${value.docs[i]['docID']}');
            docID=value.docs[i]['docID'];
            no=value.docs[i]['noOfPurchases']+1;
            print(no);
            quantity=value.docs[i]['quantity']-1;
            print(quantity);
            pro2(docID, quantity, no);
          }
        }
      }
    });
  }
  void pro2(String docId,int quantity,int no){
    print('--------------------------------${docId.trim()}');
    FirebaseFirestore.instance.collection('RewardProducts').doc(docId.trim()).update({
      'noOfPurchases':no,
      'quantity':quantity
    });

  }
  List<Area>allareas=[];
  List<Area>savedAreas=[];
  List<String>areanames=[];
  List<String>savedareanames=[];
  String ShippingCharge='';
  void area(){
    FirebaseFirestore.instance.collection('Area').snapshots().forEach((element) {
      for(int i =0;i<element.docs.length;i++){
        Area ar=Area(element.docs[i]['Price'],element.docs[i]['name']);
        savedAreas.add(ar);
        savedareanames.add(element.docs[i]['name']);
      }
      print(allareas.length);
    });
  }
  void shipping(){
    if(widget.address!=''){
      for(int i=0;i<savedAreas.length;i++){
        if(widget.state==savedAreas[i].name){
          setState(() {
            ShippingCharge=savedAreas[i].price;
          });
        }
      }
    }
  }
  void placeOrder(String type) async{
    print('hiiiiiiiiiiiiiiiiiiiiiiiiiiii');
    List<int> prices = [];
    List<int>quantities = [];
    List<String>image = [];
    quantities.add(1);
    print('Orderid:${widget.orderid}');
    print(secid);
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var iddd=prefs.getString('orderid');
    print('Sharedid:${iddd}');
    image.add(widget.imageurl);
//    print(int.parse(ShippingCharge));
    if (ShippingCharge!=  '') {
      prices.add((widget.rewardpoints ));
    }
    else {
      prices.add(widget.rewardpoints);
    }


    if (widget.address == '' && widget.address == null) {
      if (type == 'Point Mode') {
        Map<String, dynamic> address1 = {
          'city': _city.text,
          'fulladdress': '${addressController.text},${_address2.text}',
          'phonenumber': '+91${_phnNo.text}',
          'postalcode': _zip.text,
          'state': state
        };
        final databaseReference = FirebaseFirestore.instance;
        databaseReference.collection('Orders').doc(widget.orderid).set({
          'Address': address1,
          'GrandTotal': widget.rewardpoints + int.parse(ShippingCharge),
          'Items': widget.newitems,
          'Price': prices,
          'Qty': quantities,
          'productId': productsid,
          'Status': 'Order Placed',
          'TimeStamp': Timestamp.now(),
          'UserID': user.uid,
          'imgUrl': image,
          'orderid': widget.orderid,
          'orderType': type
        });
        updatepro(widget.newitems,quantities);
        up();
        Fluttertoast.showToast(
            msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(0)));

      }
      if(type=='Point Mode Instore'){
        final databaseReference = FirebaseFirestore.instance;
        databaseReference.collection('Orders').doc(secid).set({

          'GrandTotal': widget.rewardpoints ,
          'Items': widget.newitems,
          'Price': prices,
          'Qty': quantities,
          'productId': productsid,
          'Status': 'Order Placed',
          'TimeStamp': Timestamp.now(),
          'UserID': user.uid,
          'imgUrl': image,
          'orderid': secid,
          'orderType': type
        });
        updatepro(widget.newitems,quantities);
up();
        Fluttertoast.showToast(
            msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(0)));

      }
    }
    else {
      if (type == 'Point Mode') {
        Map<String, dynamic> address2 = {
          'city': widget.city,
          'fulladdress': widget.address,
          'phonenumber': user.phoneNumber,
          'postalcode': widget.zip,
          'state': widget.state
        };
        final databaseReference = FirebaseFirestore.instance;
        databaseReference.collection('Orders').doc(widget.orderid).set({
          'Address': address2,
          'GrandTotal': widget.rewardpoints + int.parse(ShippingCharge),
          'Items': widget.newitems,
          'Price': prices,
          'Qty': quantities,
          'productId': productsid,
          'Status': 'Order Placed',
          'TimeStamp': Timestamp.now(),
          'UserID': user.uid,
          'imgUrl': image,
          'orderid': widget.orderid,
          'orderType': type
        });
        updatepro(widget.newitems,quantities);
           up();
        Fluttertoast.showToast(
            msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(0)));

      }
      if(type=='Point Mode Instore'){
        final databaseReference = FirebaseFirestore.instance;
        databaseReference.collection('Orders').doc(secid).set({

          'GrandTotal': widget.rewardpoints ,
          'Items': widget.newitems,
          'Price': prices,
          'Qty': quantities,
          'productId': productsid,
          'Status': 'Order Placed',
          'TimeStamp': Timestamp.now(),
          'UserID': user.uid,
          'imgUrl': image,
          'orderid': secid,
          'orderType': type
        });
        updatepro(widget.newitems,quantities);
up();
        Fluttertoast.showToast(
            msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(0)));
      }
    }
  }
  Widget Bill() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color:secondarycolor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sub Total-',style:GoogleFonts.poppins()),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.187,
//                  ),
//                  Text(':'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
                  Text(' ${widget.rewardpoints.toString()} coins',style:GoogleFonts.poppins())
                ],
              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                  Text('Discount-'),
////                  SizedBox(
////                    width: MediaQuery.of(context).size.width * 0.2,
////                  ),
////                  Text(':'),
////                  SizedBox(
////                    width: MediaQuery.of(context).size.width * 0.03,
////                  ),
//                  Text(discount != null
//                      ? 'Rs. ${(totalAmount() * (double.parse(discount.discount) / 100)).toStringAsFixed(2)}'
//                      : 'Rs. 0'),
//                ],
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                  Text('Taxes and Charges-',style:GoogleFonts.poppins()),
////                  SizedBox(
////                    width: MediaQuery.of(context).size.width * 0.03,
////                  ),
////                  Text(':'),
////                  SizedBox(
////                    width: MediaQuery.of(context).size.width * 0.03,
////                  ),
//                  Text('Rs. ${(totalAmount() * 0.10).toStringAsFixed(2)}',style:GoogleFonts.poppins()),
//                ],
//              ),
              SizedBox(
                height: 20,
              ),
              (ShippingCharge!='')?Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text('Shipping Charge-',style:GoogleFonts.poppins()),
                    Text(' ${ShippingCharge} coins',style:GoogleFonts.poppins())
                  ]
              ):Container(),
              Container(
                height: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Grand Total-',style:GoogleFonts.poppins()),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.147,
//                  ),
//                  Text(':'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
                  (ShippingCharge!='')?Text(' ${((widget.rewardpoints)+double.parse(ShippingCharge)).toString()} coins',style:GoogleFonts.poppins()):Text('${((widget.rewardpoints)).toString()} coins',style:GoogleFonts.poppins()),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    shipping();
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          backgroundColor: primarycolor,
          title: Text('Hamro Gadgets'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              (widget.store)? Row(

                children: [
                  Container(
                    child: Radio(
                        activeColor: primarycolor,
                        value: 'Delivery',
                        groupValue: type,
                        onChanged: (value) {
                          setState(() {
                            type = value;
                          });
                        }),
                  ),
                  Text(
                    'Delivery',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  SizedBox(
                      width:width*0.25
                  ),
                  Container(
                    height: 6,
                    child: Radio(
                        activeColor: primarycolor,
                        value: 'Pay at store',
                        groupValue: type,
                        onChanged: (value) {
                          setState(() {
                            type = value;
                          });
                        }),
                  ),


                  Text(
                    'Pay at store',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                ],
              ):Container(),
              (type!='Pay at store')? (widget.address=='')?Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Shipping Address',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.03))),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: Row(children: [
                    Text('Email Address',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Your email'),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12),
                  child: Divider(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: Row(children: [
                    Text('First Name',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _first,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'First Name'),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: Row(children: [
                    Text('Last Name',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _last,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Last Name'),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: Row(children: [
                    Text('Full Address',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0, left: 8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _address2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: Row(children: [
                    Text('City',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _city,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: Row(children: [
                    Text('State/Province',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Area')

                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snap) {
                      if (snap.hasData && !snap.hasError && snap.data != null) {
                        allareas.clear();
                        areanames.clear();
                        for (int i = 0; i < snap.data.docs.length; i++) {
                          print(snap.data.docs.length);

                          areanames.add(snap.data.docs[i]['name']);

                          Area ar = Area(
                            snap.data.docs[i]['Price'],
                            snap.data.docs[i]['name'],
                          );
                          allareas.add(ar);
                        }

                        if (area == null) {
                          state = allareas[0].name;
                        }
                        return areanames.length != 0
                            ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                              child: Container(

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      border: Border.all(color: Colors.grey, width: 1)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: DropdownButtonHideUnderline(
                                        child: new DropdownButtonFormField<
                                            String>(
                                            validator: (value) =>
                                            value == null
                                                ? 'field required'
                                                : null,
                                            hint: Text('State'),
                                            value: areanames[0],
                                            items:
                                            areanames.map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                state = newValue;

                                                for(int i =0;i<allareas.length;i++) {
                                                  if (state == allareas[i].name) {
                                                    setState(() {
                                                      ShippingCharge=allareas[i].price;
                                                    });
                                                  }
                                                }
                                              });
                                            })),
                                  )),
                            )
                          ],
                        )
                            : Container();
                      } else {
                        return Container();
                      }
                    }),
//                Padding(
//                  padding: const EdgeInsets.only(
//                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
//                  child: Container(
//                      width: height * 0.8,
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(4)),
//                          border: Border.all(color: Colors.grey, width: 1)),
//                      child: Padding(
//                          padding: const EdgeInsets.only(left: 8.0),
//                          child: DropdownButtonHideUnderline(
//                            child: new DropdownButton<String>(
//                              value: areanames[0],
//                              hint: Text('Choose State'),
//
//                              items:
//                              areanames.map(( String value) {
//                                return new DropdownMenuItem<String>(
//                                  value: value,
//                                  child: new Text(value),
//                                );
//                              }).toList(),
//                              onChanged: (val) {
//                                setState(() {
//                                  state = val;
//                                });
//                              },
//                            ),
//                          ))),
//                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: Row(children: [
                    Text('Zip/Postal Code',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _zip,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
//                Padding(
//                  padding: const EdgeInsets.only(
//                    top: 8.0,
//                    left: 8.0,
//                  ),
//                  child: Row(children: [
//                    Text('Country',
//                        style: GoogleFonts.poppins(
//                            color: Colors.black,
//                            fontSize: height * 0.02,
//                            fontWeight: FontWeight.bold)),
//                    Text('*', style: TextStyle(color: Colors.red)),
//                  ]),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(
//                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
//                  child: Container(
//                      width: height * 0.8,
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(4)),
//                          border: Border.all(color: Colors.grey, width: 1)),
//                      child: Padding(
//                          padding: const EdgeInsets.only(left: 8.0),
//                          child: DropdownButtonHideUnderline(
//                            child: new DropdownButton<String>(
//                              value: country,
//                              items: <String>[
//                                'India',
//                                'United States',
//                                'United Kingdom',
//                                'Thailand'
//                              ].map((String value) {
//                                return new DropdownMenuItem<String>(
//                                  value: value,
//                                  child: new Text(value),
//                                );
//                              }).toList(),
//                              onChanged: (val) {
//                                setState(() {
//                                  country = val;
//                                });
//                              },
//                            ),
//                          ))),
//                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                  ),
                  child: Row(children: [
                    Text('Phone Number',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _phnNo,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      )),
                ),
              ]):Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Shipping Address',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.03))),
                  ),
                  Card(
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
                                  'Address :  ${widget.address}'),
                            ),
                            Align(
                                alignment:
                                Alignment.bottomLeft,
                                child: Text(
                                    'City : ${widget.city}')),

                            Align(
                                alignment:
                                Alignment.bottomLeft,
                                child: Text(
                                    'State : ${widget.state}')),

                            Align(
                                alignment:
                                Alignment.bottomLeft,
                                child: Text(
                                    'Zip Code : ${widget.zip}'))

                          ],
                        ),
                      )),
                ],
              ):Container(),
              (type!='Pay at store')?Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyAddresses3(user.uid,widget.store,widget.newitems,widget.rewardpoints,widget.imageurl)));
                    },
                    child: Container(
                        height: height * 0.06,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                            color: primarycolor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text('Saved Addresses',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: height * 0.022)),
                        ))),
              ):Container(),
//            Align(
//              alignment: Alignment.topLeft,
//              child: Padding(
//                padding:EdgeInsets.only(top:height*0.015,left:width*0.07),
//                child: Text('Items',textAlign:TextAlign.left,style:TextStyle(color:Colors.black.withOpacity(0.8),fontSize: height*0.025,fontWeight: FontWeight.w500)),
//              ),
//            ),
              Bill(),
//              InkWell(
//                onTap:(){
//                  alert();
//                },
//                child: Container(
//                    height: height * 0.06,
//                    width: width * 0.8,
//                    decoration: BoxDecoration(
//                        color: primarycolor,
//                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                    child: Center(
//                        child: Text('Redeem reward points',
//                            style: GoogleFonts.poppins(
//                                fontSize: height * 0.025,
//
//                                color: Colors.white)))
//                ),
//              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(color: secondarycolor),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Order Summary',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.025))),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Divider(color: Colors.grey),
                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Row(
//                            children: [
//                              Text('${cartItems.length.toString()}',
//                                  style: GoogleFonts.poppins(
//                                      color: primarycolor,
//                                      fontSize: height * 0.017,
//                                      fontWeight: FontWeight.bold)),
//                              (cartItems.length > 1)
//                                  ? Text(' Items in Cart',
//                                  style: GoogleFonts.poppins(
//                                      color: Colors.grey,
//                                      fontSize: height * 0.017,
//                                      fontWeight: FontWeight.w500))
//                                  : Text(' Item in Cart',
//                                  style: GoogleFonts.poppins(
//                                      color: Colors.grey,
//                                      fontSize: height * 0.017,
//                                      fontWeight: FontWeight.w500))
//                            ],
//                          ),
//                        ),
                        Container(
                          height: height * 0.29,
                          width: width * 0.9,
                          child: ListView.builder(
                              itemCount: widget.newitems.length,
                              itemBuilder: (BuildContext ctxt, int i) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: FancyShimmerImage(
                                          imageUrl: widget.imageurl,
                                          shimmerDuration: Duration(seconds: 2),
                                        ),
                                        height: 80,
                                        width: 80,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Container(
                                        height: 80,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.6,
                                              child: Text(
                                                widget.newitems[0],
                                                style: TextStyle(fontSize: 15),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width:width*0.9-120,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Qty: ${1}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Price:  ${widget.rewardpoints.toString()} coins',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      Image.asset('assets/images/coins.png',height:height*0.025,)
                                                    ],
                                                  ),
                                                  Spacer()
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),

//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: TextFormField( decoration: InputDecoration(
//                  border: OutlineInputBorder(
//                      borderRadius:
//                      BorderRadius.circular(2),
//                      borderSide:
//                      BorderSide(color: Colors.grey)),
//                  enabledBorder: OutlineInputBorder(
//                      borderRadius:
//                      BorderRadius.circular(2),
//                      borderSide:
//                      BorderSide(color: Colors.grey)),
//                  focusedBorder: OutlineInputBorder(
//                      borderRadius:
//                      BorderRadius.circular(2),
//                      borderSide: BorderSide(
//                          color: primarycolor)),
//                  hintText: 'Your address'),
//                maxLines: 4,
//                controller: addressController,),
//            ),

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Choose payment method',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: height * 0.025,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              SizedBox(height: height * 0.02),
              (type!='Pay at store')?InkWell(
                  onTap: () {
                    if(count>=widget.rewardpoints + int.parse(ShippingCharge)){
                      placeOrder('Point Mode');
                    }
                   else{
                      Fluttertoast.showToast(
                          msg: 'Your don\'t have enough coins to place this order', toastLength: Toast.LENGTH_SHORT);
                    }
                  },
                  child: Container(
                      height: height * 0.08,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Center(
                          child: Text('Pay Now',
                              style: TextStyle(
                                  fontSize: height * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))))):InkWell(
                  onTap: () {
                    if(count>=widget.rewardpoints ){
                      placeOrder('Point Mode Instore');
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: 'Your don\'t have enough coins to place this order', toastLength: Toast.LENGTH_SHORT);
                    }

                  },
                  child: Container(
                      height: height * 0.08,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Center(
                          child: Text('Pay at store',
                              style: TextStyle(
                                  fontSize: height * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))))),
              SizedBox(height: height * 0.02),
//              (type!='Pay at store')?InkWell(
//                  onTap: () {
//                    placeOrder('coc');
//                  },
//                  child: Container(
//                      height: height * 0.08,
//                      width: width * 0.9,
//                      decoration: BoxDecoration(
//                          color: primarycolor,
//                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                      child: Center(
//                          child: Text('Card on Delivery',
//                              style: TextStyle(
//                                  fontSize: height * 0.025,
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.white))))):Container(),
//              SizedBox(height: height * 0.02),
//              (type!='Pay at store')? InkWell(
//                  onTap: () {},
//                  child: Container(
//                      height: height * 0.08,
//                      width: width * 0.9,
//                      decoration: BoxDecoration(
//                          color: primarycolor,
//                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                      child: Center(
//                          child: Text('Pay online',
//                              style: TextStyle(
//                                  fontSize: height * 0.025,
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.white))))):Container(),
              SizedBox(height: height * 0.02),
            ],
          ),
        ));
  }
}
