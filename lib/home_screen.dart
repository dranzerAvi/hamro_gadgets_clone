import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:hamro_gadgets/Bookmarks.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/products.dart';
import 'package:hamro_gadgets/search_screen.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:hamro_gadgets/widgets/ProductCard.dart';
import 'package:hamro_gadgets/widgets/nav_drawer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  static const int TAB_NO = 0;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
//    addDishParams();
    get();
    super.initState();
  }

  final dbHelper = DatabaseHelper.instance;
  User user;
  void get() {
    user = FirebaseAuth.instance.currentUser;
  }

  int total = 0;
  List<Cart> cartItems = [];
  void getAllItems() async {
    final allRows = await dbHelper.queryAllRows();
    cartItems.clear();
    allRows.forEach((row) => cartItems.add(Cart.fromMap(row)));
    setState(() {
      total = cartItems.length;
    });
  }

  addDishParams() {
    FirebaseFirestore.instance.collection('Products').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('Products')
            .doc(element.id)
            .update({
          'nameSearch': setSearchParam(element['name']),
          'categorySearch': setSearchParam(element['Category']),
          'subcategorysearch': setSearchParam(element['SubCategories'])
        });
      });
    });
  }

  setSearchParam(String caseString) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseString.length; i++) {
      temp = temp + caseString[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  static const int TAB_NO = 1;
  List<String> imageList = [];
  List<Products> newproducts = [];
  List<String> banners = [];
  TextEditingController _cont = TextEditingController();
  PersistentTabController _controller = PersistentTabController();
  @override
  Widget build(BuildContext context) {
    getAllItems();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
//      floatingActionButton: CustomFloatingButton(CurrentScreen(
//          currentScreen: HomeScreen(), tab_no: HomeScreen.TAB_NO)),
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
          child: Container(
            width: width * 0.7,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookmarksScreen()));
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
                                    MediaQuery.of(context).size.height * 0.04,
                                left:
                                    MediaQuery.of(context).size.height * 0.013,
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
              )),
        ],
//       actions: [
//
//         Center(child: Container(width:width*0.5,child: TextFormField(controller:_cont,decoration: InputDecoration(filled: true,fillColor: Colors.white,prefixIcon: Icon(Icons.search,color:Colors.grey),hintText: 'Search here',hintStyle: TextStyle(color:Colors.grey)),)))
//       ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('FullLengthBanner')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    imageList.clear();
                    for (int i = 0; i < snap.data.docs.length; i++) {
                      imageList.add(snap.data.docs[i]['imageURL']);
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 280,
                          width: MediaQuery.of(context).size.width,
                          child: GFCarousel(
                            items: imageList.map(
                              (url) {
                                return Container(
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
                            activeIndicator: Colors.white,
                            pauseAutoPlayOnTouch: Duration(seconds: 8),
                            pagerSize: 8,
                          )),
                    );
                  } else {
                    return Container();
                  }
                }),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Trending',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: height * 0.025,
                          fontWeight: FontWeight.bold)),
                ),

                //      InkWell(

                //        onTap: (){

                //

                //        },

                //      )
              ],
            ),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('newProduct', isEqualTo: true)
                    .where('status', isEqualTo: 'active')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    newproducts.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          snap.data.docs[i]['Category'],
                          snap.data.docs[i]['SubCategories'],
                          List.from(snap.data.docs[i]['colors']),
                          snap.data.docs[i]['description'],
                          snap.data.docs[i]['details'],
                          List.from(snap.data.docs[i]['detailsGraphicURLs']),
                          snap.data.docs[i]['disPrice'],
                          snap.data.docs[i]['docID'],
                          List.from(snap.data.docs[i]['imageURLs']),
                          snap.data.docs[i]['mp'],
                          snap.data.docs[i]['name'],
                          snap.data.docs[i]['noOfPurchases'],
                          snap.data.docs[i]['quantity'],
                          snap.data.docs[i]['rating'].toString(),
                          snap.data.docs[i]['specs'],
                          snap.data.docs[i]['status']);

                      newproducts.add(pro);
                    }

                    return (newproducts.length!=0)?Container(
                      height: height * 0.41,
                      child: ListView.builder(
                          itemCount: newproducts.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = newproducts[index];

                            return Container(
                              height: height * 0.4,
                              width: width * 0.5,
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.005),
                                child: ProductCard(
                                    item.imageurls[0],
                                    item.name,
                                    item.mp,
                                    item.disprice,
                                    item.description,
                                    item.details,
                                    item.imageurls,
                                    item.rating,
                                    item.specs,
                                    item.quantity),
                              ),
                            );
                          }),
                    ):Center(
                      child: Container(
                        height:100,
                        width:100,
                        child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        height:100,
                        width:100,
                        child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  }
                }),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Laptops',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: height * 0.025,
                          fontWeight: FontWeight.bold)),
                ),

                //      InkWell(

                //        onTap: (){

                //

                //        },

                //      )
              ],
            ),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('newProduct', isEqualTo: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    newproducts.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          snap.data.docs[i]['Category'],
                          snap.data.docs[i]['SubCategories'],
                          List.from(snap.data.docs[i]['colors']),
                          snap.data.docs[i]['description'],
                          snap.data.docs[i]['details'],
                          List.from(snap.data.docs[i]['detailsGraphicURLs']),
                          snap.data.docs[i]['disPrice'],
                          snap.data.docs[i]['docID'],
                          List.from(snap.data.docs[i]['imageURLs']),
                          snap.data.docs[i]['mp'],
                          snap.data.docs[i]['name'],
                          snap.data.docs[i]['noOfPurchases'],
                          snap.data.docs[i]['quantity'],
                          snap.data.docs[i]['rating'].toString(),
                          snap.data.docs[i]['specs'],
                          snap.data.docs[i]['status']);

                      newproducts.add(pro);
                    }

                    return (newproducts.length!=0)?Container(
                      height: height * 0.41,
                      child: ListView.builder(
                          itemCount: newproducts.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = newproducts[index];

                            return Container(
                              height: height * 0.4,
                              width: width * 0.5,
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.005),
                                child: ProductCard(
                                    item.imageurls[0],
                                    item.name,
                                    item.mp,
                                    item.disprice,
                                    item.description,
                                    item.details,
                                    item.imageurls,
                                    item.rating,
                                    item.specs,
                                    item.quantity),
                              ),
                            );
                          }),
                    ):Center(
                      child: Container(
                        height:100,
                        width:100,
                        child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                          height:100,
                          width:100,
                          child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  }
                }),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('AdBanner')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    banners.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      banners.add(snap.data.docs[i]['imageURL']);
                    }

                    return(banners.length!=0)? Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                          banners[0],
                          height: height * 0.2,
                          width: width * 0.48,
                          fit: BoxFit.fill,
                        ),
                        Image.network(
                          banners[1],
                          height: height * 0.2,
                          width: width * 0.48,
                          fit: BoxFit.fill,
                        ),
                      ],
                    )):Center(
                      child: Container(
                          height:100,
                          width:100,
                          child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                          height:100,
                          width:100,
                          child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  }
                }),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Headphones',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: height * 0.025,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('newProduct', isEqualTo: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    newproducts.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          snap.data.docs[i]['Category'],
                          snap.data.docs[i]['SubCategories'],
                          List.from(snap.data.docs[i]['colors']),
                          snap.data.docs[i]['description'],
                          snap.data.docs[i]['details'],
                          List.from(snap.data.docs[i]['detailsGraphicURLs']),
                          snap.data.docs[i]['disPrice'],
                          snap.data.docs[i]['docID'],
                          List.from(snap.data.docs[i]['imageURLs']),
                          snap.data.docs[i]['mp'],
                          snap.data.docs[i]['name'],
                          snap.data.docs[i]['noOfPurchases'],
                          snap.data.docs[i]['quantity'],
                          snap.data.docs[i]['rating'].toString(),
                          snap.data.docs[i]['specs'],
                          snap.data.docs[i]['status']);

                      newproducts.add(pro);
                    }

                    return (newproducts.length!=0)?Container(
                      height: height * 0.41,
                      child: ListView.builder(
                          itemCount: newproducts.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = newproducts[index];
                            return Container(
                              height: height * 0.4,
                              width: width * 0.5,
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.005),
                                child: ProductCard(
                                    item.imageurls[0],
                                    item.name,
                                    item.mp,
                                    item.disprice,
                                    item.description,
                                    item.details,
                                    item.imageurls,
                                    item.rating,
                                    item.specs,
                                    item.quantity),
                              ),
                            );
                          }),
                    ):Center(
                      child: Container(
                          height:100,
                          width:100,
                          child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                          height:100,
                          width:100,
                          child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  }
                }),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Speakers',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: height * 0.025,
                          fontWeight: FontWeight.bold)),
                ),
//      InkWell(
//        onTap: (){
//
//        },
//      )
              ],
            ),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('newProduct', isEqualTo: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    newproducts.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          snap.data.docs[i]['Category'],
                          snap.data.docs[i]['SubCategories'],
                          List.from(snap.data.docs[i]['colors']),
                          snap.data.docs[i]['description'],
                          snap.data.docs[i]['details'],
                          List.from(snap.data.docs[i]['detailsGraphicURLs']),
                          snap.data.docs[i]['disPrice'],
                          snap.data.docs[i]['docID'],
                          List.from(snap.data.docs[i]['imageURLs']),
                          snap.data.docs[i]['mp'],
                          snap.data.docs[i]['name'],
                          snap.data.docs[i]['noOfPurchases'],
                          snap.data.docs[i]['quantity'],
                          snap.data.docs[i]['rating'].toString(),
                          snap.data.docs[i]['specs'],
                          snap.data.docs[i]['status']);

                      newproducts.add(pro);
                    }

                    return(newproducts.length!=0)? Container(
                      height: height * 0.41,
                      child: ListView.builder(
                          itemCount: newproducts.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = newproducts[index];
                            return Container(
                              height: height * 0.4,
                              width: width * 0.5,
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.005),
                                child: ProductCard(
                                    item.imageurls[0],
                                    item.name,
                                    item.mp,
                                    item.disprice,
                                    item.description,
                                    item.details,
                                    item.imageurls,
                                    item.rating,
                                    item.specs,
                                    item.quantity),
                              ),
                            );
                          }),
                    ):Center(
                      child: Container(
                          height:100,
                          width:100,
                          child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                          height:100,
                          width:100,
                          child:SpinKitWave(color:primarycolor,size:height*0.023)
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
