import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Bookmarks.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/order.dart';
import 'package:hamro_gadgets/order_placed.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  User user;
  List<Order>reorders=[];
  void getdetails()async{
    final FirebaseAuth _auth=FirebaseAuth.instance;
    user= _auth.currentUser;
  }
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Ordercount')
        .doc('ordercount')
        .snapshots()
        .listen((event) {
      print(event['Numberoforders'].toString());

      order = event['Numberoforders'];
    });
    getAllItems();
    getdetails();
    super.initState();
  }
  void getAllItems() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    await allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    setState(() {
      total = cartItems.length;

      for (var v in cartItems) {
        print('######${v.productName}');
//        if (v.productName == widget.name) {
//          qty = v.qty;
//        }
      }
//      print(cartItems[1]);
    });
  }
  final dbHelper = DatabaseHelper.instance;
  static List<bool> check = [false, false, false, false, false];
 
  Cart item;
  bool isWishlist = false;
  int total = 0;

  var length;
  var lengthWishlist;
  var qty = 1;
  bool present = false;
  int choice = 0;
  int order;
  String orderid;
  String desc='reorder';
  List<Cart> cartItems = [];
  void addToCart(ctxt,
      {String name,
        String imgUrl,
        String price,
        int qty,
        String productDesc}) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductName: name,
      DatabaseHelper.columnImageUrl: imgUrl,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnQuantity: qty,
      DatabaseHelper.columnProductDescription: productDesc,
    };
    if (cartItems.length == 0) {
      await print('----------------$order');
      if (order + 1 < 9) {
        await setState(() {
          orderid = 'HAMRO0000${order + 1}';
        });
      }
      if (order + 1 > 10 && order + 1 < 99) {
        await setState(() {
          orderid = 'HAMRO000${order + 1}';
        });
      }
      if (order + 1 > 99 && order + 1 < 999) {
        await setState(() {
          orderid = 'HAMRO00${order + 1}';
        });
      }
      if (order + 1 > 999 && order + 1 < 9999) {
        await setState(() {
          orderid = 'HAMRO0${order + 1}';
        });
      }
      if (order + 1 > 9999 && order + 1 < 99999) {
        await setState(() {
          orderid = 'HAMRO${order + 1}';
        });
      }
      if (order + 1 > 99999) {
        await setState(() {
          orderid = 'HAMRO${order + 1}';
        });
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Orderid', orderid);
      print(orderid);

      prefs.setString('Status', 'Order Placed');
      await FirebaseFirestore.instance
          .collection('Ordercount')
          .doc('ordercount')
          .update({
        'Numberoforders': order + 1,
      });
    }

    Cart item = Cart.fromMap(row);
    final id = await dbHelper.insert(item);
    final snackBar = SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Added to Cart'),
              InkWell(
                onTap: () {
//                  pushNewScreen(context,
//                      screen: BookmarksScreen(), withNavBar: true);
                },
                child: Text(
                  'View Cart',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ],
          ),
        ));
//    Scaffold.of(ctxt).showSnackBar(snackBar);
// Find the Scaffold in the widget tree and use it to show a SnackBar.


    setState(() {
      check[choice] = true;
    });
   
  }
 
  void reorder(String id)async {
   await FirebaseFirestore.instance.collection('Orders').doc(id).get().then((value) {
      Map map=value.data();
      print(map['imgUrl']);
      setState(() {
        reorders.add(Order(
            prices: map['Price'],
            items: map['Items'],
            total: map['GrandTotal'].toString(),
            quantities: map['Qty'],
            status: map['Status'],
            timestamp: map['TimeStamp'],
            images:map['imgUrl'],

            id: map['UserId']));
      });
print(reorders.length);
      
    });
    await  place();
  }
  void place(){
    for(int i =0;i<reorders[0].items.length;i++) {
      addToCart(context,name:reorders[0].items[i],imgUrl:reorders[0].images[i],price:reorders[0].prices[i],qty:reorders[0].quantities[i],productDesc:desc);
    }
    Fluttertoast.showToast(
        msg: 'Added to cart', toastLength: Toast.LENGTH_SHORT);
    Navigator.push(context,MaterialPageRoute(builder:(context)=>BookmarksScreen()));
  }
  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Place Order"),
          content: Text("Are you sure you want to re-order?"),
          actions: [
            FlatButton(
              color: Colors.red,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              color: primarycolor,
              child: Text("Yes"),
              onPressed: () {

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Order> orders = List<Order>();
    return Scaffold(
      appBar:AppBar(
        backgroundColor: primarycolor,
        title:Text('My Orders',style:GoogleFonts.poppins(color:Colors.white,fontWeight:FontWeight.bold)),
        centerTitle:true,
      ),
      body:SingleChildScrollView(
        child: Column(
            children:[

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Orders')
                    .where('UserID',isEqualTo: user.uid)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    orders.clear();
                    print('-------------${snap.data.docs.length}');
                    print(user.uid);
                    for (int i = 0; i < snap.data.docs.length; i++) {
                      print(snap.data.docs[i]['Price'].toString());
                      print('------------------');
                      print(snap.data.docs[i]['Qty'].toString());
                      print('items');
                      print(snap.data.docs[i]['Items'].toString());

                      print(orders.length);
                      String str = '';
                      for (int it = 0;
                      it <= snap.data.docs[i]['Items'].length - 1;
                      it++) {
                        it != snap.data.docs[i]['Items'].length - 1
                            ? str = str +
                            '${snap.data.docs[i]['Qty'][it]} x ${snap.data.docs[i]['Items'][it]}, '
                            : str = str +
                            '${snap.data.docs[i]['Qty'][it]} x ${snap.data.docs[i]['Items'][it]}';
                      }
                      orders.add(Order(
                          prices: snap.data.docs[i]['Price'],
                          items: snap.data.docs[i]['Items'],
                          total: snap.data.docs[i]['GrandTotal'].toString(),
                          quantities: snap.data.docs[i]['Qty'],
                          status: snap.data.docs[i]['Status'],
                          timestamp: snap.data.docs[i]['TimeStamp'],
                          images:snap.data.docs[i]['imgUrl'],
                          orderString: str,
                          id: snap.data.docs[i].id));
                    }
                    return orders.length != 0
                        ? Container(
                      height:height*0.87,
                      width:width*0.98,
                      child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(15.0, 8, 8, 8),
                              child: InkWell(
                                onTap: () async {
                                  Navigator.push(context,MaterialPageRoute(builder:(context)=>OrderPlaced(orders[index].id,orders[index].images,orders[index].quantities,orders[index].prices,orders[index].timestamp,orders[index].total,orders[index].status,orders[index].items)));

                                },
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Order Id-${orders[index].id}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            color: Colors.black.withOpacity(0.1),
                                            height: 1,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Items',
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(color:secondarycolor),
                                                height:height*0.2,
                                                width:width*0.86,
                                                child: ListView.separated(
                                                  separatorBuilder: (context,index){
                                                    return SizedBox(height:height*0.02);
                                                  },
                                                  itemCount: orders[index].images.length,
                                                  itemBuilder: (context,index2){

                                                    return Row(
                                                      children: [
                                                        Container(
                                                          child: FancyShimmerImage(
                                                            imageUrl: orders[index].images[index2],
                                                            shimmerDuration: Duration(seconds: 2),
                                                          ),
                                                          height: 80,
                                                          width: 80,
                                                        ),
                                                        SizedBox(width: width * 0.02),
                                                        Container(
                                                          height: 80,
                                                          width:width*0.5,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                    0.8,
                                                                child: Text(
                                                                  orders[index].items[index2],
                                                                  style: GoogleFonts.poppins(fontSize: height*0.02),
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
                                                                      'Qty: ${orders[index].quantities[index2].toString()}',
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 15,
                                                                          fontWeight:
                                                                          FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Text(
                                                                      'Price: Rs ${orders[index].prices[index2].toString()}',
                                                                      style: GoogleFonts.poppins(
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
                                                    );
                                                  },

                                                ),
                                              ),


                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Ordered On',
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            orders[index]
                                                .timestamp
                                                .toDate()
                                                .day
                                                .toString() +
                                                '-' +
                                                orders[index]
                                                    .timestamp
                                                    .toDate()
                                                    .month
                                                    .toString() +
                                                '-' +
                                                orders[index]
                                                    .timestamp
                                                    .toDate()
                                                    .year
                                                    .toString() +
                                                ' at ' +
                                                orders[index]
                                                    .timestamp
                                                    .toDate()
                                                    .hour
                                                    .toString() +
                                                ':' +
                                                orders[index]
                                                    .timestamp
                                                    .toDate()
                                                    .minute
                                                    .toString(),
                                            style: GoogleFonts.poppins(fontSize: 14),
                                          ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceEvenly,
                                          //   children: [
                                          //     Container(
                                          //         width: MediaQuery.of(context)
                                          //                 .size
                                          //                 .width *
                                          //             0.3,
                                          //         child: Center(
                                          //             child: Text('Name'))),
                                          //     Container(
                                          //         width: MediaQuery.of(context)
                                          //                 .size
                                          //                 .width *
                                          //             0.3,
                                          //         child: Center(
                                          //             child: Text('Quantity'))),
                                          //     Container(
                                          //         width: MediaQuery.of(context)
                                          //                 .size
                                          //                 .width *
                                          //             0.3,
                                          //         child: Center(
                                          //             child: Text('Price'))),
                                          //   ],
                                          // ),
                                          // Container(
                                          //   height:
                                          //       40.0 * orders[index].items.length,
                                          //   child: ListView.builder(
                                          //       itemCount:
                                          //           orders[index].items.length,
                                          //       itemBuilder: (context, i) {
                                          //         return Row(
                                          //           // mainAxisAlignment:
                                          //           //     MainAxisAlignment
                                          //           //         .spaceEvenly,
                                          //           children: [
                                          //             Container(
                                          //               width:
                                          //                   MediaQuery.of(context)
                                          //                           .size
                                          //                           .width *
                                          //                       0.3,
                                          //               child: Center(
                                          //                 child: Text(
                                          //                   orders[index]
                                          //                       .items[i]
                                          //                       .toString(),
                                          //                   textAlign:
                                          //                       TextAlign.center,
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //             Container(
                                          //               width:
                                          //                   MediaQuery.of(context)
                                          //                           .size
                                          //                           .width *
                                          //                       0.3,
                                          //               child: Center(
                                          //                 child: Text(
                                          //                     orders[index]
                                          //                         .quantities[i]
                                          //                         .toString()),
                                          //               ),
                                          //             ),
                                          //             Container(
                                          //               width:
                                          //                   MediaQuery.of(context)
                                          //                           .size
                                          //                           .width *
                                          //                       0.3,
                                          //               child: Center(
                                          //                 child: Text(
                                          //                     orders[index]
                                          //                         .prices[i]
                                          //                         .toString()),
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         );
                                          //       }),
                                          // ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceAround,
                                          //   children: [
                                          //     Container(
                                          //         width: MediaQuery.of(context)
                                          //                 .size
                                          //                 .width *
                                          //             0.45,
                                          //         child: Center(
                                          //             child: Text('Amount-'))),
                                          //     Container(
                                          //         width: MediaQuery.of(context)
                                          //                 .size
                                          //                 .width *
                                          //             0.45,
                                          //         child: Center(
                                          //           child:
                                          //               Text(orders[index].total),
                                          //         )),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceAround,
                                          //   children: [
                                          //     Container(
                                          //         width: MediaQuery.of(context)
                                          //                 .size
                                          //                 .width *
                                          //             0.45,
                                          //         child: Center(
                                          //             child: Text('Status-'))),
                                          //     Container(
                                          //       width: MediaQuery.of(context)
                                          //               .size
                                          //               .width *
                                          //           0.45,
                                          //       child: Center(
                                          //         child: Text(orders[index]
                                          //             .status
                                          //             .toString()),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // SizedBox(
                                          //   height: 10,

                                          // ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Total',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Rs. ' + orders[index].total,
                                            style: GoogleFonts.poppins(fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            color: Colors.black.withOpacity(0.1),
                                            height: 1,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                orders[index].status,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              InkWell(
                                                 onTap:(){
                                                   reorder(orders[index].id);
                                                 },
                                                child: Container(
                                                  height:20,
                                                  width:80,
                                                  decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),color:primarycolor),
                                                  child:Center(child: Text('Re-order',style:GoogleFonts.poppins(color:Colors.white)))
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                        : Container();
                  } else
                    return Container(
                        child: Center(
                            child: Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())));
                },
              )
            ]
        ),
      )
    );
  }
}
