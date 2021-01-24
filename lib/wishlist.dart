import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/wishlist.dart';
import 'package:hamro_gadgets/services/database_helper_wishlist.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Wishlist> wishlistItems = [];
  double total;
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
    getAllItems();
    super.initState();
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
          itemCount:wishlistItems.length,
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
                              imageUrl: wishlistItems[index].imgUrl ,
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
                                          wishlistItems[index].productName,
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
                                              'Price: Rs ${wishlistItems[index].price.toString()}',
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
