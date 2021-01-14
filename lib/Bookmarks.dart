import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/checkout.dart';
import 'package:hamro_gadgets/services/database_helper.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Cart> cartItems = [];
  double total;
  final dbHelper = DatabaseHelper.instance;
//  final dbRef = FirebaseDatabase.instance.reference();
//  FirebaseAuth mAuth = FirebaseAuth.instance;
  int newQty;
  void getAllItems() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    setState(() {
//      print(cartItems[1]);
    });
  }

  @override
  void initState() {
    getAllItems();
    super.initState();
  }

  void updateItem(
      {int id,
      String name,
      String imgUrl,
      String price,
      String productDesc,
      int qty,
      String details}) async {
    // row to update
    Cart item = Cart(id, name, imgUrl, price, qty, productDesc);
    final rowsAffected = await dbHelper.update(item);
    Fluttertoast.showToast(msg: 'Updated', toastLength: Toast.LENGTH_SHORT);
    getAllItems();
  }

  void removeItem(String name) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(name);
    getAllItems();
    Fluttertoast.showToast(
        msg: 'Removed from cart', toastLength: Toast.LENGTH_SHORT);
  }

  double totalAmount() {
    double sum = 0;
    getAllItems();
    for (int i = 0; i < cartItems.length; i++) {
      sum += (double.parse(cartItems[i].price) * cartItems[i].qty);
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios,
                color: Colors.black.withOpacity(0.8))),
        elevation: 0.0,
        centerTitle: true,
        title: Text('Shopping Cart',
            style: TextStyle(color: Colors.black.withOpacity(0.8))),
        actions: [
          Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  margin: EdgeInsets.only(top: 8.0, right: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Checkout()));
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                              color: primarycolor, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: cartItems.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 8.0,
                  );
                },
                itemBuilder: (context, index) {
                  return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: FancyShimmerImage(
                                    imageUrl: cartItems[index].imgUrl,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 100,
                                    boxFit: BoxFit.fill,
                                    shimmerDuration: Duration(seconds: 2),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    '${cartItems[index].productName}\n${cartItems[index].productDesc}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        // fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              newQty = cartItems[index].qty + 1;
                                              updateItem(
                                                  id: cartItems[index].id,
                                                  name: cartItems[index]
                                                      .productName,
                                                  imgUrl:
                                                      cartItems[index].imgUrl,
                                                  price: cartItems[index].price,
                                                  qty: newQty,
                                                  productDesc: cartItems[index]
                                                      .productDesc);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
//                                                  color: Colors.yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black)),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.black,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 8),
                                              child: Text(
                                                cartItems[index].qty.toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (cartItems[index].qty == 1) {
                                                removeItem(
                                                  cartItems[index].productName,
                                                );
                                              } else {
                                                var newQty =
                                                    cartItems[index].qty - 1;
                                                updateItem(
                                                  id: cartItems[index].id,
                                                  name: cartItems[index]
                                                      .productName,
                                                  productDesc: cartItems[index]
                                                      .productDesc,
                                                  imgUrl:
                                                      cartItems[index].imgUrl,
                                                  price: cartItems[index].price,
                                                  qty: newQty,
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
//                                                  color: Colors.yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black)),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.black,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          removeItem(
                                            cartItems[index].productName,
                                          );
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black.withOpacity(0.7),
                                          size: 28,
                                        ))
                                  ],
                                ))
                          ])));
                }),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            decoration:
                BoxDecoration(color: Colors.lightBlueAccent.withOpacity(0.1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total Amount- '),
                Text('Rs. ${totalAmount()}(+taxes)'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
