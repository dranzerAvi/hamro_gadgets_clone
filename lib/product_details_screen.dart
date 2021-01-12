import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:hamro_gadgets/Bookmarks.dart';

import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/products.dart';
import 'package:hamro_gadgets/Constants/wishlist.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:hamro_gadgets/services/database_helper_wishlist.dart';
import 'package:hamro_gadgets/wishlist.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProductDetailsScreen extends StatefulWidget {
  String imageUrl;
  String name;
  int mp;
  int disprice;
  String description;
  List<Details>details=[];
  List<String>detailsurls=[];
  String rating;
  List<Specs>specs=[];
  ProductDetailsScreen(this. imageUrl,this.name,this.mp,this.disprice,this.description,this.details,this.detailsurls,this.rating,this.specs);
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final dbHelper = DatabaseHelper.instance;
  static List<bool> check = [false, false, false, false, false];
  final dbHelperWishlist = DatabaseHelper2.instance;
  Cart item;
  int total=0;
  Wishlist itemWishlist;
  var length;
  var lengthWishlist;
  var qty = 1;
  bool present = false;
  int choice = 0;
  List<Cart> cartItems = [];
  List<Wishlist> wishlistItems = [];
  void updateItem(
      {int id,
        String name,
        String imgUrl,
        String price,
        int qty,

        String details}) async {
    // row to update
    Cart item = Cart(id, name, imgUrl, price, qty);
    final rowsAffected = await dbHelper.update(item);
    Fluttertoast.showToast(msg: 'Updated', toastLength: Toast.LENGTH_SHORT);
    getAllItems();
  }
  void updateItemWishlist(
      {int id,
        String name,
        String imgUrl,
        String price,
        String qtyTag,
        String details}) async {
    // row to update
    Wishlist item = Wishlist(id, name, imgUrl, price);
    final rowsAffected = await dbHelperWishlist.update(item);
    Fluttertoast.showToast(
        msg: 'Updated Wishlist', toastLength: Toast.LENGTH_SHORT);
    getAllItemsWishlist();
  }
  void removeItem(String name) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(name);
    getAllItems();
    setState(() {
      check[choice] = false;
      qty = 0;
    });
    Fluttertoast.showToast(
        msg: 'Removed from cart', toastLength: Toast.LENGTH_SHORT);
  }

  void removeItemWishlist(String name) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelperWishlist.delete(name);
    getAllItemsWishlist();
    setState(() {});
    Fluttertoast.showToast(
        msg: 'Removed from Wishlist', toastLength: Toast.LENGTH_SHORT);
  }

  void getAllItems() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    await allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    setState(() {
      total = cartItems.length;

      for (var v in cartItems) {
        print('######${v.productName}');
        if (v.productName == widget.name
            ) {
          qty = v.qty;
        }
      }
//      print(cartItems[1]);
    });
  }

  void getAllItemsWishlist() async {
    final allRows = await dbHelperWishlist.queryAllRows();
    wishlistItems.clear();
    await allRows.forEach((row) => wishlistItems.add(Wishlist.fromMap(row)));
    setState(() {
      totalWishlist = wishlistItems.length;

      for (var v in wishlistItems) {
        print('######${v.productName}');
        if (v.productName == widget.name) {
          present = true;
        }
      }
//      print(cartItems[1]);
    });
  }


  int totalWishlist;
  void addToWishlist(ctxt, {String name, String imgUrl, String price}) async {
    Map<String, dynamic> row = {
      DatabaseHelper2.columnProductName: name,
      DatabaseHelper2.columnImageUrl: imgUrl,
      DatabaseHelper2.columnPrice: price
    };
    Wishlist item = Wishlist.fromMap(row);
    final id = await dbHelperWishlist.insert(item);
    final snackBar = SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Added to Wishlist'),
              InkWell(
                onTap: () {
                  pushNewScreen(context,
                      screen: WishlistScreen(), withNavBar: true);
                },
                child: Text(
                  'View Wishlist',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ],
          ),
        ));
    setState(() {
      present = true;
    });
// Find the Scaffold in the widget tree and use it to show a SnackBar.
//    Scaffold.of(ctxt).showSnackBar(snackBar);
   Fluttertoast.showToast(
     msg: 'Added to Wishlist', toastLength: Toast.LENGTH_SHORT);

    await getAllItemsWishlist();
    getWishlistLength();
  }

  void addToCart(ctxt,
      {String name,
        String imgUrl,
        String price,
        int qty,
        String qtyTag}) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductName: name,
      DatabaseHelper.columnImageUrl: imgUrl,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnQuantity: qty,
    };


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
                  pushNewScreen(context,
                      screen: BookmarksScreen(), withNavBar: true);
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

    Fluttertoast.showToast(
        msg: 'Added to cart', toastLength: Toast.LENGTH_SHORT);
    setState(() {
      check[choice] = true;
    });
    await getAllItems();
    getCartLength();
  }
  getWishlistLength() async {
    int x = await dbHelperWishlist.queryRowCount();
    length = x;
    setState(() {
      print('Length Updated');
      length;
    });
  }

  getCartLength() async {
    int x = await dbHelper.queryRowCount();
    lengthWishlist = x;
    setState(() {
      print('Length Updated');
      lengthWishlist;
    });
  }

  Future<Cart> _query(String name) async {
    final allRows = await dbHelper.queryRows(name);
    print(allRows);

    allRows.forEach((row) => item = Cart.fromMap(row));
    setState(() {
      item;
//      print(item.qtyTag);
      print('-------------Updated');
    });
    return item;
  }

  Future<Wishlist> _queryWishlist(String name) async {
    final allRows = await dbHelperWishlist.queryRows(name);
    print(allRows);

    allRows.forEach((row) => itemWishlist = Wishlist.fromMap(row));
    setState(() {
      itemWishlist;
//      print(item.qtyTag);
      print('-------------Updated');
    });
    return itemWishlist;
  }
  Future<int> getQuantity(String name) async {
    var temp = await _query(name);
    if (temp != null) {
      if (temp.productName == name ) {
        print('item found');
        qty = temp.qty;
        return temp.qty;
      } else {
        return 0;
      }
    }
  }

  void checkInCart() async {
    var temp = await _query(widget.name);
    print(temp);
    if (temp != null) {
      if (temp.productName == widget.name ) {
        setState(() {
          print('Item already exists');
          check[choice] = true;
          qty = temp.qty;
        });
        return;
      } else
        setState(() {
          check[choice] = false;
        });
    }
  }

  Future<bool> checkInWishlist() async {
    print('called');
    var temp = await _queryWishlist(widget.name);
    print(temp);
    if (temp != null) {
      if (temp.productName == widget.name) {
        setState(() {
          print('Item already exists ${temp.productName}');
        });
        return true;
      } else {
        setState(() {});
        return false;
      }
    }
  }
  first() async {

    qty = await getQuantity(widget.name, );


    present = await checkInWishlist();
    print('-------------%%%%%$present');
  }
String urlUniv;
  String url2;
  var qty2=1;

  @override
  void initState() {
    setState(() {
     urlUniv=widget.detailsurls[0];
     url2=widget.detailsurls[1];
    });
    choice=0;
    first();
    checkInCart();
    getAllItems();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    var heightOfStack = MediaQuery.of(context).size.height / 2.8;
    var aPieceOfTheHeightOfStack = heightOfStack - heightOfStack / 3.5;
    return DefaultTabController(
      length:3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primarycolor,
          elevation:0.0,
          title:Text('Hamro Gadgets',style:TextStyle(color:Colors.white)),
          centerTitle: true,
          leading: InkWell(onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          actions:[
            InkWell(
              onTap: (){},
              child:Icon(Icons.share,color:Colors.white)
            ),
            SizedBox(width:8),
            InkWell(onTap:(){
              Navigator.push(context,MaterialPageRoute(builder:(context)=>BookmarksScreen()));
            },
              child:Padding(
                padding: const EdgeInsets.only(right:5.0),
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
                      bottom: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.height * 0.013,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
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
              )
            ),
            SizedBox(
              width: 14,
            )
          ]
        ),
        body:SafeArea(
          child:Container(
            child:Column(
              children:[
                Expanded(
                  child:ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0,8,8,2),
                        child: Text(widget.name,textAlign: TextAlign.left,style:TextStyle(color:Colors.black.withOpacity(0.8),fontSize:height*0.03,fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:16.0),
                        child: Stack(
                          children: [
//                            Positioned(
//                              child:FancyShimmerImage(
//                                shimmerDuration: Duration(seconds: 2),
//                                imageUrl: urlUniv,
//                                width: MediaQuery.of(context).size.width,
//                                height: heightOfStack,
//                                boxFit: BoxFit.fill,
//                              )
//                            ),
                            Row(

                              children: [

                                GFCarousel(



                                  items:widget.detailsurls.map((url){return Container(



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



                                  (MediaQuery.of(context).size.width / 25) /



                                      (MediaQuery.of(context).size.width /



                                          40),



                                  autoPlay: true,



                                  pagination: true,



                                  passiveIndicator: Colors.grey.withOpacity(0.4),



                                  activeIndicator: Colors.black.withOpacity(0.3),



                                  pauseAutoPlayOnTouch: Duration(seconds: 8),



                                  pagerSize: 8,



                                ),
                              ],
                            )

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:12.0),
                        child: Align(
                          alignment:Alignment.topLeft,
                          child: RatingBar.builder(
                            initialRating: double.parse(widget.rating),
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15,

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
                      TabBar(
                        labelColor: primarycolor,
                          indicatorColor: primarycolor,
                          tabs:[
                        Tab(child:Text('About product',style:TextStyle(color:Colors.black,fontSize:height*0.02,fontWeight: FontWeight.w500)),),
                        Tab(child: Text('Specs',style:TextStyle(color:Colors.black,fontSize:height*0.02,fontWeight: FontWeight.w500))),
                        Tab(child: Text('Other Details',style:TextStyle(color:Colors.black,fontSize:height*0.02,fontWeight: FontWeight.w500))),
                      ]),
                      Container(
                        height:height*0.4,
                        width:width*0.9,
                        child: TabBarView(

                          children: [
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child:Text(widget.description,style:TextStyle(color:Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500))
                            ),
                            Container(
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                                      child: Align(alignment:Alignment.topLeft,child: Text('Model:${widget.specs[0].model}',style:TextStyle(color:Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500))),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                                        child:Align(alignment:Alignment.topLeft,child: Text('CPU:${widget.specs[0].cpu}',style:TextStyle(color:Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500)))
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                                        child:Align(alignment:Alignment.topLeft,child: Text('RAM :${widget.specs[0].ram}',style:TextStyle(color:Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500)))
                                    ),
                                    Padding(
                                        padding:const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                                        child:Align(alignment:Alignment.topLeft,child: Text('Storage:${widget.specs[0].storage}',style:TextStyle(color:Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500)))
                                    ),

                                  ],
                                ),
                              )
                            ),
                            Container(
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                                        child:Align(alignment:Alignment.topLeft,child: Text('Display:${widget.details[0].display}',style:TextStyle(color:Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500)))
                                    ),
                                    Padding(
                                        padding:const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                                        child:Align(alignment:Alignment.topLeft,child: Text('Graphic:${widget.details[0].graphic}',style:TextStyle(color:Colors.black.withOpacity(0.8),fontWeight: FontWeight.w500)))
                                    ),

                                  ],
                                ),
                              )
                            )

                          ],
                        ),
                      ),


                    SizedBox(height:height*0.03),
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
                    ]

                        )
                      ),



           Row(
                  children: [
                  qty!=0?qty!=null? Padding(
                        padding: const EdgeInsets.only(top:10.0,left:40.0),
                        child: Container(height:height*0.07,width:width*0.16,decoration:BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(5)),
                          color:Colors.grey.withOpacity(0.3),

                        ),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left:2.0),
                                child: Text(qty.toString(),style:TextStyle(color:Colors.black)),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap:()async{
                                      await getAllItems();
                                      for(var v in cartItems){
                                        if(v.productName==widget.name){
                                          var newQty=v.qty+1;
                                          updateItem(
                                            id: v.id,
                                            name: v.productName,
                                            imgUrl: v.imgUrl,
                                            price: v.price,
                                            qty: newQty,
                                          );
                                        }
                                      }
                                    },
                                    child:Icon(
                                      Icons.keyboard_arrow_up,
                                      color:Colors.black,
                                    ),

                                  ),

                                  InkWell(
                                    onTap: () async {
                                      await getAllItems();

                                      for (var v in cartItems) {
                                        if (v.productName ==
                                            widget
                                                .name) {
                                          if (v.qty == 1) {
                                            removeItem(
                                                v.productName);
                                          } else {
                                            var newQty = v.qty - 1;
                                            updateItem(
                                              id: v.id,
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
                          )

                        ),   ):Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:10.0,left:40.0),
                        child: Container(height:height*0.07,width:width*0.16,decoration:BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(5)),
                          color:Colors.grey.withOpacity(0.3),

                        ),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:2.0),
                                  child: Text(qty2.toString(),style:TextStyle(color:Colors.black)),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap:()async{
                                        await getAllItems();
                                        setState(() {
                                          qty2=qty2+1
;                                        });
                                      },
                                      child:Icon(
                                        Icons.keyboard_arrow_up,
                                        color:Colors.black,
                                      ),

                                    ),

                                    InkWell(
                                      onTap: () async {
                                       setState(() {
                                         (qty2>1) ?qty2=qty2-1:qty2;
                                       });
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )

                        ),   )
                    ],
                  ):Container(),
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
SizedBox(width:width*0.18),qty==0||qty==null?InkWell(
                               onTap:()async{
      addToCart(context,
      name: widget.name,
      imgUrl: widget.detailsurls[0],
      price: (widget
          .disprice)
          .toString(),
      qty: qty2);

      },
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(width:MediaQuery.of(context).size.width*0.5,height:height*0.07,decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.all(Radius.circular(20))),child:Center(child: Text('Add to Cart',style:TextStyle(color:Colors.white,fontSize: height*0.025,fontWeight: FontWeight.w500)))),
      )
      ):Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(width:MediaQuery.of(context).size.width*0.5,height:height*0.07,decoration:BoxDecoration(color:primarycolor,borderRadius: BorderRadius.all(Radius.circular(20))),child:Center(child: Text('Already added in cart',style:TextStyle(color:Colors.white,fontSize: height*0.022,fontWeight: FontWeight.w500)))),
                    ),
                        ],
                      ),

                    Container(
                      height:height*0.04,
    color:Colors.lightBlueAccent.withOpacity(0.1),
                      width:width,
                      child:Center(child: Text(' Rs.${widget.disprice.toString()}',style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold)))
                    ),


                  ],

                ),
          ),
                  )
                )

            );




  }
}
