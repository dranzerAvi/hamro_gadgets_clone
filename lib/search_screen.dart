import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/products.dart';
import 'package:hamro_gadgets/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

List<Products> dogList1 = [];
List<Widget> dogCardsList1 = [];

class _SearchScreenState extends State<SearchScreen> {
  List<DocumentSnapshot> docList = [];
  List<Products> dogList = [];
  @override
  void initState() {
    getData();
    getData1();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _cont = TextEditingController();
  void getData1() async {
    dogCardsList1.clear();
    dogList1.clear();
    print('started loading');
    await FirebaseFirestore.instance
        .collection("Products")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) async {
        Products dp = Products(
            f['Brands'],
            f['Category'],
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

        await dogList1.add(dp);
        // await dogCardsList1.add(MyDogCard(dp, width, height));
        print('Dog added');
//        print(f['imageLinks'].toString());
      });
    });
    setState(() {
      print(dogList1.length.toString());
      print(dogCardsList1.length.toString());
    });
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height * 0.75,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: dogList.length,
                  itemBuilder: (BuildContext, index) {
                    var item = dogList[index];
                    return InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
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
                                item.varientId)));
                        // _scaffoldKey.currentState.showBottomSheet((context) {
                        //   return StatefulBuilder(
                        //       builder: (context, StateSetter state) {
                        //     return ProfilePullUp(item, width, height);
                        //   });
                        // });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: width * 0.8,
                          child: Row(
                            children: <Widget>[
                              // Container(
                              //   height: 50,
                              //   width: 50,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.all(
                              //       Radius.circular(25),
                              //     ),
                              //   ),
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(25.0),
                              //     child: CachedNetworkImage(
                              //       height: 50,
                              //       width: 50,
                              //       imageUrl: item.url,
                              //       imageBuilder: (context, imageProvider) =>
                              //           Container(
                              //         decoration: BoxDecoration(
                              //           image: DecorationImage(
                              //               image: imageProvider,
                              //               fit: BoxFit.fill),
                              //         ),
                              //       ),
                              //       placeholder: (context, url) => GFLoader(
                              //         type: GFLoaderType.ios,
                              //       ),
                              //       errorWidget: (context, url, error) =>
                              //           Icon(Icons.error),
                              //     ),
                              //   ),
                              // ),
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

  getCaseDetails(String query) async {
    docList.clear();
    dogList.clear();
    setState(() {
      print('Updated');
    });

    if (query == '') {
      print(query);
      getData();
      return;
    }

    await FirebaseFirestore.instance
        .collection('Products')
        .get()
        .then((QuerySnapshot snapshot) {
      docList.clear();
      dogList.clear();
      snapshot.docs.forEach((f) {
        var name = f['name'].toString().toLowerCase();
        List<dynamic> dogsub = List<String>.from(f['subcategorysearch']);
        List<dynamic> dogName = List<String>.from(f['nameSearch']);
        List<dynamic> dogBreed = List<String>.from(f['categorySearch']);
        List<String> dogLowerCase = [];
        List<String> breedLowerCase = [];
        List<String> dogsubLowerCase = [];
        print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
//        print( f['Quantity'].length);
        for (var dog in dogName) {
          dogLowerCase.add(dog.toLowerCase());
        }
        for (var breed in dogBreed) {
          breedLowerCase.add(breed.toLowerCase());
        }
        for (var sub in dogsub) {
          dogsubLowerCase.add(sub.toLowerCase());
        }
        if (dogLowerCase.contains(query.toLowerCase()) ||
            breedLowerCase.contains(query.toLowerCase()) ||
            dogsubLowerCase.contains(query.toLowerCase()) ||
            name.toString().contains(query.toLowerCase())) {
          print('Match found ${f['name']}');
          docList.add(f);
          Products dog = Products(
              f['Brands'],
              f['Category'],
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
          dogList.add(dog);
          setState(() {
            print('Updated');
          });
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
        dogList.add(Products(
            f['Brands'],
            f['Category'],
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
        print('Dog added');
//        print(f['profileImage'].toString());
//        print('--------------------${f['Quantity'].length}');
      });
    });
    setState(() {
      print(dogList.length.toString());
    });
  }
}
