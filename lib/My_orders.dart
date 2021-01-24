import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/order.dart';
import 'package:hamro_gadgets/order_placed.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  User user;
  void getdetails()async{
    final FirebaseAuth _auth=FirebaseAuth.instance;
    user= _auth.currentUser;
  }
  @override
  void initState() {
    getdetails();
    super.initState();
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
                                                  itemBuilder: (context,index){

                                                    return Row(
                                                      children: [
                                                        Container(
                                                          child: FancyShimmerImage(
                                                            imageUrl: orders[index].images[index],
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
                                                                  orders[index].items[index],
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
                                                                      'Qty: ${orders[index].quantities[index].toString()}',
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 15,
                                                                          fontWeight:
                                                                          FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Text(
                                                                      'Price: Rs ${orders[index].prices[index].toString()}',
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
                                          Text(
                                            orders[index].status,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
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
