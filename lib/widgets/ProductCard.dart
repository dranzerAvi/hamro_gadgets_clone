import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/products.dart';
import 'package:hamro_gadgets/product_details_screen.dart';
import 'package:hamro_gadgets/services/database_helper.dart';

class ProductCard extends StatefulWidget {
  String imageUrl;
  String name;
  int mp;
  int disprice;
  String description;
  List<Details>details=[];
  List<String>detailsurls=[];
  String rating;
  List<Specs>specs=[];
  ProductCard(this.imageUrl,this.name,this.mp,this.disprice,this.description,this.details,this.detailsurls,this.rating,this.specs);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final dbHelper = DatabaseHelper.instance;
  Cart item;
  var length;
  var qty = 1;
  int choice = 0;
  List<Cart> cartItems = [];
  static List<bool> check = [false, false, false, false, false];
  void updateItem(
      {int id,
        String name,
        String imgUrl,
        String price,
        int qty,
        String qtyTag,
        String details}) async {
    // row to update
    Cart item = Cart(id, name, imgUrl, price, qty);
    final rowsAffected = await dbHelper.update(item);
    Fluttertoast.showToast(msg: 'Updated', toastLength: Toast.LENGTH_SHORT);
    getAllItems();
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

  void getAllItems() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    await allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    setState(() {
      for (var v in cartItems) {
        if (v.productName == widget.name
        ) {
          qty = v.qty;
        }
      }
//      print(cartItems[1]);
    });
  }

  String orderid;

  void addToCart(
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
    Fluttertoast.showToast(
        msg: 'Added to cart', toastLength: Toast.LENGTH_SHORT);
    setState(() {
      check[choice] = true;
    });
    await getAllItems();
    getCartLength();
  }

  getCartLength() async {
    int x = await dbHelper.queryRowCount();
    length = x;
    setState(() {
      print('Length Updated');
      length;
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
  Future<int> getQuantity(String name) async {
    var temp = await _query(name);
    if (temp != null) {
      if (temp.productName == name) {
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
  first() async {
    qty = await getQuantity(widget.name);
  }
  @override
  void initState() {
    choice=0;
    first();
    print('-------------');
    print(widget.detailsurls.length);
    checkInCart();
    getAllItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder:(context)=>  ProductDetailsScreen(widget.imageUrl,widget.name,widget.mp,widget.disprice,widget.description,widget.details,widget.detailsurls,widget.rating,widget.specs)));

      },
      child: Container(
        height:height*0.2,
        width:width*0.8,

        child: Card(
          child: Row(
            children: [
              Stack(
                children: [
                  Positioned(
                      child:ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child:FancyShimmerImage(
                            shimmerDuration: Duration(seconds:2),
                            imageUrl:widget.imageUrl,
                            height:height*0.27,
                            width: width*0.3,
                            boxFit: BoxFit.fill,
                          )
                      )
                  ),
                  Positioned(
                    right:2,
                    top:2,
                    child:Container(color:Colors.red,child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('${((int.parse(widget.mp.toString()) - int.parse(widget.disprice.toString())) / int.parse(widget.mp.toString()) * 100).toStringAsFixed(0)} % off',style: TextStyle(color:Colors.white),),
                    )),

                  )
                ],
              ),
              Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child:SingleChildScrollView(
                    child: Column(
mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top:8.0),
                          child: Container(width:width*0.4,child: Text(widget.name,textAlign: TextAlign.left,style:TextStyle(fontSize: height*0.020,fontWeight: FontWeight.bold))),
                        ),
                        SizedBox(height:height*0.02),
                        SizedBox(width:width*0.4,child: Text('${widget.details[0].display}',style:TextStyle(color:Colors.black.withOpacity(0.8),fontSize:height*0.017))),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Text('Rs.${(widget.disprice).toString()}',style:TextStyle(fontSize:height*0.02,fontWeight: FontWeight.w500)),
                            SizedBox(width:width*0.02),
                            Text('Rs.${(widget.mp).toString()}',style:TextStyle(fontSize:height*0.02,decoration: TextDecoration.lineThrough,fontWeight: FontWeight.w500))
                          ],
                        ),
                            SizedBox(height:height*0.01),







                        SizedBox(height:height*0.01),
                        qty==0||qty==null?InkWell(
                          onTap: (){
                            addToCart(
                              name:widget.name,
                              imgUrl: widget.imageUrl,
                              price:widget.disprice.toString(),
                              qty:1
                            );
                          },
                          child:Container(height:height*0.04,width:width*0.2,child:Padding(
                            padding:  EdgeInsets.only(top:5.0),
                            child: Text('Add',textAlign: TextAlign.center,style:TextStyle(color:Colors.white,fontSize: height*0.02,fontWeight: FontWeight.bold)),
                          ),decoration: BoxDecoration(color: primarycolor,borderRadius: BorderRadius.all(Radius.circular(5.0))),)
                        ):Container(decoration:BoxDecoration(
    borderRadius:BorderRadius.all(Radius.circular(5)),color:primarycolor,),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: ()async{
                                await getAllItems();
                                for(var v in cartItems){
                                  if (v.productName == widget.name) {
                                    var newQty = v.qty + 1;
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
                                Icons.add,
                                color:Colors.white,
                              )
                            ),
                            Text(qty.toString(),style:TextStyle(color:Colors.white)),
                            InkWell(
                              onTap: () async {
                                await getAllItems();

                                for (var v in cartItems) {
                                  if (v.productName == widget.name) {
                                    if (v.qty == 1) {
                                      removeItem(v.productName);
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
                                Icons.remove,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                          height:height*0.03,
                          width:width*0.3,
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
