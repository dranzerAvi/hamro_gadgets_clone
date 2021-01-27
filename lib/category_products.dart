import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/widgets/ProductCard.dart';

import 'Constants/colors.dart';
import 'Constants/products.dart';

class CategoryProducts extends StatefulWidget {
  String catName;
  List<String> filters = [];
  CategoryProducts({this.catName, this.filters});
  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

List<Products> allProducts = [];
List<String> allbrands = [];

class _CategoryProductsState extends State<CategoryProducts> {
  bool showSort, showFilter;

  int choice;
  List cleanList = [];
  @override
  void initState() {
    print(widget.filters.length);
    choice = 0;
    showSort = false;
    showFilter = false;

    super.initState();
  }

  void getbrands() async {
    await FirebaseFirestore.instance.collection('Brands').get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        setState(() {
          if (value.docs[i].data()['cats'].toList().contains(widget.catName)) {
            allbrands.add(value.docs[i].data()['brandName']);
          }
        });
      }
      print(allbrands.length);
    });
  }

  void getSubCategories() async {
    await FirebaseFirestore.instance
        .collection('SubCategories')
        .get()
        .then((value) {
      print('Scat Name-${value}');
      for (int i = 0; i < value.docs.length; i++) {
        setState(() {
          if (value.docs[i].data()['cats'].toList().contains(widget.catName)) {
            allSubCatgories.add(value.docs[i].data()['sCatName']);
            print(value.docs[i].data()['sCatName']);
          }
        });
        print('Scat Name-${value.docs[i].data()}');
      }
    });
    print('-------------------$allSubCatgories');
  }

  String radioval = '';
  final scaffoldState = GlobalKey<ScaffoldState>();
  List<String> allSubCatgories = [];
  Widget sort(BuildContext context, double height) {
    return Container(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              title: Text('Low to High', style: GoogleFonts.montserrat()),
              leading: Radio(
                value: '1',
                groupValue: radioval,
                onChanged: (val) {
                  setState(() {
                    radioval = '1';
                  });
                },
              )),
          ListTile(
              title: Text('High to Low', style: GoogleFonts.montserrat()),
              leading: Radio(
                value: '2',
                groupValue: radioval,
                onChanged: (val) {
                  setState(() {
                    radioval = '2';
                  });
                },
              )),
        ],
      ),
    );
  }

  List<String> colorsChosen = [];
  List<String> subCatChosen = [];
  List<String> brandsChosen = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldState,
      endDrawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: Container(
            width: width,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Text(
                        'Filter By',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20)),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close_rounded))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: width,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                widget.filters.contains('Colors')
                    ? Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.black),
                        child: ExpansionTile(
                          title: Text('Colors'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (colorsChosen.contains('Red')) {
                                          // int index=colorsChosen.indexOf('Red');
                                          colorsChosen.remove('Red');
                                          setState(() {
                                            print(colorsChosen);
                                          });
                                        } else {
                                          colorsChosen.add('Red');
                                          setState(() {
                                            print(colorsChosen);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(
                                                width: 1,
                                                color:
                                                    colorsChosen.contains('Red')
                                                        ? Colors.black
                                                        : Colors.white)),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (colorsChosen.contains('Blue')) {
                                          // int index=colorsChosen.indexOf('Red');
                                          colorsChosen.remove('Blue');
                                          setState(() {
                                            print(colorsChosen);
                                          });
                                        } else {
                                          colorsChosen.add('Blue');
                                          setState(() {
                                            print(colorsChosen);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            border: Border.all(
                                                width: 1,
                                                color: colorsChosen
                                                        .contains('Blue')
                                                    ? Colors.black
                                                    : Colors.white)),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (colorsChosen.contains('Green')) {
                                          // int index=colorsChosen.indexOf('Red');
                                          colorsChosen.remove('Green');
                                          setState(() {
                                            print(colorsChosen);
                                          });
                                        } else {
                                          colorsChosen.add('Green');
                                          setState(() {
                                            print(colorsChosen);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            border: Border.all(
                                                width: 1,
                                                color: colorsChosen
                                                        .contains('Green')
                                                    ? Colors.black
                                                    : Colors.white)),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (colorsChosen.contains('Yellow')) {
                                          // int index=colorsChosen.indexOf('Red');
                                          colorsChosen.remove('Yellow');
                                          setState(() {
                                            print(colorsChosen);
                                          });
                                        } else {
                                          colorsChosen.add('Yellow');
                                          setState(() {
                                            print(colorsChosen);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            border: Border.all(
                                                width: 1,
                                                color: colorsChosen
                                                        .contains('Yellow')
                                                    ? Colors.black
                                                    : Colors.white)),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                widget.filters.contains('Subcategories')
                    ? Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.black),
                        child: ExpansionTile(
                          title: Text('Sub Categories'),
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: Container(
                                  color: Colors.white,
                                  height: 100,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('SubCategories')
                                          .where('cats',
                                              arrayContains: widget.catName)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snap) {
                                        if (snap.hasData &&
                                            !snap.hasError &&
                                            snap.data != null) {
                                          allSubCatgories.clear();
                                          print('Docs ${snap.data.docs}');
                                          for (int i = 0;
                                              i < snap.data.docs.length;
                                              i++) {
                                            print(
                                                'name-${snap.data.docs[i]['sCatName']}');
                                            allSubCatgories.add(
                                              snap.data.docs[i]['sCatName'],
                                            );
                                            print(allSubCatgories.length);
                                          }

                                          return Container(
                                            child: ListView.builder(
                                              itemCount: allSubCatgories.length,
                                              itemBuilder: (context, i) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (subCatChosen.contains(
                                                        allSubCatgories[i])) {
                                                      // int index=colorsChosen.indexOf('Red');
                                                      subCatChosen.remove(
                                                          allSubCatgories[i]);
                                                      setState(() {
                                                        print(subCatChosen);
                                                      });
                                                    } else {
                                                      subCatChosen.add(
                                                          allSubCatgories[i]);
                                                      setState(() {
                                                        print(subCatChosen);
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 100,
                                                    color: Colors.white,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1),
                                                              color: subCatChosen
                                                                      .contains(
                                                                          allSubCatgories[
                                                                              i])
                                                                  ? primarycolor
                                                                  : Colors
                                                                      .white),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(allSubCatgories[i])
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ))
                          ],
                        ),
                      )
                    : Container(),
                (widget.filters.contains('Brands'))
                    ? Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.black),
                        child: ExpansionTile(
                          title: Text('Brands'),
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: Container(
                                  color: Colors.white,
                                  height: 100,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Brands')
                                          .where('cats',
                                              arrayContains: widget.catName)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snap) {
                                        if (snap.hasData &&
                                            !snap.hasError &&
                                            snap.data != null) {
                                          allbrands.clear();
                                          print('Docs ${snap.data.docs}');
                                          for (int i = 0;
                                              i < snap.data.docs.length;
                                              i++) {
                                            allbrands.add(
                                              snap.data.docs[i]['brandName'],
                                            );
                                            print(allbrands.length);
                                          }

                                          return Container(
                                            child: ListView.builder(
                                              itemCount: allbrands.length,
                                              itemBuilder: (context, i) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (brandsChosen.contains(
                                                        allbrands[i])) {
                                                      // int index=colorsChosen.indexOf('Red');
                                                      brandsChosen
                                                          .remove(allbrands[i]);
                                                      setState(() {
                                                        print(brandsChosen);
                                                      });
                                                    } else {
                                                      brandsChosen
                                                          .add(allbrands[i]);
                                                      setState(() {
                                                        print(brandsChosen);
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 50,
                                                    color: Colors.white,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1),
                                                              color: brandsChosen
                                                                      .contains(
                                                                          allbrands[
                                                                              i])
                                                                  ? primarycolor
                                                                  : Colors
                                                                      .white),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(allbrands[i])
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ))
                          ],
                        ),
                      )
                    : Container(),
                InkWell(
                  onTap: () async {
                    List colorList = [];
                    List subCatList = [];
                    List brandList = [];
                    if (widget.filters.contains('Colors')) {
                      for (int j = 0; j < colorsChosen.length; j++) {
                        var newList = allProducts
                            .where((element) =>
                                element.colors.contains(colorsChosen[j]))
                            .toList();
                        for (int i = 0; i < newList.length; i++)
                          colorList.add(newList[i]);
                      }
                    } else
                      colorList = allProducts;

                    if (widget.filters.contains('Subcategories')) {
                      for (int j = 0; j < subCatChosen.length; j++) {
                        var newList = allProducts
                            .where((element) =>
                                element.subcategories == subCatChosen[j])
                            .toList();
                        for (int i = 0; i < newList.length; i++)
                          subCatList.add(newList[i]);
                      }
                    } else
                      subCatList = allProducts;

                    if (widget.filters.contains('Brands')) {
                      for (int j = 0; j < brandsChosen.length; j++) {
                        var newList = allProducts
                            .where((element) => element.Brand == brandsChosen[j])
                            .toList();
                        for (int i = 0; i < newList.length; i++)
                          brandList.add(newList[i]);
                        print('checkinggggggggg');
                        print(brandList);
                      }
                    } else
                      brandList = allProducts;
print(colorList);
                    colorList.removeWhere((item) => !subCatList.contains(item));
                    print(colorList);
                    colorList.removeWhere((item) => !brandList.contains(item));
                    print(colorList);
                    cleanList = await colorList;
                    setState(() {});

                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: primarycolor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Apply Filters',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: primarycolor,
        title: Text(widget.catName),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: Column(
          children: [
            Container(
                height: height * 0.06,
                width: width,
                child: Card(
                  elevation: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          // scaffoldState.currentState.showBottomSheet((context) {
                          //   return StatefulBuilder(builder:
                          //       (BuildContext context, StateSetter state) {
                          //     return sort(context,
                          //         MediaQuery.of(context).size.height * 0.4);
                          //   });
                          // });
                          if (showSort == false)
                            showSort = true;
                          else
                            showSort = false;
                          setState(() {});
                        },
                        child: Container(
                            height: height * 0.05,
                            width: width * 0.47,
                            child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: Icon(Icons.sort)),
                                    SizedBox(width: 10),
                                    Center(
                                        child: Text('Sort',
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)))
                                  ]),
                            )),
                      ),
                      Container(
                        height: height * 0.04,
                        width: 1,
                        color: Colors.black,
                      ),
                      InkWell(
                        onTap: () {
                          scaffoldState.currentState.openDrawer();
                          // if (showFilter == false)
                          //   showFilter = true;
                          // else
                          //   showFilter = false;
                          // setState(() {});
                        },
                        child: Container(
                            height: height * 0.05,
                            width: width * 0.47,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_list),
                                  SizedBox(width: 10),
                                  Text('Filter',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))
                                ])),
                      ),
                    ],
                  ),
                )),
            showSort == true
                ? Container(
                    // height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                var newList = allProducts.toList();

                                newList.sort(
                                    (a, b) => b.disprice.compareTo(a.disprice));
                                setState(() {
                                  cleanList = newList;

                                  choice = 0;
                                  print(choice);
                                });
                                for (var v in cleanList) {
                                  print(v.name);
                                }
                              },
                              child: Container(
                                color:
                                    choice == 0 ? primarycolor : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Price- Highest to Lowest",
                                    style: TextStyle(
                                        color: choice == 0
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                var newList = allProducts.toList();

                                newList.sort(
                                    (a, b) => a.disprice.compareTo(b.disprice));
                                setState(() {
                                  cleanList = newList;

                                  choice = 1;
                                  print(choice);
                                });
                                for (var v in cleanList) {
                                  print(v.name);
                                }
                              },
                              child: Container(
                                color:
                                    choice == 1 ? primarycolor : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Price- Lowest to Highest",
                                    style: TextStyle(
                                        color: choice == 1
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            showFilter == true
                ? Container(
                    // height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            widget.filters.contains('Colors')
                                ? Container(
                                    width: width,
                                    child: Card(
                                        child: Column(
                                      children: [
                                        Text('Colors',
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    )),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('newProduct', isEqualTo: true)
                    .where('status', isEqualTo: 'active')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    allProducts.clear();

                    for (int i = 0; i < snap.data.docs.length; i++) {
                      allProducts.add(Products(
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
                          snap.data.docs[i]['status']));
                      print(allProducts.length);
                    }
                    if (cleanList.isEmpty) cleanList = allProducts;
                    return Expanded(
                      child: Container(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 4,
                          scrollDirection: Axis.vertical,
                          children:
                              List<Widget>.generate(cleanList.length, (i) {
                            return Container(
                              // color: Colors.red,
                              child: ProductCard(
                                  cleanList[i].imageurls[0],
                                  cleanList[i].name,
                                  cleanList[i].mp,
                                  cleanList[i].disprice,
                                  cleanList[i].description,
                                  cleanList[i].details,
                                  cleanList[i].detailsurls,
                                  cleanList[i].rating,
                                  cleanList[i].specs,
                                  cleanList[i].quantity),
                            );
                          }),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
