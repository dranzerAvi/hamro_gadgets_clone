import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/order.dart';
import 'package:hamro_gadgets/widgets/nav_drawer.dart';

class OrderPlaced extends StatefulWidget {
  List<dynamic>images=[]; List<dynamic>prices=[];List<dynamic>quantities=[];List<dynamic>items=[];
  String id,status,total;
  Timestamp timestamp;
  OrderPlaced(this.id,this.images,this.quantities,this.prices,this.timestamp,this.total,this.status,this.items);
  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('HamroGadgets',style:GoogleFonts.poppins(color:Colors.white,fontWeight: FontWeight.bold)),
        centerTitle: true,
//       actions: [
//
//         Center(child: Container(width:width*0.5,child: TextFormField(controller:_cont,decoration: InputDecoration(filled: true,fillColor: Colors.white,prefixIcon: Icon(Icons.search,color:Colors.grey),hintText: 'Search here',hintStyle: TextStyle(color:Colors.grey)),)))
//       ],
      ),
      drawer: CustomDrawer(),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Your order has been placed!!',style:GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: height*0.025)),
            ),
            Container(
              height:height*0.3,
              width:width,
              child:Image.asset('assets/images/delivery.gif')
            ),
            Align(
              alignment:Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Order Summary',style:GoogleFonts.poppins(decoration:TextDecoration.underline,fontWeight: FontWeight.bold,fontSize: height*0.022)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                          'Order Id-${widget.id}',
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
                                itemCount: widget.images.length,
                                itemBuilder: (context,index){

                                  return Row(
                                    children: [
                                      Container(
                                        child: FancyShimmerImage(
                                          imageUrl: widget.images[index],
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
                                                widget.items[index],
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
                                                    'Qty: ${widget.quantities[index].toString()}',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    'Price: Rs ${widget.prices[index].toString()}',
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
                          widget
                              .timestamp
                              .toDate()
                              .day
                              .toString() +
                              '-' +
                              widget
                                  .timestamp
                                  .toDate()
                                  .month
                                  .toString() +
                              '-' +
                              widget
                                  .timestamp
                                  .toDate()
                                  .year
                                  .toString() +
                              ' at ' +
                              widget
                                  .timestamp
                                  .toDate()
                                  .hour
                                  .toString() +
                              ':' +
                              widget
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
                          'Rs. ' + widget.total,
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
                          widget.status,
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
          ],
        ),
      )
    );
  }
}
