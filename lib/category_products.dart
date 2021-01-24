import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gadgets/widgets/ProductCard.dart';

import 'Constants/colors.dart';
import 'Constants/products.dart';

class CategoryProducts extends StatefulWidget {
  String catName;
  CategoryProducts({this.catName});
  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

List<Widget> allProducts = [];

class _CategoryProductsState extends State<CategoryProducts> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text(widget.catName),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
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
                child: Expanded(
                  child: Container(
                    // height: height * 0.8,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.59,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 4,
                      scrollDirection: Axis.vertical,
                      children: allProducts,
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
