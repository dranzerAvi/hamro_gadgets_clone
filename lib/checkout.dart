import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/services/database_helper.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController _email=TextEditingController();
  TextEditingController _first=TextEditingController();
  TextEditingController _last=TextEditingController();
  TextEditingController _city=TextEditingController();
  TextEditingController _zip=TextEditingController();
  TextEditingController _phnNo=TextEditingController();
TextEditingController _address2=TextEditingController();


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
                  Text(
                     
                       'Rs. ${((totalAmount() * 0.18) + totalAmount())}'),
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
  void initState() {
    getAllItems();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(

        backgroundColor: primarycolor,
        title:Text('Hamro Gadgets'),
        centerTitle:true,
      ),
      body:SingleChildScrollView(
        child: Column(

          children: [
            Column(
              children:[
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                  child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextFormField(controller:_email,decoration: InputDecoration(border: InputBorder.none,hintText: 'Your email'),),
                  )),
                ),
                Divider(color:Colors.grey),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                  child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextFormField(controller:_first,decoration: InputDecoration(border: InputBorder.none,hintText: 'First Name'),),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                  child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextFormField(controller:_last,decoration: InputDecoration(border: InputBorder.none,hintText: 'Last Name'),),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                  child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextFormField(controller:addressController,decoration: InputDecoration(border: InputBorder.none,),),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                  child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextFormField(controller:_address2,decoration: InputDecoration(border: InputBorder.none,),),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                  child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextFormField(controller:_city,decoration: InputDecoration(border: InputBorder.none,),),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                  child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextFormField(controller:_zip,decoration: InputDecoration(border: InputBorder.none,),),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                  child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextFormField(controller:_phnNo,decoration: InputDecoration(border: InputBorder.none),),
                  )),
                ),
              ]
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:EdgeInsets.only(top:height*0.015,left:width*0.07),
                child: Text('Items',textAlign:TextAlign.left,style:TextStyle(color:Colors.black.withOpacity(0.8),fontSize: height*0.025,fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.29,
              child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (BuildContext ctxt, int i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              child: FancyShimmerImage(
                                imageUrl: cartItems[i].imgUrl,
                                shimmerDuration: Duration(seconds: 2),
                              ),
                              height: 80,
                              width: 80,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                cartItems[i].productName,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Qty: ${cartItems[i].qty.toString()}',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Price: Rs ${cartItems[i].price.toString()}',
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height:height*0.02),
            Align(
              alignment:Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Delivery Address',style:TextStyle(color:Colors.black.withOpacity(0.8),fontSize: height*0.025,fontWeight: FontWeight.w500)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField( decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(2),
                      borderSide:
                      BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(2),
                      borderSide:
                      BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(2),
                      borderSide: BorderSide(
                          color: primarycolor)),
                  hintText: 'Your address'),
                maxLines: 4,
                controller: addressController,),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Bill',style:TextStyle(color:Colors.black.withOpacity(0.8),fontSize: height*0.025,fontWeight: FontWeight.w500)),
              ),
            ),
            Bill(),

            Align(
              alignment:Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Choose payment method',style:TextStyle(color:Colors.black.withOpacity(0.8),fontSize: height*0.025,fontWeight: FontWeight.w500)),
              ),
            ),
            SizedBox(height:height*0.02),
            InkWell(onTap:(){},child: Container(height:height*0.08,width:width*0.9,decoration:BoxDecoration(color: primarycolor,borderRadius: BorderRadius.all(Radius.circular(5.0))),child:Center(child: Text('Cash on Delivery',style:TextStyle(fontSize: height*0.025,fontWeight: FontWeight.bold,color:Colors.white))))),
            SizedBox(height:height*0.02),
            InkWell(onTap:(){},child: Container(height:height*0.08,width:width*0.9,decoration:BoxDecoration(color: primarycolor,borderRadius: BorderRadius.all(Radius.circular(5.0))),child:Center(child: Text('Pay online',style:TextStyle(fontSize: height*0.025,fontWeight: FontWeight.bold,color:Colors.white))))),
            SizedBox(height:height*0.02),
          ],
        ),
      )
    );
  }
}
    