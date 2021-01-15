import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/checkout.dart';
import 'package:hamro_gadgets/services/database_helper.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  TextEditingController _cont=TextEditingController();
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
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
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

            ],
          )
        ],
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height:height*0.4,
                width:width*0.9,
                decoration:BoxDecoration(color:secondarycolor,borderRadius: BorderRadius.all(Radius.circular(7.0))),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Summary',textAlign:TextAlign.left,style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,top:12.0,bottom: 12.0,right:12.0),
                      child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color:Colors.grey,width: 1)),child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: TextFormField(controller:_cont,decoration: InputDecoration(border: InputBorder.none,hintText: 'Apply Coupon Code'),),
                      )),
                    ),
                    Divider(color:Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                        Text('Subtotal',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02)),
                        Text('Rs.${totalAmount().toString()}',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Shipping',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02)),
                          Text('Rs.20',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02)),
                        ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Tax @10%',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02)),
                          Text('Rs.${(totalAmount()*0.1).toString()}',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02))
                        ]
                      ),
                    ),
                    Divider(color:Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                        Text('Order Total',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02)),
                        Text('${totalAmount()+(totalAmount()*0.1+20)}',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02))
                      ]),
                    )
                  ]
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap:(){
                    Navigator.push(context,MaterialPageRoute(builder:(context)=>Checkout()));
                  },
                  child:Container(
                      height:height*0.06,
                      width:width*0.8,
                      decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.all(Radius.circular(20))),
                      child:Padding(
                        padding: const EdgeInsets.only(top:12.0),
                        child: Text('Proceed to Checkout',textAlign:TextAlign.center,style:GoogleFonts.poppins(color:Colors.white,fontWeight: FontWeight.w500,fontSize: height*0.022)),
                      )
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Align(alignment:Alignment.topLeft,child: Text('Items',style:GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.bold,fontSize: height*0.022))),
            ),
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
                        height:MediaQuery.of(context).size.height*0.35,
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
                                      '${cartItems[index].productName}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          // fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
Padding(
  padding: const EdgeInsets.only(right:20.0,left:20.0,bottom:10.0,top:10),
  child:   Row(

    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children:[

        Text('Price',style:GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.w500,fontSize:height*0.02)),

        Text('Qty',textAlign:TextAlign.center,style:GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.w500,fontSize:height*0.02)),

        Text('Subtotal',style:GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.w500,fontSize:height*0.02)),



    ]

  ),
),
Padding(
  padding: const EdgeInsets.only(right:20.0,left:20.0,bottom:10.0,top:10),
  child:   Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children:[
        Text('Rs.${cartItems[index].price}',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02)),
        Container(
            height: height * 0.075,
            width: width * 0.16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5)),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0),
                  child: Text(cartItems[index].qty.toString(),
                      style: TextStyle(
                          color: Colors.black)),
                ),
                Column(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        await getAllItems();
                        for (var v in cartItems) {
                          if (v.productName ==
                              cartItems[index].productName) {
                            var newQty = v.qty + 1;
                            updateItem(
                              productDesc:
                              v.productDesc,
                              id: v.id,
                              name: v.productName,
                              imgUrl: v.imgUrl,
                              price: v.price,
                              qty: newQty,
                            );
                          }
                        }
                      },
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await getAllItems();

                        for (var v in cartItems) {
                          if (v.productName ==
                              cartItems[index].productName) {
                            if (v.qty == 1) {
                              removeItem(
                                  v.productName);
                            } else {
                              var newQty = v.qty - 1;
                              updateItem(
                                id: v.id,
                                productDesc:
                                v.productDesc,
                                name: v.productName,
                                imgUrl: v.imgUrl,
                                price: v.price,
                                qty: newQty,
                              );
                            }
                          }
                        }
                      },
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            )),
        Text('${totalAmount().toString()}',style:GoogleFonts.poppins(color:Colors.black,fontWeight:FontWeight.bold,fontSize:height*0.02))
    ]
  ),
),
Padding(
  padding: const EdgeInsets.only(right:10),
  child:   Align(
    alignment:Alignment.bottomRight,
    child:   InkWell(onTap:(){

        removeItem(cartItems[index].productName);

    },

        child:Icon(Icons.delete,color:Colors.grey,size:height*0.03)



    ),
  ),
),
//                            Container(
//                                margin: EdgeInsets.symmetric(
//                                    horizontal: 16, vertical: 16),
//                                child: Row(
//                                  children: [
//                                    Align(
//                                      alignment: Alignment.center,
//                                      child: Row(
//                                        children: [
//                                          InkWell(
//                                            onTap: () {
//                                              newQty = cartItems[index].qty + 1;
//                                              updateItem(
//                                                  id: cartItems[index].id,
//                                                  name: cartItems[index]
//                                                      .productName,
//                                                  imgUrl:
//                                                      cartItems[index].imgUrl,
//                                                  price: cartItems[index].price,
//                                                  qty: newQty,
//                                                  productDesc: cartItems[index]
//                                                      .productDesc);
//                                            },
//                                            child: Container(
//                                              decoration: BoxDecoration(
////                                                  color: Colors.yellow,
//                                                  borderRadius:
//                                                      BorderRadius.circular(6),
//                                                  border: Border.all(
//                                                      width: 1,
//                                                      color: Colors.black)),
//                                              child: Icon(
//                                                Icons.add,
//                                                color: Colors.black,
//                                                size: 25,
//                                              ),
//                                            ),
//                                          ),
//                                          SizedBox(
//                                            width: 5,
//                                          ),
//                                          Container(
//                                            decoration: BoxDecoration(
//                                                borderRadius:
//                                                    BorderRadius.circular(6),
//                                                border: Border.all(
//                                                    color: Colors.black,
//                                                    width: 1)),
//                                            child: Padding(
//                                              padding:
//                                                  const EdgeInsets.symmetric(
//                                                      vertical: 5,
//                                                      horizontal: 8),
//                                              child: Text(
//                                                cartItems[index].qty.toString(),
//                                                textAlign: TextAlign.left,
//                                                style: TextStyle(
//                                                  color: Colors.black,
//                                                  fontSize: 14,
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                          SizedBox(
//                                            width: 5,
//                                          ),
//                                          InkWell(
//                                            onTap: () {
//                                              if (cartItems[index].qty == 1) {
//                                                removeItem(
//                                                  cartItems[index].productName,
//                                                );
//                                              } else {
//                                                var newQty =
//                                                    cartItems[index].qty - 1;
//                                                updateItem(
//                                                  id: cartItems[index].id,
//                                                  name: cartItems[index]
//                                                      .productName,
//                                                  productDesc: cartItems[index]
//                                                      .productDesc,
//                                                  imgUrl:
//                                                      cartItems[index].imgUrl,
//                                                  price: cartItems[index].price,
//                                                  qty: newQty,
//                                                );
//                                              }
//                                            },
//                                            child: Container(
//                                              decoration: BoxDecoration(
////                                                  color: Colors.yellow,
//                                                  borderRadius:
//                                                      BorderRadius.circular(6),
//                                                  border: Border.all(
//                                                      width: 1,
//                                                      color: Colors.black)),
//                                              child: Icon(
//                                                Icons.remove,
//                                                color: Colors.black,
//                                                size: 25,
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                    InkWell(
//                                        onTap: () {
//                                          removeItem(
//                                            cartItems[index].productName,
//                                          );
//                                        },
//                                        child: Icon(
//                                          Icons.delete,
//                                          color: Colors.black.withOpacity(0.7),
//                                          size: 28,
//                                        ))
//                                  ],
//                                ))
                            ])));
                  }),
            ),


            ],),
      )


    );
  }
}
