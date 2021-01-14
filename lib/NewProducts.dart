import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/products.dart';

import 'package:hamro_gadgets/widgets/ProductCard.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<String> imageList = [];
  List<Products> newproducts = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
        body: Column(
          children: [
            Row(
              children: [
                Icon(Icons.arrow_back_ios,
                    color: Colors.black.withOpacity(0.8)),
                Text('All Products',
                    style: TextStyle(color: Colors.black.withOpacity(0.8)))
              ],
            ),
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
//                    Products pro=Products(snap.data.docs[i]['Brands'],snap.data.docs[i]['Category'],snap.data.docs[i]['SubCategories'],List.from(snap.data.docs[i]['colors']),snap.data.docs[i]['description'],all,List.from(snap.data.docs[i]['detailsGraphicURLs']),snap.data.docs[i]['disPrice'],snap.data.docs[i]['docID'],List.from(snap.data.docs[i]['imageURLs']),snap.data.docs[i]['mp'],snap.data.docs[i]['name'],snap.data.docs[i]['noOfPurchases'],snap.data.docs[i]['quantity'],snap.data.docs[i]['rating'].toString(),sp,snap.data.docs[i]['status']);
//
//
//
//
//
//                    newproducts.add(pro);

                    }

                    print(newproducts.length);

                    return Container(
                      height: height * 0.3,
                      child: ListView.builder(
                          itemCount: newproducts.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = newproducts[index];
                            return Container();
//                          return ProductCard(item.imageurls[0], item.name, item.mp, item.disprice,);
                          }),
                    );
                  } else {
                    return Container();
                  }
                })
          ],
        ));
  }
}
