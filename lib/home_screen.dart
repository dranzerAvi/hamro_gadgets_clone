import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Bookmarks.dart';
import 'package:hamro_gadgets/Constants/banner.dart';

import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/products.dart';
import 'package:hamro_gadgets/Constants/rewardproducts.dart';
import 'package:hamro_gadgets/product_details_screen.dart';
import 'package:hamro_gadgets/reward_product_details_screen.dart';
import 'package:hamro_gadgets/search_screen.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:hamro_gadgets/widgets/ProductCard.dart';
import 'package:hamro_gadgets/widgets/nav_drawer.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  static const int TAB_NO = 0;
  int count;
  HomeScreen(this.count);

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
  List<RewardProducts> rewardpro=[];
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
  bool yes=false;
  void alert(int count2,BuildContext ctx){


    print('hiiiiiiiiii');
    Dialogs.materialDialog(

        color: Colors.white,

        msg: 'Congratulations!, you have won ${count2.toString()} coins  on your previous order.',
        title: 'Congratulations',
        animation: 'assets/cong_example.json',
barrierDismissible: true,
        context: ctx,
        actions: [
          IconsButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            text: 'Claim',
            iconData: Icons.done,
            color: primarycolor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),

        ],
        );

//    up(count2);
  setState(() {
    yes=true;
    to++;
  });

  }
  static const int TAB_NO = 1;
  List<Banners> imageList = [];
  List<Products> newproducts = [];
  List<Products>laptops=[];
  List<Products>speakers=[];
  List<Products>headphones=[];
  List<Banners> banners = [];
  TextEditingController _cont = TextEditingController();
  PersistentTabController _controller = PersistentTabController();
  List<Products>pro=[];
  int to=0;
  @override
  Widget build(BuildContext context) {
    getAllItems();
//    if(widget.count>0&&yes==false&&to==0){
//      alert(widget.count,context);
//
//    }
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
                    pro.clear();
                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Banners bd=Banners(snap.data.docs[i]['imageURL'],snap.data.docs[i]['onClick']);
                      imageList.add(bd);
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 280,
                          width: MediaQuery.of(context).size.width,
                          child: GFCarousel(
                            items: imageList.map(
                              (val) {
                                return InkWell(
                                  onTap:(){
                                   FirebaseFirestore.instance.collection('Products').doc(val.onClick).get().then((value) {
                                     Map<String,dynamic>map=value.data();
                                     List<dynamic>images=map['imageURLs'];
                                     List<dynamic>deturl=map['detailsGraphicURLs'];
                                     List<String>deturls=[];
                                     for(int i=0;i<images.length;i++){
                                       deturls.add(images[i].toString());
                                     }
                                     print(map);
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (context) => ProductDetailsScreen(
                                                 images[0],
                                                 map['name'],
                                                 map['mp'],
                                                 map['disPrice'],
                                                 map['description'],
                                                 map['details'],
                                                 deturls,
                                                 map['rating'].toString(),
                                                 map['specs'],
                                                 map['quantity'],
                                                 MediaQuery.of(context).size.height,
                                                 MediaQuery.of(context).size.width,
                                             map['varientID'])));

                                   });
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: FancyShimmerImage(
                                        shimmerDuration: Duration(seconds: 2),
                                        imageUrl: '${val.imgUrl}',
                                        width: 10000.0,
                                      ),
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
                          snap.data.docs[i]['status'],
                        snap.data.docs[i]['inStore'],
                        snap.data.docs[i]['productId'],
                        snap.data.docs[i]['varientID'],
                        snap.data.docs[i]['varientcolor'],
                        snap.data.docs[i]['varientsize']
                      );

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
                                    item.quantity,
                                item.inStore,
                                item.varientId),
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

                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    laptops.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
//                      print(snap.data.docs.length);
//                      print('---------${snap.data.docs[i]['varientID']}yes');
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          snap.data.docs[i]['Category'],
                          snap.data.docs[i]['SubCategories'],

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
                          snap.data.docs[i]['status'],
                      snap.data.docs[i]['inStore'],
                      snap.data.docs[i]['productId'],
                      snap.data.docs[i]['varientID'],
                          snap.data.docs[i]['varientcolor'],
                          snap.data.docs[i]['varientsize']
                      );

                      laptops.add(pro);
                    }

                    return (laptops.length!=0)?Container(
                      height: height * 0.41,
                      child: ListView.builder(
                          itemCount: laptops.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = laptops[index];

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
                                    item.quantity,
                                item.inStore,
                                item.varientId),
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
                    pro.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Banners bn=Banners(snap.data.docs[i]['imageURL'],snap.data.docs[i]['onClick']);

                      banners.add(bn);
                    }

                    return(banners.length!=0)? Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap:(){
 FirebaseFirestore.instance.collection('Products').doc(banners[0].onClick).get().then((value) {
                                  Map<String,dynamic>map=value.data();
                                  List<dynamic>images=map['imageURLs'];
                                  List<dynamic>deturl=map['detailsGraphicURLs'];
                                  List<String>deturls=[];
                                  for(int i=0;i<images.length;i++){
                                    deturls.add(images[i].toString());
                                  }
                                  print(map);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetailsScreen(
                                              images[0],
                                              map['name'],
                                              map['mp'],
                                              map['disPrice'],
                                              map['description'],
                                              map['details'],
                                              deturls,
                                              map['rating'].toString(),
                                              map['specs'],
                                              map['quantity'],
                                              MediaQuery.of(context).size.height,
                                              MediaQuery.of(context).size.width,
                                          map['varientID'])));
 });
                    },
                          child: Image.network(
                            banners[0].imgUrl,
                            height: height * 0.2,
                            width: width * 0.48,
                            fit: BoxFit.fill,
                          ),
                        ),
                        InkWell(
                          onTap:(){
                            FirebaseFirestore.instance.collection('Products').doc(banners[1].onClick).get().then((value) {
                              Map<String,dynamic>map=value.data();
                              List<dynamic>images=map['imageURLs'];
                              List<dynamic>deturl=map['detailsGraphicURLs'];
                              List<String>deturls=[];
                              for(int i=0;i<images.length;i++){
                                deturls.add(images[i].toString());
                              }
                              print(map);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(
                                          images[0],
                                          map['name'],
                                          map['mp'],
                                          map['disPrice'],
                                          map['description'],
                                          map['details'],
                                          deturls,
                                          map['rating'].toString(),
                                          map['specs'],
                                          map['quantity'],
                                          MediaQuery.of(context).size.height,
                                          MediaQuery.of(context).size.width,
                                      map['varientID'])));
                            });
                          },
                          child: Image.network(
                            banners[1].imgUrl,
                            height: height * 0.2,
                            width: width * 0.48,
                            fit: BoxFit.fill,
                          ),
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

                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    headphones.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          snap.data.docs[i]['Category'],
                          snap.data.docs[i]['SubCategories'],

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
                          snap.data.docs[i]['status'],
                      snap.data.docs[i]['inStore'],
                      snap.data.docs[i]['productId'],
                      snap.data.docs[i]['varientID'],
                          snap.data.docs[i]['varientcolor'],
                          snap.data.docs[i]['varientsize']
                      );

                      headphones.add(pro);
                    }

                    return (headphones.length!=0)?Container(
                      height: height * 0.41,
                      child: ListView.builder(
                          itemCount: headphones.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = headphones[index];
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
                                    item.quantity,
                                item.inStore,
                                item.varientId),
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
                    speakers.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          snap.data.docs[i]['Category'],
                          snap.data.docs[i]['SubCategories'],

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
                          snap.data.docs[i]['status'],
                      snap.data.docs[i]['inStore'],
                      snap.data.docs[i]['productId'],
                      snap.data.docs[i]['varientID'],
                          snap.data.docs[i]['varientcolor'],
                          snap.data.docs[i]['varientsize']
                      );

                      speakers.add(pro);
                    }

                    return(speakers.length!=0)? Container(
                      height: height * 0.41,
                      child: ListView.builder(
                          itemCount: speakers.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = speakers[index];
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
                                    item.quantity,
                                item.inStore,
                                item.varientId),
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
            Align(
              alignment:Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text('Special Deals',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('RewardProducts').snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    rewardpro.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      RewardProducts pro = RewardProducts(
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
                          snap.data.docs[i]['status'],
                      snap.data.docs[i]['inStore'],
                      snap.data.docs[i]['rewardpoints']);

                      rewardpro.add(pro);
                    }

                    return (rewardpro.length!=0)?Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: height * 0.41,
                        child: ListView.builder(
                            itemCount: rewardpro.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var item = rewardpro[index];
                              return Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                onTap: () {
                            Navigator.push(
                                  context,
                                 MaterialPageRoute(
                                     builder: (context) => RewardProductDetailsScreen(
                                         item.imageurls[0],
                                         item.name,
                                          item.mp,
                                          item.disprice,
                                         item.description,
                                         item.details,
                                          item.detailsurls,
                                          item.rating,
                                         item.specs,
                                          item.quantity,
                                          MediaQuery.of(context).size.height,
                                         MediaQuery.of(context).size.width,
                                     item.rewardpoints)));
                                },
                                child: Container(
                                height: height * 0.4,
                                width: width*0.5,
                                child: Card(
                                child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      item.quantity > 0

                                          ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size:
                                                  MediaQuery.of(context).size.height * 0.02,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text('in stock',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize:
                                                        MediaQuery.of(context).size.height *
                                                            0.02)),
                                              ],
                                            )),
                                      )
                                          : Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Out of stock',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize:
                                                    MediaQuery.of(context).size.height *
                                                        0.015))),
                                      ),
                                      (item.inStore)?Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Row(
                                            children: [
                                              Icon(Icons.business,
                                                color: Colors.blue,
                                                size:
                                                MediaQuery.of(context).size.height * 0.02,),
                                              Text(' In Store', style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize:
                                                  MediaQuery.of(context).size.height *
                                                      0.02))
                                            ],
                                          ),
                                        ),
                                      ):Container()
                                    ],
                                  ),

                                SizedBox(height: height * 0.01),
                                FancyShimmerImage(
                                imageUrl: item.imageurls[0],
                                shimmerDuration: Duration(seconds: 2),
                                height: height * 0.2,
                                // width: width * 0.47,
                                boxFit: BoxFit.fill,
                                ),
                                Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Align(
                                alignment: Alignment.topLeft,
                                child: RatingBar.builder(
                                initialRating: double.parse(item.rating),
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 12,
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
                                Container(
                                height: height * 0.07,
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: height * 0.02),
                                maxLines: 2),
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    Text('Buy at : ',style:GoogleFonts.poppins(fontSize:height*0.02,fontWeight: FontWeight.bold)),
                                    Text('${item.rewardpoints.toString()} coins ',style:GoogleFonts.poppins(fontSize:height*0.02)),
                                         Image.asset('assets/images/coins.png',height:height*0.025,)

//                            Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                            Text('Rs.${(widget.mp).toString()}',
//                            style: TextStyle(
//                            fontSize: height * 0.017,
//                            decoration: TextDecoration.lineThrough,
//                            fontWeight: FontWeight.w300)),
//                            Text('Rs.${(widget.disprice).toString()}',
//                            style: TextStyle(
//                            fontSize: height * 0.02,
//                            fontWeight: FontWeight.w500)),
//                            ]),
//                            ),
//                            Spacer(),
//                            Container(
//                            decoration: BoxDecoration(
//                            shape: BoxShape.circle, color: Colors.red),
//                            child: Padding(
//                            padding: EdgeInsets.all(height * 0.012),
//                            child: Align(
//                            alignment: Alignment.bottomRight,
//                            child: Text(
//                            ' - ${((int.parse(widget.mp.toString()) - int.parse(widget.disprice.toString())) / int.parse(widget.mp.toString()) * 100).toStringAsFixed(0)}%',
//                            style: TextStyle(color: Colors.white),
//                            )),
//                            )),
//                            ]),
                                  ],
                                  ),
                                )],)))),
                              );
                            }),
                      ),
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
          ],
        ),
      ),
    );
  }
}
