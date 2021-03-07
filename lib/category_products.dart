import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/widgets/ProductCard.dart';

import 'Constants/colors.dart';
import 'Constants/products.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

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
  bool filterApplied;
  double minPrice=10000.0;
  double maxPrice=100000.0;
  double _lowerValue=10000.0;
  double _upperValue=100000.0;
  double range1=0.0;
  double range2=0.0;
  @override
  void initState() {
    print(widget.filters.length);
    choice = 0;
    showSort = false;
    showFilter = false;
    filterApplied = false;
    getSubCategories();
    getbrands();
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
    });
  }

  void getSubCategories() async {
    await FirebaseFirestore.instance
        .collection('SubCategories')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        setState(() {
          if (value.docs[i].data()['cats'].toList().contains(widget.catName)) {
            allSubCatgories.add(value.docs[i].data()['sCatName']);
            print(value.docs[i].data()['sCatName']);
          }
        });
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
  RangeValues _currentRangeValues = const RangeValues(0, 100);

  static String _valueToString(double value) {
    return value.toStringAsFixed(0);}
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
                                  // color: Colors.white,
                                  height: allSubCatgories.length * 40.0,
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

                                          for (int i = 0;
                                              i < snap.data.docs.length;
                                              i++) {
                                            allSubCatgories.add(
                                              snap.data.docs[i]['sCatName'],
                                            );
                                          }

                                          return ListView.builder(
                                            itemCount: allSubCatgories.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: false,
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
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
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
                                                ),
                                              );
                                            },
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
                                  // color: Colors.white,
                                  height: allbrands.length * 40.0,
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
                                          List<String>allbrands2=[];
//                                          allbrands2.clear();

                                          for (int i = 0;
                                              i < snap.data.docs.length;
                                              i++) {
                                            print( snap.data.docs[i]['brandName']);

                                              allbrands2.add(
                                                snap.data.docs[i]['brandName'],
                                              );

                                          print('====${allbrands2[i]}');
                                          }
                                          print(allbrands2.length);

                                          return ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: false,
                                            itemCount: allbrands.length,
                                            itemBuilder: (context, i) {
                                              print('----------------------------');
                                              print(allbrands.length);
                                              return InkWell(
                                                onTap: () {
                                                  if (brandsChosen
                                                      .contains(allbrands[i])) {
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
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
                                                                : Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(allbrands[i],style:TextStyle(color:Colors.black))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
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
//                RangeSlider(
//                  values: _currentRangeValues,
//                  min: 0,
//                  max: 100,
//                  divisions: 50,
//                  labels: RangeLabels(
//                    _currentRangeValues.start.round().toString(),
//                    _currentRangeValues.end.round().toString(),
//                  ),
//                  onChanged: (RangeValues values) {
//                    setState(() {
//                      _currentRangeValues = values;
//                      print(_currentRangeValues.start);
//                    });
//                  },
//                ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(alignment:Alignment.topLeft,child: Text('Prices',style:GoogleFonts.poppins(fontWeight: FontWeight.w500))),
              ),
          frs.RangeSlider(
            min: minPrice,
            max: maxPrice,
            lowerValue: _lowerValue,
            upperValue: _upperValue,
            divisions: 5,
            showValueIndicator: true,
            valueIndicatorMaxDecimals: 1,
            onChanged: (double newLowerValue, double newUpperValue) {
              setState(() {
                _lowerValue = newLowerValue;
                _upperValue = newUpperValue;
                range1=newLowerValue;
                range2=newUpperValue;

              });
            },
            onChangeStart:
                (double startLowerValue, double startUpperValue) {
              print(
                  'Started with values: $startLowerValue and $startUpperValue');
            },
            onChangeEnd: (double newLowerValue, double newUpperValue) {
              print(
                  'Ended with values: $newLowerValue and $newUpperValue');
            },
          ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          print(allProducts.length);
                          List<Products> colorList = [];
                          List<Products>prices=[];
                          List subCatList = [];
                          List brandList = [];
                          List newlist=[];
                          if (widget.filters.contains('Colors')&&colorsChosen.length>0) {
                            for (int j = 0; j < colorsChosen.length; j++) {
                              var newList = allProducts
                                  .where((element) =>
                                      element.colors.contains(colorsChosen[j]))
                                  .toList();
                              for (int i = 0; i < newList.length; i++)
                                await colorList.add(newList[i]);
                            }
                          } else{
                            colorList = await allProducts;
//                            setState(() {
//
//                              print('hiiiiii');
//                              print(colorList.length);
//                            });
                          }


                          if (widget.filters.contains('Subcategories')&&subCatChosen.length>0) {
                            for (int j = 0; j < subCatChosen.length; j++) {
                              var newList = allProducts
                                  .where((element) =>
                                      element.subcategories == subCatChosen[j])
                                  .toList();
                              for (int i = 0; i < newList.length; i++)
                                await subCatList.add(newList[i]);
                            }
                          } else
                            subCatList = await allProducts;

                          if (widget.filters.contains('Brands')&&brandsChosen.length>0) {
                            for (int j = 0; j < brandsChosen.length; j++) {
                              var newList = allProducts
                                  .where((element) =>
                                      element.Brand == brandsChosen[j])
                                  .toList();
                              for (int i = 0; i < newList.length; i++)
                                await brandList.add(newList[i]);

                              print(brandList);
                            }
                          } else
                            brandList = await allProducts;
                          print('Printing111');
                          colorList.forEach((element) {
                            print('------------------');
                            print(element.name);
                          });

                          colorList.removeWhere(
                              (item) => !subCatList.contains(item));
                          print('Printing');
                          newlist=colorList;
                          colorList.forEach((element) {
                            print(element.name);
                          });
                          colorList
                              .removeWhere((item) => !brandList.contains(item));
                          print('Printing');
                          newlist=colorList;
                          colorList.forEach((element) {
                            print(element.name);
                          });
//                       colorList.forEach((element) {
//                         print('===${range1}');
//                         if(element.disprice<range2&&element.disprice>range1){
//                         print('----------');
//                         print(element.name);
//                         }
//                         else{
//                           prices.add(element);
//                         }
//                       });
//                       setState(() {
//                         colorList.removeWhere((element) => prices.contains(element));
//                         newlist=colorList;
//                         print(colorList.length);
//                       });
                         cleanList=await newlist;
                        cleanList.forEach((element)
                {
                  print('-3-3-3');
                          print(element.name);
                        });

                          setState(() {
                            print('List Length-${cleanList.length}');
                          });
                          if (filterApplied == false) filterApplied = true;
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primarycolor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Apply Filters',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          subCatChosen.clear();
                          colorsChosen.clear();
                          brandsChosen.clear();
                           _lowerValue=10000;
                           _upperValue=100000;
                           range1=10000;
                           range2=100000;
                          filterApplied = false;
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primarycolor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Clear Filters',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                          snap.data.docs[i]['status'],
                      snap.data.docs[i]['inStore'],
                      snap.data.docs[i]['productId']));
                      print(allProducts.length);
                    }
                    if (cleanList.isEmpty && filterApplied == false)
                      cleanList = allProducts;
                    return Expanded(
                      child: Container(
                        child: cleanList.length != 0
                            ? GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 0.6,
                                crossAxisSpacing: width * 0.001,
                                mainAxisSpacing: height * 0.002,
                                scrollDirection: Axis.vertical,
                                children: List<Widget>.generate(
                                    cleanList.length, (i) {
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
                                        cleanList[i].quantity,
                                    cleanList[i].inStore),
                                  );
                                }),
                              )
                            : Center(
                                child: Text('No Products Available'),
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
