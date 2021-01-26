import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/widgets/ProductCard.dart';

import 'Constants/colors.dart';
import 'Constants/products.dart';

class CategoryProducts extends StatefulWidget {
  String catName;List<String> filters=[];
  CategoryProducts({this.catName,this.filters});
  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}


List<Widget> allProducts = [];

class _CategoryProductsState extends State<CategoryProducts> {
  bool showSort;
  int choice;
  List cleanList=[];
  @override
  void initState() {
    print(widget.filters.length);
    super.initState();
  }
  String radioval='';
  final scaffoldState = GlobalKey<ScaffoldState>();
  Widget sort(BuildContext context,double height){

          return Container(
            height: height,


              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      title:Text('Low to High',style:GoogleFonts.montserrat()),
                      leading:Radio(
                        value:'1',
                        groupValue: radioval,
                        onChanged: (val){
                          setState(() {
                            radioval='1';
                          });
                        },
                      )
                  ),
                  ListTile(
                      title:Text('High to Low',style:GoogleFonts.montserrat()),
                      leading:Radio(
                        value:'2',
                        groupValue: radioval,
                        onChanged: (val){
                          setState(() {
                            radioval='2';
                          });
                        },
                      )
                  ),
                ],
              ),

          );



  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key:scaffoldState,
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text(widget.catName),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height:height*0.06,
            width:width,
            child:Card(
              elevation: 4,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [

                  InkWell(
                    onTap: (){
                      scaffoldState.currentState.showBottomSheet((context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter state) {
                          return sort(

                              context,
                              MediaQuery.of(context).size.height * 0.4);

                        });
                      });

                    },
                    child: Container(
                      height:height*0.05,
                      width:width*0.47,
                      child:Center(
                        child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Center(child: Icon(Icons.sort)),
                            SizedBox(width:10),
                            Center(child: Text('Sort',style:GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.bold)))
                          ]
                        ),
                      )
                    ),
                  ),
                 Container(
                   height:height*0.04,
                   width:1,
                   color:Colors.black,
                 ),
                  Container(
                      height:height*0.05,
                      width:width*0.47,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(Icons.filter_list),
                            SizedBox(width:10),
                            Text('Filter',style:GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.bold))
                          ]
                      )
                  ),
                ],
              ),
            )
          ),
//          showSort == true
//              ? Container(
//            height: 100,
//            child: Center(
//              child: Column(
//                children: [
//                  InkWell(
//                    onTap: () {
//                      var newList = allProducts.toList();
//
//                      newList
//                          .sort((a, b) => b.pricecompareTo(a.price));
//                      setState(() {
//                        cleanList = newList;
//
//                        choice = 0;
//                        print(choice);
//                      });
//                      for (var v in cleanList) {
//                        print(v.name);
//                      }
//                    },
//                    child: Container(
//                      color: choice == 0
//                          ? MColors.mainColor
//                          : MColors.primaryWhiteSmoke,
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(
//                          "Price- Highest to Lowest",
//                          style: normalFont(MColors.textDark, null),
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    height: 5,
//                  ),
//                  InkWell(
//                    onTap: () {
//                      var newList = prods.toList();
//
//                      newList
//                          .sort((a, b) => a.price.compareTo(b.price));
//                      setState(() {
//                        cleanList = newList;
//
//                        choice = 1;
//                        print(choice);
//                      });
//                      for (var v in cleanList) {
//                        print(v.name);
//                      }
//                    },
//                    child: Container(
//                      color: choice == 1
//                          ? MColors.mainColor
//                          : MColors.primaryWhiteSmoke,
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(
//                          "Price- Lowest to Highest",
//                          style: normalFont(MColors.textDark, null),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          )
//              : Container(),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .where('newProduct', isEqualTo: true)
                  .where('status', isEqualTo: 'active')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                if (snap.hasData && !snap.hasError && snap.data != null) {
                  allProducts.clear();

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

                    allProducts.add(ProductCard(
                        List.from(snap.data.docs[i]['imageURLs'])[0],
                        snap.data.docs[i]['name'],
                        snap.data.docs[i]['mp'],
                        snap.data.docs[i]['disPrice'],
                        snap.data.docs[i]['description'],
                        snap.data.docs[i]['details'],
                        List.from(snap.data.docs[i]['detailsGraphicURLs']),
                        snap.data.docs[i]['rating'].toString(),
                        snap.data.docs[i]['specs'],
                        snap.data.docs[i]['quantity']));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height * 0.75,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.59,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 4,
                        scrollDirection: Axis.vertical,
                        children: allProducts,
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}
