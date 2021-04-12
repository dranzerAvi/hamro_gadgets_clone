import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/area.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/offer.dart';
import 'package:hamro_gadgets/home_screen.dart';
import 'package:hamro_gadgets/my_addresses2.dart';
import 'package:hamro_gadgets/offers_screen.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  String address,city,state,zip,orderid;bool store;List<String>newitems=[];
  Checkout(this.address,this.city,this.state,this.zip,this.orderid,this.store,this.newitems);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController _email = TextEditingController();
  TextEditingController _first = TextEditingController();
  TextEditingController _last = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _zip = TextEditingController();
  TextEditingController _phnNo = TextEditingController();
  TextEditingController _address2 = TextEditingController();
  String state = '';
  String ShippingCharge='';
  String country = 'India';
  String type = 'Delivery';
//  Offer discount;
  final scaffoldState = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  GlobalKey key = new GlobalKey();
  List<Cart> cartItems = [];
  final addressController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
//  final dbRef = FirebaseDatabase.instance.reference();
  FirebaseAuth mAuth = FirebaseAuth.instance;
  int newQty;
  void getAllItems() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    setState(() {
      allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    });
//  proid();
  }

  double totalAmount() {
    double sum = 0;
    getAllItems();
//    proid();
    for (int i = 0; i < cartItems.length; i++) {
      sum += (double.parse(cartItems[i].price) * cartItems[i].qty);
    }
    return sum;
  }
  User user;

  getUserDetails() async {
    user = FirebaseAuth.instance.currentUser;
  }
  List<Area>allareas=[];
  List<Area>savedAreas=[];
  List<String>areanames=[];
  List<String>savedareanames=[];
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
int counts=0;
void points(){
  print(user.uid);
  FirebaseFirestore.instance.collection('Users').where('userId',isEqualTo: user.uid.trim()).get().then((value) {
    for(int i=0;i<value.docs.length;i++){
      setState(() {
        counts=value.docs[i]['count'];
      });

      print('=========${counts.toString()}');
    }
  } );
}
void up(int count){
  FirebaseFirestore.instance.collection('Users').doc(user.uid.trim()).update({
    'count':count+counts
  });
}
//int discount=0;
void alert(int count2){


//print('hiiiiiiiiii');
//        Dialogs.materialDialog(
//            color: Colors.white,
//            msg: 'Congratulations!, you have won ${count2.toString()} coins  on your order.',
//            title: 'Congratulations',
//            animation: 'assets/cong_example.json',
//            context: context);
////            actions: [
////              IconsButton(
////                onPressed: () {},
////                text: 'Claim',
////                iconData: Icons.done,
////                color: Colors.blue,
////                textStyle: TextStyle(color: Colors.white),
////                iconColor: Colors.white,
////              ),
////            ]);

up(count2);

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
                  Text('Rs. ${totalAmount().toString()}',style:GoogleFonts.poppins())
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount-'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.2,
//                  ),
//                  Text(':'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
                  Text(discount != null
                      ? 'Rs. ${(totalAmount() * (double.parse(discount.discount) / 100)).toStringAsFixed(2)}'
                      : 'Rs. 0'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Taxes and Charges-',style:GoogleFonts.poppins()),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
//                  Text(':'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
                  Text('Rs. ${(totalAmount() * 0.10).toStringAsFixed(2)}',style:GoogleFonts.poppins()),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              (ShippingCharge!='')?Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text('Shipping Charge-',style:GoogleFonts.poppins()),
                  Text('Rs. ${ShippingCharge}',style:GoogleFonts.poppins())
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
                  Text(discount != null
                      ?(ShippingCharge!='')? 'Rs. ${((totalAmount() * 0.10) + totalAmount() - (totalAmount() * (double.parse(discount.discount) / 100)) + double.parse(ShippingCharge)).toStringAsFixed(2)}'
                      : 'Rs. ${((totalAmount() * 0.10) + totalAmount()  - (totalAmount() * (double.parse(discount.discount) / 100))).toStringAsFixed(2)}':'Rs. ${((totalAmount() * 0.10) + totalAmount() ).toStringAsFixed(2)}'),
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
  String orderid;int no=0;int quantity=0;String docID;
  void updatepro(List<dynamic> allnames,List<dynamic>allquantities){
   FirebaseFirestore.instance.collection('Products').get().then((value) {
          for(int i =0;i<value.docs.length;i++){
            print(value.docs[i]['name']);
            for(int j=0;j<allnames.length;j++){
              if(allnames[j]==value.docs[i]['name']){
                print('---------------------------${allnames[j]}');
                print('---------------------------${value.docs[i]['docID']}');
                docID=value.docs[i]['docID'];
                   no=value.docs[i]['noOfPurchases']+allquantities[j];
                   print(no);
                   quantity=value.docs[i]['quantity']-allquantities[j];
                   print(quantity);
               pro2(docID, quantity, no);
              }
            }
          }
   });
  }
  void pro2(String docId,int quantity,int no){
    print('--------------------------------${docId.trim()}');
    FirebaseFirestore.instance.collection('Products').doc(docId.trim()).update({
      'noOfPurchases':no,
      'quantity':quantity
    });

  }
  var coins; List productsid = [];
  void proid(List<String>newitems)async{

    productsid.clear();
    List items = [];
    List prices = [];
    List quantities = [];
    List image = [];

    for (var v in cartItems) {
      print(v.productName);
      items.add(v.productName);
      prices.add(v.price);
      quantities.add(v.qty);
      image.add(v.imgUrl);
    }
   await FirebaseFirestore.instance.collection('Products').snapshots().forEach((
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
  void set(String title) async {
    await getUserDetails();
    // print('title:${title}');
    List titles = [];
//    titles.add(title);
    List check = [];
    await Firestore.instance
        .collection('Users')
        .document(user.uid)
        .get()
        .then((value) {
      Map map = value.data();
      check = map['couponUsed'];
      for (int i = 0; i < check.length; i++) {
        titles.add(check[i]);
      }

      // print('checkkkkkkkkkkkkkkkkkkkk${check.length}');

      titles.add(title);
      // print('========================${titles}');
      Firestore.instance.collection('Users').document(user.uid).update({
        'couponUsed': titles,
      });
    });
  }
  void placeOrder(String type) async {
    var dis;
    var coupon;
    (discount != null) ? coupon = discount.title : coupon = '';
    set(coupon);

//    if(discount.discount==''&&discount.discount==null){
//      dis='0.0';
//    }
//    else{
//      dis=double.parse(discount.discount).toString();
//    }
    discount != null
        ? dis =
    ('${(totalAmount() * (double.parse(discount.discount) / 100)).toStringAsFixed(2)}')
        : dis = ' 0';
    print('productidinplace:${productsid.length}');
    (type != 'payatstore')
        ? coins = 0.1 *
        (totalAmount() + (totalAmount() * 0.1 + double.parse(ShippingCharge)))
        : coins = 0.1 * (totalAmount() + (totalAmount() * 0.1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    orderid = prefs.getString('Orderid');
    await getUserDetails();
    List items = [];
    List prices = [];
    List quantities = [];
    List image = [];

    for (var v in cartItems) {
      print(v.productName);
      items.add(v.productName);
      prices.add(v.price);
      quantities.add(v.qty);
      image.add(v.imgUrl);
    }

    if (widget.address == '' && widget.address == null) {
      if (type == 'cod' || type == 'coc') {
        Map<String, dynamic> address1 = {
          'city': _city.text,
          'fulladdress': '${addressController.text},${_address2.text}',
          'phonenumber': '+91${_phnNo.text}',
          'postalcode': _zip.text,
          'state': state
        };
        final databaseReference = FirebaseFirestore.instance;
        databaseReference.collection('Orders').doc(orderid).set({
          'Address': address1,
          'couponUsed':discount.title,
          'discountPrice':dis,
          'GrandTotal': totalAmount() +
              (totalAmount() * 0.1 + double.parse(ShippingCharge)),
          'Items': items,
          'Price': prices,
          'Qty': quantities,
          'productId': productsid,
          'Status': 'Order Placed',
          'TimeStamp': Timestamp.now(),
          'UserID': user.uid,
          'imgUrl': image,
          'orderid': orderid,
          'orderType': type
        });
        removeAll();
        updatepro(items,quantities);
        callapi(orderid);
        alert(coins.toInt());
        Fluttertoast.showToast(
            msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(coins.toInt())));

      }
    }

    else {
      if (type == 'cod' || type == 'coc') {
        Map<String, dynamic> address2 = {
          'city': widget.city,
          'fulladdress': widget.address,
          'phonenumber': user.phoneNumber,
          'postalcode': widget.zip,
          'state': widget.state
        };
        final databaseReference = FirebaseFirestore.instance;
        databaseReference.collection('Orders').doc(orderid).set({
          'Address': address2,
          'couponUsed':discount.title,
          'discountPrice':dis,
          'GrandTotal': totalAmount() +
              (totalAmount() * 0.1 + double.parse(ShippingCharge)),
          'Items': items,
          'Price': prices,
          'Qty': quantities,
          'productId': productsid,
          'Status': 'Order Placed',
          'TimeStamp': Timestamp.now(),
          'UserID': user.uid,
          'imgUrl': image,
          'orderid': orderid,
          'orderType': type
        });
      removeAll();
        updatepro(items,quantities);
        alert(coins.toInt());
        callapi(orderid);
        Fluttertoast.showToast(
            msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(coins.toInt())));
      }
    }
    if (type == 'payatstore') {
      final databaseReference = FirebaseFirestore.instance;
      databaseReference.collection('Orders').doc(orderid).set({

        'GrandTotal': totalAmount() + (totalAmount() * 0.1),
        'couponUsed':discount.title,
        'discountPrice':dis,
        'Items': items,
        'Price': prices,
        'Qty': quantities,
        'productId': productsid,
        'Status': 'Order Placed',
        'TimeStamp': Timestamp.now(),
        'UserID': user.uid,
        'imgUrl': image,
        'orderid': orderid,
        'orderType': type
      });

      removeAll();
      updatepro(items,quantities);
      callapi(orderid);
      alert(coins.toInt());
      Fluttertoast.showToast(
          msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen(coins.toInt())));
    }
  }




  void removeAll() async {
    // Assuming that the number of rows is the id for the last row.
    for (var v in cartItems) {
      final rowsDeleted = await dbHelper.delete(v.productName);
    }
  }
  void callapi(String orderid)async{
    print('rEACHED');
    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    final String apiUrl = "http://api.sparrowsms.com/v2";
    Map map = {
      "token": 'v2_r7OFGQG1crKK1lNJJJAYpqslNHD.eJeE',
      "from": "Demo",
      "to": user.phoneNumber,
      "text": 'Dear ${user.displayName}, your order ${orderid} is ${'Order Placed'}. Please visit our website/app and check your dashboard.'
    };
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));

    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    var reply = await response.transform(utf8.decoder).join();
    httpClient.close();
print('-------------------------------------------');
    print(reply);




  }

  @override
  void initState() {

    getAllItems();
    getUserDetails();
    points();
    area();
    proid(widget.newitems);

    // TODO: implement initState
    super.initState();
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
                              builder: (context) => MyAddresses2(user.uid,widget.store,widget.newitems)));
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
              discount == null
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No promo code applied!'),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ApplyOffers(this, context);
                          }));
                    },
                    child: Text(
                      ' Apply Promo Code',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${discount.discount}% off promo code applied!'),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ApplyOffers(this, context);
                          }));
                    },
                    child: Text(
                      ' Change',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('${cartItems.length.toString()}',
                                  style: GoogleFonts.poppins(
                                      color: primarycolor,
                                      fontSize: height * 0.017,
                                      fontWeight: FontWeight.bold)),
                              (cartItems.length > 1)
                                  ? Text(' Items in Cart',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: height * 0.017,
                                          fontWeight: FontWeight.w500))
                                  : Text(' Item in Cart',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: height * 0.017,
                                          fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.29,
                          width: width * 0.9,
                          child: ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (BuildContext ctxt, int i) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: FancyShimmerImage(
                                          imageUrl: cartItems[i].imgUrl,
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
                                                cartItems[i].productName,
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
                                                    'Qty: ${cartItems[i].qty.toString()}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    'Price: Rs ${cartItems[i].price.toString()}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                    placeOrder('cod');
                  },
                  child: Container(
                      height: height * 0.08,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Center(
                          child: Text('Cash on Delivery',
                              style: TextStyle(
                                  fontSize: height * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))))):InkWell(
                  onTap: () {
                    placeOrder('payatstore');
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
              (type!='Pay at store')?InkWell(
                  onTap: () {
                    placeOrder('coc');
                  },
                  child: Container(
                      height: height * 0.08,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Center(
                          child: Text('Card on Delivery',
                              style: TextStyle(
                                  fontSize: height * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))))):Container(),
              SizedBox(height: height * 0.02),
              (type!='Pay at store')? InkWell(
                  onTap: () {},
                  child: Container(
                      height: height * 0.08,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Center(
                          child: Text('Pay online',
                              style: TextStyle(
                                  fontSize: height * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))))):Container(),
              SizedBox(height: height * 0.02),
            ],
          ),
        ));
  }
}
