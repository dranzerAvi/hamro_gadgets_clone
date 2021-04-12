import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Bookmarks.dart';
import 'package:hamro_gadgets/Constants/cart.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/screens.dart';
import 'package:hamro_gadgets/category_products.dart';
import 'package:hamro_gadgets/services/database_helper.dart';
import 'package:hamro_gadgets/widgets/custom_floating_button.dart';

class AllCategories extends StatefulWidget {
  static const int TAB_NO = 1;
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<Widget> allcats = [];
  void categories() async {
    await FirebaseFirestore.instance
        .collection('Categories')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        print(value.docs[i]['catName']);
        setState(() {
          allcats.add(Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(value.docs[i]['catName'],
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.03)),
                    Text(value.docs[i]['description'],
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025)),
                  ],
                ),
              ),
            )),
          ));
        });
      }
    });
    print(allcats.length);
  }

  @override
  void initState() {
    super.initState();
  }

  final dbHelper = DatabaseHelper.instance;
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    getAllItems();
    return Scaffold(
      backgroundColor: Colors.white,
//      floatingActionButton: CustomFloatingButton(CurrentScreen(
//          tab_no: AllCategories.TAB_NO, currentScreen: AllCategories())),
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('Hamro Gadgets'),
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
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            SizedBox(height: height * 0.03),
            Center(
                child: Text('Shop by Category',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.03))),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Categories')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData && !snap.hasError && snap.data != null) {
                    allcats.clear();
                    for (int i = 0; i < snap.data.docs.length; i++) {
                      allcats.add(Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryProducts(
                                          catName: snap.data.docs[i]['catName'],
                                          filters: List.from(
                                              snap.data.docs[i]['filters']),
                                      sizefilters:List.from(snap.data.docs[i]['sizefilter'])
                                        )));
                          },
                          child: Card(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    snap.data.docs[i]['imgURL'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(snap.data.docs[i]['catName'],
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017)),
                              ),
                            ],
                          )),
                        ),
                      ));
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // height: height * 0.7,
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 0.95,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            scrollDirection: Axis.vertical,
                            children: allcats,
                          ),
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
