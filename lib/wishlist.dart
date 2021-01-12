import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        title:Text('Hamro Gadgets'),
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
              // height: 250,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              wishlistItems[index].imgUrl,
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.4,
                                      child: Text(
                                        '${wishlistItems[index].productName}',
                                        textAlign: TextAlign.left,
                                        style:
                                        TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: height*0.02,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16.0,
                      right: 16.0,
                      top: 8.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                'Rs. ${wishlistItems[index].price}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: height*0.02,
                                ),
                              ),
                            ),
                          )
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
