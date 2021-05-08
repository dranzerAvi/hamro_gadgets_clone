import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/products.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

List<Products> productList1 = [];

class _SearchScreenState extends State<SearchScreen> {
  List<DocumentSnapshot> docList = [];
  List<Products> productList = [];
  @override
  void initState() {
    getData();
    getData1();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _cont = TextEditingController();
  void getData1() async {
    productList1.clear();
    await FirebaseFirestore.instance
        .collection("Products")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) async {
        Products dp = Products(
            f['Brands'],
            List.from(f['Category']),
            f['SubCategories'],
            f['description'],
            f['details'],
            List.from(f['detailsGraphicURLs']),
            f['disPrice'],
            f['docID'],
            List.from(f['imageURLs']),
            f['mp'],
            f['name'],
            f['noOfPurchases'],
            f['quantity'],
            f['rating'].toString(),
            f['specs'],
            f['status'],
            f['inStore'],
            f['productId'],
            f['varientID'],
            f['varientcolor'],
            f['varientsize']);

        await productList1.add(dp);
      });
    });
    setState(() {});
  }

  double width, height;
  List<Widget> dogCardsList = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              controller: _cont,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search products',
                  focusColor: primarycolor),
              onChanged: (String query) {
                getCaseDetails(query);
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        color: searchType == 'Linear'
                            ? primarycolor
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Linear Search',
                            style: TextStyle(
                                color: searchType == 'Linear'
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          searchType = 'Linear';
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        color: searchType == 'Binary'
                            ? primarycolor
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Binary Search',
                            style: TextStyle(
                                color: searchType == 'Binary'
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          searchType = 'Binary';
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height * 0.75,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: productList.length,
                  itemBuilder: (BuildContext, index) {
                    var item = productList[index];
                    return InkWell(
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: width * 0.8,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    child: Text(
                                      '${item.name} in ${item.subcategories}',
                                      style: GoogleFonts.poppins(
                                          fontSize: height * 0.02),
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.call_made_sharp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  String searchType = 'Linear';

  //Linear Search
  bool linearSearch(List<String> array, String x) {
    bool isPresent = false;
    for (int i = 0; i < array.length; i++) {
      if (array[i].contains(x)) {
        isPresent = true;
      }
    }
    return isPresent;
  }

  //Binary Search
  bool binarySearch(List<String> a, int l, int r, String x) {
    if (r >= l) {
      int middle = (l + (r - l) / 2).toInt();

      //If the element is present at middle
      if (a[middle].contains(x)) {
        return true;
      }

      //If the element is smaller than middle
      if (a[middle].compareTo(x) > 0) {
        return binarySearch(a, l, middle - 1, x);
      }

      return binarySearch(a, middle + 1, r, x);
    }
    return false;
  }

  getCaseDetails(String query) async {
    docList.clear();
    productList.clear();
    setState(() {});

    if (query == '') {
      getData();
      return;
    }

    await FirebaseFirestore.instance
        .collection('Products')
        .get()
        .then((QuerySnapshot snapshot) {
      docList.clear();
      productList.clear();
      snapshot.docs.forEach((f) {
        var name = f['name'].toString().toLowerCase();
        List<dynamic> productSubcategory =
            List<String>.from(f['subcategorysearch']);
        List<dynamic> productName = List<String>.from(f['nameSearch']);
        List<dynamic> productCategory = List<String>.from(f['categorySearch']);
        List<String> productNameLowerCase = [];
        List<String> productCategoryLowerCase = [];
        List<String> productSubcategoryLowerCase = [];

        for (var dog in productName) {
          productNameLowerCase.add(dog.toLowerCase());
        }
        for (var breed in productCategory) {
          productCategoryLowerCase.add(breed.toLowerCase());
        }
        for (var sub in productSubcategory) {
          productSubcategoryLowerCase.add(sub.toLowerCase());
        }

        bool isCategoryPresent = false,
            isSubcategoryPresemt = false,
            isNamePresent = false;
        if (searchType == 'Linear') {
          print('Linear Search');
          isNamePresent =
              linearSearch(productNameLowerCase, query.toLowerCase());
          isCategoryPresent =
              linearSearch(productCategoryLowerCase, query.toLowerCase());
          isSubcategoryPresemt =
              linearSearch(productSubcategoryLowerCase, query.toLowerCase());
        } else {
          print('Binary Search');
          isNamePresent = binarySearch(productNameLowerCase, 0,
              productNameLowerCase.length - 1, query.toLowerCase());
          isCategoryPresent = binarySearch(productCategoryLowerCase, 0,
              productCategoryLowerCase.length - 1, query.toLowerCase());
          isSubcategoryPresemt = binarySearch(productSubcategoryLowerCase, 0,
              productSubcategoryLowerCase.length - 1, query.toLowerCase());
        }

        if (isNamePresent || isCategoryPresent || isSubcategoryPresemt) {
          docList.add(f);
          Products dog = Products(
              f['Brands'],
              List.from(f['Category']),
              f['SubCategories'],
              f['description'],
              f['details'],
              List.from(f['detailsGraphicURLs']),
              f['disPrice'],
              f['docID'],
              List.from(f['imageURLs']),
              f['mp'],
              f['name'],
              f['noOfPurchases'],
              f['quantity'],
              f['rating'].toString(),
              f['specs'],
              f['status'],
              f['inStore'],
              f['productId'],
              f['varientID'],
              f['varientcolor'],
              f['varientsize']);
          productList.add(dog);
          setState(() {});
        }
      });
    });
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection("Products")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        productList.add(Products(
            f['Brands'],
            List.from(f['Category']),
            f['SubCategories'],
            f['description'],
            f['details'],
            List.from(f['detailsGraphicURLs']),
            f['disPrice'],
            f['docID'],
            List.from(f['imageURLs']),
            f['mp'],
            f['name'],
            f['noOfPurchases'],
            f['quantity'],
            f['rating'].toString(),
            f['specs'],
            f['status'],
            f['inStore'],
            f['productId'],
            f['varientID'],
            f['varientcolor'],
            f['varientsize']));
      });
    });
    setState(() {});
  }
}
