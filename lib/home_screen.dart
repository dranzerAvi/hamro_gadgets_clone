import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/banner.dart';

import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/products.dart';
import 'package:hamro_gadgets/search_screen.dart';
import 'package:hamro_gadgets/widgets/ProductCard.dart';
import 'package:hamro_gadgets/widgets/nav_drawer.dart';
// import 'package:hamro_gadgets/widgets/nav_drawer2.dart';
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
    // addDishParams();

    data();
    super.initState();
  }

  int total = 0;

  addDishParams() {
    FirebaseFirestore.instance.collection('Products').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('Products')
            .doc(element.id)
            .update({
          'nameSearch': setSearchParam(element['name']),
          'categorySearch':
              setSearchParamCategories(List.from(element['Category'])),
          'subcategorysearch':
              setSearchParamCategories(List.from(element['Category']))
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

  setSearchParamCategories(List<String> caseString) {
    List<String> caseSearchList = List();

    for (int j = 0; j < caseString.length; j++) {
      String temp = "";
      String str = "${caseString[j]}";
      for (int i = 0; i < str.length; i++) {
        temp = temp + str[i];
        caseSearchList.add(temp);
      }
    }

    return caseSearchList;
  }

  bool yes = false;
  void alert(int count2, BuildContext ctx) {
    print('hiiiiiiiiii');
    Dialogs.materialDialog(
      color: Colors.white,
      msg:
          'Congratulations!, you have won ${count2.toString()} coins  on your previous order.',
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
      yes = true;
      to++;
    });
  }

  void data() {
    print('hii');
    allproducts.clear();
    FirebaseFirestore.instance
        .collection('Products')
        .limit(10)
        .snapshots()
        .listen((event) {
      print(event.docs.length);
      for (int i = 0; i < event.docs.length; i++) {
        // print(i.toString());
        Products pro = Products(
            event.docs[i]['Brands'],
            List.from(event.docs[i]['Category']),
            event.docs[i]['SubCategories'],
            event.docs[i]['description'],
            event.docs[i]['details'],
            List.from(event.docs[i]['detailsGraphicURLs']),
            event.docs[i]['disPrice'],
            event.docs[i]['docID'],
            List.from(event.docs[i]['imageURLs']),
            event.docs[i]['mp'],
            event.docs[i]['name'],
            event.docs[i]['noOfPurchases'],
            event.docs[i]['quantity'],
            event.docs[i]['rating'].toString(),
            event.docs[i]['specs'],
            event.docs[i]['status'],
            event.docs[i]['inStore'],
            event.docs[i]['productId'],
            event.docs[i]['varientID'],
            event.docs[i]['varientcolor'],
            event.docs[i]['varientsize']);

        allproducts.add(pro);
      }
    });
  }

  static const int TAB_NO = 1;
  List<Banners> imageList = [];

  List<Products> allproducts = [];
  List<Products> newproducts = [];
  List<Products> phones = [];
  List<Products> accessories = [];
  List<Products> headphones = [];
  List<Banners> banners = [];
  TextEditingController _cont = TextEditingController();
  PersistentTabController _controller = PersistentTabController();
  List<Products> pro = [];
  int trend = 50;
  int head = 50;
  int lap = 50;
  int speak = 50;
  int to = 0;
  @override
  Widget build(BuildContext context) {
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
                      Banners bd = Banners(snap.data.docs[i]['imageURL'],
                          snap.data.docs[i]['onClick']);
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
                                  onTap: () {},
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
              ],
            ),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('top', isEqualTo: true)
                    .where('status', isEqualTo: 'active')
                    .limit(10)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    newproducts.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          List.from(snap.data.docs[i]['Category']),
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
                          snap.data.docs[i]['varientsize']);

                      newproducts.add(pro);
                    }

                    return (newproducts.length != 0)
                        ? Container(
                            height: height * 0.46,
                            child: ListView.builder(
                                itemCount: newproducts.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var item = newproducts[index];

                                  return Container(
                                    height: height * 0.45,
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
                          )
                        : Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: SpinKitWave(
                                    color: primarycolor, size: height * 0.023)),
                          );
                  } else {
                    return Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: SpinKitWave(
                              color: primarycolor, size: height * 0.023)),
                    );
                  }
                }),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Phones',
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
                    .limit(50)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    phones.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          List.from(snap.data.docs[i]['Category']),
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
                          snap.data.docs[i]['varientsize']);

                      allproducts.add(pro);
                    }
                    for (int i = 0; i < allproducts.length; i++)
                      if (allproducts[i].category.contains("Phones") ||
                          allproducts[i].category.contains(" Phones")) {
                        phones.add(allproducts[i]);
                      }
                    return (phones.length != 0)
                        ? Container(
                            height: height * 0.46,
                            child: ListView.builder(
                                itemCount: phones.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var item = phones[index];
                                  return Container(
                                    height: height * 0.45,
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
                          )
                        : Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: SpinKitWave(
                                    color: primarycolor, size: height * 0.023)),
                          );
                  } else {
                    return Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: SpinKitWave(
                              color: primarycolor, size: height * 0.023)),
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
                      Banners bn = Banners(snap.data.docs[i]['imageURL'],
                          snap.data.docs[i]['onClick']);

                      banners.add(bn);
                    }

                    return (banners.length != 0)
                        ? Container(
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Image.network(
                                  banners[0].imgUrl,
                                  height: height * 0.2,
                                  width: width * 0.48,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Image.network(
                                  banners[1].imgUrl,
                                  height: height * 0.2,
                                  width: width * 0.48,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ))
                        : Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: SpinKitWave(
                                    color: primarycolor, size: height * 0.023)),
                          );
                  } else {
                    return Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: SpinKitWave(
                              color: primarycolor, size: height * 0.023)),
                    );
                  }
                }),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Headsets',
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
                    .limit(50)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    headphones.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          List.from(snap.data.docs[i]['Category']),
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
                          snap.data.docs[i]['varientsize']);

                      allproducts.add(pro);
                    }
                    for (int i = 0; i < allproducts.length; i++)
                      if (allproducts[i].category.contains("Headset") ||
                          allproducts[i].category.contains(" Headset")) {
                        headphones.add(allproducts[i]);
                      }
                    return (headphones.length != 0)
                        ? Container(
                            height: height * 0.46,
                            child: ListView.builder(
                                itemCount: headphones.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var item = headphones[index];
                                  return Container(
                                    height: height * 0.45,
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
                          )
                        : Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: SpinKitWave(
                                    color: primarycolor, size: height * 0.023)),
                          );
                  } else {
                    return Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: SpinKitWave(
                              color: primarycolor, size: height * 0.023)),
                    );
                  }
                }),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Accessories',
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
                    .limit(50)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    accessories.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      Products pro = Products(
                          snap.data.docs[i]['Brands'],
                          List.from(snap.data.docs[i]['Category']),
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
                          snap.data.docs[i]['varientsize']);

                      allproducts.add(pro);
                    }
                    for (int i = 0; i < allproducts.length; i++)
                      if (allproducts[i].category.contains("Accessories") ||
                          allproducts[i].category.contains(" Accessories")) {
                        accessories.add(allproducts[i]);
                      }
                    return (accessories.length != 0)
                        ? Container(
                            height: height * 0.46,
                            child: ListView.builder(
                                itemCount: accessories.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var item = accessories[index];

                                  return Container(
                                    height: height * 0.45,
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
                          )
                        : Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: SpinKitWave(
                                    color: primarycolor, size: height * 0.023)),
                          );
                  } else {
                    return Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: SpinKitWave(
                              color: primarycolor, size: height * 0.023)),
                    );
                  }
                }),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
