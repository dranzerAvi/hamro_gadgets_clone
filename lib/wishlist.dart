import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Bookmarks.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/wishlist.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:hamro_gadgets/services/database_helper_wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Wishlist> wishlistItems = [];
  double total;
  int total2;
  final dbHelperWishlist = DatabaseHelper2.instance;
//  final dbRef = FirebaseDatabase.instance.reference();
  FirebaseAuth mAuth = FirebaseAuth.instance;
  int newQty;
  void getAllItems() async {
    final allRows = await dbHelperWishlist.queryAllRows();
    wishlistItems.clear();

    setState(() {
      allRows.forEach((row) => wishlistItems.add(Wishlist.fromMap(row)));
//      print(cartItems[1]);
    });
    checking();
  }
  List<Cart> cartItems = [];
  void getAllItems2() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    await allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    setState(() {
      total2 = cartItems.length;

      for (var v in cartItems) {
        print('######${v.productName}');
//        if (v.productName == widget.name) {
//          qty = v.qty;
//        }
      }
//      print(cartItems[1]);
    });
  }
  void removeItem(String name) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelperWishlist.delete(name);
    getAllItems();
    Fluttertoast.showToast(
        msg: 'Removed from Wishlist', toastLength: Toast.LENGTH_SHORT);
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
    getAllItems2();
//    checking();
    super.initState();
  }
  final dbHelper = DatabaseHelper.instance;
  static List<bool> check = [false, false, false, false, false];

  Cart item;
  bool isWishlist = false;


  var length;
  var lengthWishlist;
  var qty = 1;
  bool present = false;
  int choice = 0;
  int order;
  String orderid;
  String desc='reorder';

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
   removeItem(name);
    Fluttertoast.showToast(
        msg: 'Added to cart', toastLength: Toast.LENGTH_SHORT);
    Navigator.push(context,MaterialPageRoute(builder:(context)=>BookmarksScreen()));

    setState(() {
      check[choice] = true;
    });

  }
  List<Wishlist2>allitems=[];
  void checking(){
    FirebaseFirestore.instance.collection('Products').snapshots().forEach((element) {
      for(int i=0;i<element.docs.length;i++){
        for(int j=0;j<wishlistItems.length;j++){
          if(wishlistItems[j].productName==element.docs[i]['name']){
            Wishlist2 we=Wishlist2(wishlistItems[j].productName,wishlistItems[j].imgUrl,wishlistItems[j].price,element.docs[i]['quantity']);
            allitems.add(we);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: primarycolor,
        title:Text('My Wishlist',style:GoogleFonts.poppins(color:Colors.white,fontWeight:FontWeight.bold)),
        centerTitle:true,
      ),
      body:Column(
        children: [
          Container(
            margin:EdgeInsets.only(left:16,right:16,top:16),
              height:height*0.75,
        child:ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount:allitems.length,
          separatorBuilder: (context, index) {
            return SizedBox(height:8);
          },
          itemBuilder: (context,index){
            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height:MediaQuery.of(context).size.height*0.18,
              // height: 250,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top:12.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height:100,
                            width:100,
                            child:FancyShimmerImage(
                              imageUrl: allitems[index].imgurl ,
                            )
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 100,
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
                                          allitems[index].name,
                                          style: TextStyle(fontSize: height*0.02),
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
                                              'Price: Rs ${allitems[index].price.toString()}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            Spacer()
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          (allitems[index].quantity>0)?InkWell(
                                            onTap:(){

                                              addToCart(context,name:wishlistItems[index].productName,imgUrl:wishlistItems[index].imgUrl,price:wishlistItems[index].price,qty:1,productDesc: 'Wishlist');
                                            },
                                            child: Container(
                                              height: 23,
                                              width:width*0.3,
                                              decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.all(Radius.circular(3))),
                                              child:Center(child: Text('Add to Cart',style:GoogleFonts.poppins(color:Colors.white)))
                                            ),
                                          ): Container(
                                          height: 23,
                                          width:width*0.3,
                                          decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.all(Radius.circular(3))),
                                          child:Center(child: Text('Out of Stock',style:GoogleFonts.poppins(color:Colors.white)))
                                      ),
                                          InkWell(
                                              onTap: () {
                                                removeItem(
                                                  wishlistItems[index].productName,
                                                );
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color:
                                                Colors.black.withOpacity(0.7),
                                                size: 28,
                                              ))
                                        ],
                                      )
                                    ],

                                  ),
                                ),
//                              Align(
//                                alignment: Alignment.center,
//                                child: Row(
//                                  mainAxisAlignment:
//                                  MainAxisAlignment.center,
//                                  children: [
//                                    SizedBox(
//                                      width: 5,
//                                    ),
//                                    SizedBox(
//                                      width: 5,
//                                    ),
//                                  ],
//                                ),
//                              ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        )
          ),


        ],
      )
    );
  }
}
