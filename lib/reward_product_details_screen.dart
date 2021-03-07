import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Bookmarks.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/checkout2.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardProductDetailsScreen extends StatefulWidget {
  String imageUrl;
  String name;
  int mp;
  int disprice;
  String description;
  dynamic details;
  List<String> detailsurls = [];
  String rating;
  dynamic specs;
  int quantity;
  double scHeight;
  double scWidth;
  int rewardpoints;
  RewardProductDetailsScreen(
      this.imageUrl,
      this.name,
      this.mp,
      this.disprice,
      this.description,
      this.details,
      this.detailsurls,
      this.rating,
      this.specs,
      this.quantity,
      this.scHeight,
      this.scWidth,
      this.rewardpoints
      );
  @override
  _RewardProductDetailsScreenState createState() => _RewardProductDetailsScreenState();
}

class _RewardProductDetailsScreenState extends State<RewardProductDetailsScreen> {
  int order=0;
  first() async {
    await FirebaseFirestore.instance
        .collection('Ordercount')
        .doc('ordercount')
        .snapshots()
        .listen((event) {
      print(event['Numberoforders'].toString());

      order = event['Numberoforders'];
    });

  }
  final dbHelper = DatabaseHelper.instance;
  List<Cart> cartItems = [];
  int total=0;

  void getAllItems() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    await allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    setState(() {
      total = cartItems.length;

      for (var v in cartItems) {
        print('######${v.productName}');
        if (v.productName == widget.name) {
//          qty = v.qty;
        }
      }
//      print(cartItems[1]);
    });
  }
  bool inStore=false;
  var orderid='';
  void procheck()async{
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


    List<String> newItems=[];
    newItems.add(widget.name.toString());
//    orderid=prefs.getString('orderid');

    FirebaseFirestore.instance.collection('RewardProducts').where('inStore',isEqualTo: true).snapshots().forEach((element) {
      for(int i=0;i<element.docs.length;i++){
        if(element.docs[i]['name']==widget.name){
          print(element.docs[i]['name']);
          setState(() {
            inStore=true;
          });
        }
      }
      Navigator.push(context, MaterialPageRoute(builder:(context)=>Checkout2('', '', '', '',orderid , inStore, newItems, widget.rewardpoints, widget.imageUrl)));
    });

  }
  List<Widget> details = [];
  List<Widget> specs = [];
  int index = 0;
  initializeDetails() {
    widget.details.forEach((k, v) {
      if (index % 2 == 0) {
        details.add(Container(
          width: double.infinity,
          color: secondarycolor,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(width: 150, child: Text(k)),
                  Container(width: widget.scWidth - 182, child: Text(v))
                ],
              ),
            ),
          ),
        ));
        index++;
      } else {
        details.add(Container(
          width: double.infinity,
          color: Colors.white,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(width: 150, child: Text(k)),
                  Container(width: widget.scWidth - 182, child: Text(v))
                ],
              ),
            ),
          ),
        ));
        index++;
      }
    });
    widget.specs.forEach((k, v) {
      if (index % 2 == 0) {
        specs.add(Container(
          width: double.infinity,
          color: secondarycolor,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(width: 150, child: Text(k)),
                  Container(width: widget.scWidth - 182, child: Text(v))
                ],
              ),
            ),
          ),
        ));
        index++;
      } else {
        specs.add(Container(
          width: double.infinity,
          color: Colors.white,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(width: 150, child: Text(k)),
                  Container(width: widget.scWidth - 182, child: Text(v))
                ],
              ),
            ),
          ),
        ));
        index++;
      }
    });
  }

  @override
  void initState() {
    first();
    initializeDetails();
    getAllItems();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var heightOfStack = MediaQuery.of(context).size.height / 2.8;
    var aPieceOfTheHeightOfStack = heightOfStack - heightOfStack / 3.5;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: primarycolor,
                elevation: 0.0,
                title: Text('Hamro Gadgets',
                    style: TextStyle(color: Colors.white)),
                centerTitle: true,
                leading: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                actions: [
                  InkWell(
                      onTap: () {},
                      child: Icon(Icons.share, color: Colors.white)),
                  SizedBox(width: 8),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookmarksScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            total != null
                                ? total > 0
                                ? Positioned(
                              bottom:
                              MediaQuery.of(context).size.height *
                                  0.04,
                              left:
                              MediaQuery.of(context).size.height *
                                  0.013,
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 2.0),
                                child: CircleAvatar(
                                  radius: 6.0,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  child: Text(
                                    total.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : Container()
                                : Container(),
                          ],
                        ),
                      )),
                  SizedBox(
                    width: 14,
                  )
                ]),
            body: SafeArea(
              child: Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(shrinkWrap: true, children: [
                          Stack(
                            children: [
                              Container(
                                height: height * 0.45,
                                width: MediaQuery.of(context).size.width,
                                child: GFCarousel(
                                  items: widget.detailsurls.map(
                                        (url) {
                                      return Container(
                                        width: width,
                                        height: 180,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: FancyShimmerImage(
                                            shimmerDuration: Duration(seconds: 2),
                                            imageUrl: '$url',
                                            width: 10000.0,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onPageChanged: (index) {
                                    setState(() {
                                      //                                    print('change');
                                    });
                                  },
                                  viewportFraction: 1.0,
                                  aspectRatio:
                                  (MediaQuery.of(context).size.width / 28) /
                                      (MediaQuery.of(context).size.width / 40),
                                  autoPlay: true,
                                  pagination: true,
                                  passiveIndicator: Colors.grey.withOpacity(0.4),
                                  activeIndicator: Colors.black.withOpacity(0.3),
                                  pauseAutoPlayOnTouch: Duration(seconds: 8),
                                  pagerSize: 8,
                                ),
                              ),
//                              isWishlist
//                                  ? Padding(
//                                padding: const EdgeInsets.only(top: 20.0),
//                                child: Align(
//                                  alignment: Alignment.topLeft,
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        shape: BoxShape.circle,
//                                        border:
//                                        Border.all(color: Colors.black)),
//                                    child: Padding(
//                                      padding: const EdgeInsets.all(2.0),
//                                      child: InkWell(
//                                          onTap: () async {
//                                            setState(() {
//                                              isWishlist = !isWishlist;
//                                            });
//                                            removeItemWishlist(widget.name);
//                                          },
//                                          child: Image.asset(
//                                              'assets/images/added.png',
//                                              height: height * 0.03,
//                                              width: width * 0.08)),
//                                    ),
//                                  ),
//                                ),
//                              )
//                                  : Padding(
//                                padding: const EdgeInsets.only(top: 20.0),
//                                child: Align(
//                                  alignment: Alignment.topLeft,
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        shape: BoxShape.circle,
//                                        border:
//                                        Border.all(color: Colors.black)),
//                                    child: Padding(
//                                      padding: const EdgeInsets.all(2.0),
//                                      child: InkWell(
//                                          onTap: () {
//                                            setState(() {
//                                              isWishlist = !isWishlist;
//                                              addToWishlist(context,
//                                                  name: widget.name,
//                                                  price: widget.disprice
//                                                      .toString(),
//                                                  imgUrl: widget.imageUrl);
//                                            });
//                                          },
//                                          child: Image.asset(
//                                              'assets/images/remove.png',
//                                              height: height * 0.03,
//                                              width: width * 0.08)),
//                                    ),
//                                  ),
//                                ),
//                              ),
                            ],
                          ),

//                      Container(
//                        height:100,
//
//                        child:Row(
//                          children:[
//                            SizedBox(width:14),
//                            Expanded(
//                              flex:1,
//                              child:InkWell(
//                                onTap:(){
//                                  setState(() {
//                                    urlUniv=widget.detailsurls[0];
//
//                                  });
//                                },
//                                child: Padding(
//                                  padding: const EdgeInsets.all(4.0),
//                                  child: Container(
//                                    height: 65,
//                                    width:width*0.1,
//                                    decoration: BoxDecoration(
//                                        borderRadius: BorderRadius.all(
//                                            Radius.circular(5)),
//                                        border: Border.all(
//                                          width: 2,
//                                          color: urlUniv !=
//                                              widget.detailsurls[0]
//
//                                              ? Colors.transparent
//                                              : primarycolor
//                                        )),
//                                    child: ClipRRect(
//                                      borderRadius:
//                                      BorderRadius.circular(4.0),
//                                      child: FancyShimmerImage(
//                                        shimmerDuration:
//                                        Duration(seconds: 2),
//                                        imageUrl:
//                                        widget.detailsurls[0],
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              )),
//                            Expanded(
//                                flex: 1,
//                                child: InkWell(
//                                  onTap: () {
//                                    setState(() {
//                                      urlUniv = url2;
//                                    });
//                                  },
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(4.0),
//                                    child: Container(
//                                        height: 65,
//                                        decoration: BoxDecoration(
//                                            borderRadius: BorderRadius.all(
//                                                Radius.circular(5)),
//                                            border: Border.all(
//                                              width: 2,
//                                              color: urlUniv != url2
//                                                  ? Colors.transparent
//                                                  : primarycolor
//                                            )),
//                                        child: ClipRRect(
//                                          borderRadius:
//                                          BorderRadius.circular(4.0),
//                                          child: FancyShimmerImage(
//                                            shimmerDuration:
//                                            Duration(seconds: 2),
//                                            // height: 80,
//                                            imageUrl: url2,
//                                          ),
//                                        )),
//                                  ),
//                                )),
//                            //just to push
////                            Expanded(
////                              flex:2,
////                              child:Padding(
////                                padding: const EdgeInsets.symmetric(
////                                    vertical: 8.0) ,
////                                child: Container(
////
////                                  decoration:BoxDecoration(
////                                    color:primarycolor,
////                                    border:Border.all(
////                                      width:2,
////                                      color:primarycolor
////                                    ),
////                                    borderRadius:BorderRadius.only(
////                                      topLeft: Radius.circular(10),
////                                      bottomLeft: Radius.circular(10)
////                                    )
////                                  ),
////                                  child:Column(
////                                    mainAxisAlignment: MainAxisAlignment.center,
////                                    children: [
////                                      Text('Rs. ${widget.disprice.toString()}',textAlign: TextAlign.left,style:TextStyle(color:Colors.white,fontSize:height*0.03,fontWeight: FontWeight.w600)),
////
////
////                                    ],
////                                  )
////                                ),
////                              )
////                            )
//                              ]),
//
//                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(widget.name,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: height * 0.03,
                                        fontWeight: FontWeight.w500))),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: RatingBar.builder(
                                initialRating: double.parse(widget.rating),
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ),
                          ),
                          widget.quantity > 0
                              ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: height * 0.02,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text('In Stock',
                                        style: GoogleFonts.poppins(
                                            color: Colors.green)),
                                  )
                                ])),
                          )
                              : Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: height * 0.02,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Out of stock',
                                            style: GoogleFonts.poppins(
                                                color: Colors.red),
                                          ),
                                        ))
                                  ],
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 13.0),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: [
//                                    Padding(
//                                      padding: const EdgeInsets.all(1.0),
//                                      child: Text('Rs.${(widget.mp).toString()}',
//                                          style: GoogleFonts.poppins(
//                                              fontSize: height * 0.017,
//                                              decoration:
//                                              TextDecoration.lineThrough,
//                                              fontWeight: FontWeight.w400)),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(1.0),
//                                      child: Text(
//                                          'Rs.${(widget.disprice).toString()}',
//                                          style: GoogleFonts.poppins(
//                                              fontSize: height * 0.023,
//                                              fontWeight: FontWeight.w500,
//                                              color: primarycolor)),
//                                    ),
//                                  ],
//                                ),
                              child:Row(children: [
                                  Text('Buy at : ',style:GoogleFonts.poppins(fontSize:height*0.02,fontWeight: FontWeight.bold)),
                Text('${widget.rewardpoints.toString()} coins ',style:GoogleFonts.poppins(fontSize:height*0.02)),
                Image.asset('assets/images/coins.png',height:height*0.025,)])
                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(right: 13.0),
//                                child: Container(
//                                    decoration: BoxDecoration(
//                                        shape: BoxShape.circle, color: Colors.red),
//                                    child: Padding(
//                                      padding: const EdgeInsets.all(10.0),
//                                      child: Align(
//                                          alignment: Alignment.bottomRight,
//                                          child: Text(
//                                            '- ${((int.parse(widget.mp.toString()) - int.parse(widget.disprice.toString())) / int.parse(widget.mp.toString()) * 100).toStringAsFixed(0)}%',
//                                            style: TextStyle(color: Colors.white),
//                                          )),
//                                    )),
//                              ),
                            ],
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Align(
                          //       alignment: Alignment.topLeft,
                          //       child: Text(
                          //           'Be the first one to review this product',
                          //           style: GoogleFonts.poppins(
                          //               color: primarycolor,
                          //               fontSize: height * 0.015,
                          //               fontWeight: FontWeight.w400))),
                          // ),
                          TabBar(
                              labelPadding: EdgeInsets.only(right: 0, left: 12),
                              labelColor: primarycolor,
                              indicatorColor: primarycolor,
                              isScrollable: true,
                              indicatorPadding: EdgeInsets.only(right: 0, left: 12),
                              tabs: [
                                Tab(
                                  child: Text('About product',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: height * 0.02,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Tab(
                                    child: Text('Details',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: height * 0.02,
                                            fontWeight: FontWeight.w500))),
                                Tab(
                                    child: Text('Specs',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: height * 0.02,
                                            fontWeight: FontWeight.w500))),
                              ]),
                          SingleChildScrollView(
                            child: Container(
                              height: height * 0.4,
                              width: width * 0.9,
                              child: TabBarView(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(widget.description,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: height * 0.018)),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: details,
                                        ),
                                      )),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: specs,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.03),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FancyShimmerImage(
                              shimmerDuration: Duration(seconds: 2),
                              imageUrl: widget.detailsurls[1],
                              width: MediaQuery.of(context).size.width,
                              height: heightOfStack,
                              boxFit: BoxFit.fill,
                            ),
                          )
                        ])),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
//                          qty != 0
//                              ? qty != null
//                              ? Container(
//                              height: 60,
//                              width: width * 0.16,
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.all(
//                                    Radius.circular(5)),
//                                color: Colors.grey.withOpacity(0.3),
//                              ),
//                              child: Row(
//                                mainAxisAlignment:
//                                MainAxisAlignment.spaceEvenly,
//                                children: [
//                                  Padding(
//                                    padding: const EdgeInsets.only(
//                                        left: 2.0),
//                                    child: Text(qty.toString(),
//                                        style: TextStyle(
//                                            color: Colors.black)),
//                                  ),
//                                  Column(
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.spaceEvenly,
//                                    children: [
//                                      InkWell(
//                                        onTap: () async {
//                                          await getAllItems();
//                                          for (var v in cartItems) {
//                                            if (v.productName ==
//                                                widget.name) {
//                                              var newQty = v.qty + 1;
//                                              updateItem(
//                                                productDesc:
//                                                v.productDesc,
//                                                id: v.id,
//                                                name: v.productName,
//                                                imgUrl: v.imgUrl,
//                                                price: v.price,
//                                                qty: newQty,
//                                              );
//                                            }
//                                          }
//                                        },
//                                        child: Icon(
//                                          Icons.keyboard_arrow_up,
//                                          color: Colors.black,
//                                        ),
//                                      ),
//                                      InkWell(
//                                        onTap: () async {
//                                          await getAllItems();
//
//                                          for (var v in cartItems) {
//                                            if (v.productName ==
//                                                widget.name) {
//                                              if (v.qty == 1) {
//                                                removeItem(
//                                                    v.productName);
//                                              } else {
//                                                var newQty = v.qty - 1;
//                                                updateItem(
//                                                  id: v.id,
//                                                  productDesc:
//                                                  v.productDesc,
//                                                  name: v.productName,
//                                                  imgUrl: v.imgUrl,
//                                                  price: v.price,
//                                                  qty: newQty,
//                                                );
//                                              }
//                                            }
//                                          }
//                                        },
//                                        child: Icon(
//                                          Icons.keyboard_arrow_down,
//                                          color: Colors.black,
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                ],
//                              ))
//                              : Row(
//                            children: [
//                              Container(
//                                  height: 60,
//                                  width: width * 0.16,
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.all(
//                                        Radius.circular(5)),
//                                    color:
//                                    Colors.grey.withOpacity(0.3),
//                                  ),
//                                  child: Row(
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.spaceEvenly,
//                                    children: [
//                                      Padding(
//                                        padding:
//                                        const EdgeInsets.only(
//                                            left: 2.0),
//                                        child: Text(qty2.toString(),
//                                            style: TextStyle(
//                                                color: Colors.black)),
//                                      ),
//                                      Column(
//                                        mainAxisAlignment:
//                                        MainAxisAlignment
//                                            .spaceEvenly,
//                                        children: [
//                                          InkWell(
//                                            onTap: () async {
//                                              await getAllItems();
//                                              setState(() {
//                                                qty2 = qty2 + 1;
//                                              });
//                                            },
//                                            child: Icon(
//                                              Icons.keyboard_arrow_up,
//                                              color: Colors.black,
//                                            ),
//                                          ),
//                                          InkWell(
//                                            onTap: () async {
//                                              setState(() {
//                                                (qty2 > 1)
//                                                    ? qty2 = qty2 - 1
//                                                    : qty2;
//                                              });
//                                            },
//                                            child: Icon(
//                                              Icons
//                                                  .keyboard_arrow_down,
//                                              color: Colors.black,
//                                            ),
//                                          )
//                                        ],
//                                      ),
//                                    ],
//                                  ))
//                            ],
//                          )
//                              : Container(),
//                      children: [
//                        present==false||present==null?
//                            InkWell(
//                              onTap:()async{
//                                var temp = await _queryWishlist(
//                                    widget.name);
//                                print(temp);
//                                if (temp == null)
//                                  addToWishlist(
//                                    context,
//                                    name: widget.name,
//                                    imgUrl: widget.detailsurls[0],
//                                    price: widget.disprice.toString(),
//                                  );
//                                else
//                                  setState(() {
//                                    print('Item already exists');
//                                    present = true;
//                                  });
//                              },
//                              child:Container(width:MediaQuery.of(context).size.width*0.5,height:height*0.1,color: Colors.white,child:Padding(
//                                padding: const EdgeInsets.only(top:20.0,left:8.0),
//                                child: Text('Save for later',textAlign:TextAlign.center,style:TextStyle(color:primarycolor,fontSize: height*0.025,fontWeight: FontWeight.w500
//                                )),
//                              ))
//
//                            ):InkWell(onTap:(){Navigator.push(context,MaterialPageRoute(builder:(context)=>WishlistScreen()));},child: Container(width:MediaQuery.of(context).size.width*0.5,height:height*0.1,color: Colors.white,child:Padding(
//                          padding: const EdgeInsets.only(top:20.0,left:8.0),
//                              child: Text('Saved in Wishlist',style:TextStyle(color:primarycolor,fontSize: height*0.025,fontWeight: FontWeight.w500)),
//                            ))),

//                          qty == 0 || qty == null
//                              ? InkWell(
//                              onTap: () async {
//                                addToCart(context,
//                                    productDesc: widget.description,
//                                    name: widget.name,
//                                    imgUrl: widget.detailsurls[0],
//                                    price: (widget.disprice).toString(),
//                                    qty: qty2);
//                              },
//                              child: Container(
//                                // width: MediaQuery.of(context).size.width *
//                                //     0.5,
//                                  height: 50,
//                                  decoration: BoxDecoration(
//                                      color: primarycolor,
//                                      borderRadius: BorderRadius.all(
//                                          Radius.circular(25))),
//                                  child: Center(
//                                      child: Padding(
//                                        padding: const EdgeInsets.symmetric(
//                                            horizontal: 10),
//                                        child: Text('Add to Cart',
//                                            style: TextStyle(
//                                                color: Colors.white,
//                                                fontSize: height * 0.025,
//                                                fontWeight: FontWeight.w500)),
//                                      ))))
//                              : Container(
//                            // width:
//                            //     MediaQuery.of(context).size.width * 0.5,
//                              height: 50,
//                              decoration: BoxDecoration(
//                                  color: secondarycolor,
//                                  borderRadius: BorderRadius.all(
//                                      Radius.circular(30))),
//                              child: Center(
//                                  child: Padding(
//                                    padding: const EdgeInsets.symmetric(
//                                        horizontal: 10.0),
//                                    child: Text('Already added in cart',
//                                        style: TextStyle(
//                                            color: Colors.black,
//                                            fontSize: height * 0.022,
//                                            fontWeight: FontWeight.w500)),
//                                  ))),
//                          InkWell(
//                            onTap: () async {
//                              for (var v in cartItems) {
//                                removeItem(v.productName);
//                              }
//                              print(cartItems);
//                              await addToCart(context,
//                                  productDesc: widget.description,
//                                  name: widget.name,
//                                  imgUrl: widget.detailsurls[0],
//                                  price: (widget.disprice).toString(),
//                                  qty: 1);
//                              setState(() {});
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => BookmarksScreen()));
//                            },
                             InkWell(
                               onTap:()async{
                                procheck();
                               },
                               child: Container(
                                // width:
                                //     MediaQuery.of(context).size.width * 0.5,
                                  height: 50,
                                  width:MediaQuery.of(context).size.width*0.8,
                                  decoration: BoxDecoration(
                                      color: primarycolor,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text('Buy Now',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: height * 0.022,
                                                fontWeight: FontWeight.w500)),
                                      ))),
                             ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
