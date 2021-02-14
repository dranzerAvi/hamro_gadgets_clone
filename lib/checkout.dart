import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/home_screen.dart';
import 'package:hamro_gadgets/my_addresses2.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  String address,city,state,zip,orderid;
  Checkout(this.address,this.city,this.state,this.zip,this.orderid);
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
  String state = 'Bagmati';
  String country = 'India';
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
  }

  double totalAmount() {
    double sum = 0;
    getAllItems();
    for (int i = 0; i < cartItems.length; i++) {
      sum += (double.parse(cartItems[i].price) * cartItems[i].qty);
    }
    return sum;
  }
  User user;

  getUserDetails() async {
    user = FirebaseAuth.instance.currentUser;
  }

  Widget Bill() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sub Total-'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.187,
//                  ),
//                  Text(':'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
                  Text('Rs. ${totalAmount().toString()}')
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
                  Text('Taxes and Charges-'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
//                  Text(':'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
                  Text('Rs. ${(totalAmount() * 0.18).toStringAsFixed(2)}'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
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
                  Text('Grand Total-'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.147,
//                  ),
//                  Text(':'),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.03,
//                  ),
                  Text('Rs. ${((totalAmount() * 0.18) + totalAmount())}'),
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
  String orderid;
  void placeOrder() async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    orderid= prefs.getString('Orderid');
    await getUserDetails();
    List items = [];
    List prices = [];
    List quantities = [];
    List image=[];
    for (var v in cartItems) {
      print(v.productName);
      items.add(v.productName);
      prices.add(v.price);
      quantities.add(v.qty);
      image.add(v.imgUrl);
    }
   if (widget.address==''&&widget.address==null){
     Map<String,dynamic> address1={'city':_city.text,'fulladdress':'${addressController.text},${_address2.text}','phonenumber':'+91${_phnNo.text}','postalcode':_zip.text,'state':state};
     final databaseReference = FirebaseFirestore.instance;
     databaseReference.collection('Orders').doc(orderid).set({
       'Address':address1,
       'GrandTotal':totalAmount() + (totalAmount() * 0.1 + 20),
       'Items':items,
       'Price':prices,
       'Qty':quantities,
       'Status':'Order Placed',
       'TimeStamp':Timestamp.now(),
       'UserID':user.uid,
       'imgUrl':image,
       'orderid':orderid


     });
     removeAll();
     Fluttertoast.showToast(
         msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
     Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>HomeScreen()));

   }
   else{
     Map<String,dynamic> address2={'city':widget.city,'fulladdress':widget.address,'phonenumber':user.phoneNumber,'postalcode':widget.zip,'state':widget.state} ;
     final databaseReference = FirebaseFirestore.instance;
     databaseReference.collection('Orders').doc(orderid).set({
       'Address':address2,
       'GrandTotal':totalAmount() + (totalAmount() * 0.1 + 20),
       'Items':items,
       'Price':prices,
       'Qty':quantities,
       'Status':'Order Placed',
       'TimeStamp':Timestamp.now(),
       'UserID':user.uid,
       'imgUrl':image,
       'orderid':orderid


     });
     removeAll();
     Fluttertoast.showToast(
         msg: 'Your order has been placed', toastLength: Toast.LENGTH_SHORT);
     Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>HomeScreen()));
   }




  }
  void removeAll() async {
    // Assuming that the number of rows is the id for the last row.
    for (var v in cartItems) {
      final rowsDeleted = await dbHelper.delete(v.productName);
    }
  }

  @override
  void initState() {
    getAllItems();
    getUserDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
              (widget.address=='')? Column(children: [
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
                            child: new DropdownButton<String>(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyAddresses2(user.uid)));
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
              ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:EdgeInsets.only(top:height*0.015,left:width*0.07),
                child: Text('Items',textAlign:TextAlign.left,style:TextStyle(color:Colors.black.withOpacity(0.8),fontSize: height*0.025,fontWeight: FontWeight.w500)),
              ),
            ),
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
              InkWell(
                  onTap: () {
                    placeOrder();
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
                                  color: Colors.white))))),
              SizedBox(height: height * 0.02),
              InkWell(
                  onTap: () {
                    placeOrder();
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
                                  color: Colors.white))))),
              SizedBox(height: height * 0.02),
              InkWell(
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
                                  color: Colors.white))))),
              SizedBox(height: height * 0.02),
            ],
          ),
        ));
  }
}
