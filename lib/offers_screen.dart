import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/offer.dart';

Offer discount;

class ApplyOffers extends StatefulWidget {
  State state;
  BuildContext ctxt;
  ApplyOffers(this.state, this.ctxt);
  @override
  _ApplyOffersState createState() => _ApplyOffersState();
}

class _ApplyOffersState extends State<ApplyOffers> {
  List<Offer> offers = new List<Offer>();
  List<Offer>filteroffers=[];
  User user;
  List test=[];

  void check()async{
    test.clear();
    user= FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('Users').document(user.uid).get().then((value) {
      Map map=value.data();
      test=map['couponUsed'];
    });
    print('---------------------${test.length}');
    filter();
  }
  int add=0;
  List<Offer>alloffers=[];
  String checking='';
  void filter()async{
    user=await FirebaseAuth.instance.currentUser;
    filteroffers.clear();
    alloffers.clear();
    FirebaseFirestore.instance.collection('Offers').snapshots().forEach((element) {
      for(int i=0;i<element.docs.length;i++){
        alloffers.add(
            Offer(
                element.docs[i]['Title'],
                element.docs[i]['Subtitle'],
                element.docs[i]['ImageURL'],
                element.docs[i]['discountPercentage'],

                element.docs[i]['perUserLimit'])
        );
      }
      for(int j=0;j<alloffers.length;j++){
        add=0;
        for(int k=0;k<test.length;k++){
          print(test[k].toString());
          if(test[k]==alloffers[j].title){
            add++;

            print('----------Add:${add}');
          }
        }
        if(int.parse(alloffers[j].perUserLimit)!=add){
          setState(() {
            filteroffers.add(Offer(
                alloffers[j].title,
                alloffers[j].subtitle,
                alloffers[j].imageURL,
                alloffers[j].discount,

                alloffers[j].perUserLimit));
          });
          print('-----------Filter${filteroffers.length}');
        }
      }
    });





  }
  @override
  void initState() {
    check();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Apply Coupon',
          style:GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold)
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Offers').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
            if (snap.hasData && !snap.hasError && snap.data != null) {
              offers.clear();

              for (int i = 0; i < snap.data.docs.length; i++) {
                offers.add(Offer(
                    snap.data.docs[i]['Title'],
                    snap.data.docs[i]['Subtitle'],
                    snap.data.docs[i]['ImageURL'],
                    snap.data.docs[i]['discountPercentage'],

                    snap.data.docs[i]['perUserLimit']));


              }
//              for(int j=0;j<offers.length;j++){
//                add=0;
//               for(int k=0;k<test.length;k++){
//                 print(test[k].toString());
//                 if(test[k]==offers[j].title){
//                   add++;
//                   print('----------Add:${add}');
//                 }
//               }
//               if(int.parse(offers[j].perUserLimit)!=add){
//                 filteroffers.add(Offer(
//                     snap.data.documents[j]['Title'],
//                     snap.data.documents[j]['Subtitle'],
//                     snap.data.documents[j]['ImageURL'],
//                     snap.data.documents[j]['discountPercentage'],
//
//                     snap.data.documents[j]['perUserLimit']));
//               }
//              }

              return (filteroffers.length!=0)?Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(

                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteroffers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 250,

                          margin: EdgeInsets.only(right: 4.0),
                          child: Card(

                           child:Container(
                             height:MediaQuery.of(context).size.height*0.4,
                             width:MediaQuery.of(context).size.width*0.7,
                             child:Column(
                               children: [
                                 ClipRRect(
                                   borderRadius: BorderRadius.circular(4),
                                   child: Image.network(
                                    filteroffers[index].imageURL,
                                     width: MediaQuery.of(context).size.width,
                                     height: 190,
                                     fit: BoxFit.cover,
                                   ),
                                 ),
                                 Row(
                                   mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Column(
                                         children: [
                                           Text(filteroffers[index].title,style:GoogleFonts.poppins(color:primarycolor,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height*0.023)),
//                                         Text(filteroffers[index].subtitle,style:GoogleFonts.poppins(color:Colors.black,fontSize: MediaQuery.of(context).size.height*0.015))
                                         ],
                                       ),
                                     ),
                                     InkWell(
                                       onTap: () {
                                         setState(() {
                                           discount = Offer(
                                               filteroffers[index].title,
                                               filteroffers[index].subtitle,
                                               filteroffers[index].imageURL,
                                               filteroffers[index].discount,
                                               filteroffers[index].perUserLimit);

                                           widget.state.setState(() {
                                             print(1);
                                           });
                                           Navigator.of(context).pop();
                                         });
                                       },
                                       child: Card(
                                         child:Container(
                                           color: secondarycolor,

                                           height:MediaQuery.of(context).size.height*0.04,
                                           width:MediaQuery.of(context).size.width*0.25,
                                           child:Center(child: Text('APPLY',style:GoogleFonts.poppins(color:primarycolor,fontWeight: FontWeight.bold)))
                                         )
                                       ),
                                     )
                                   ],
                                 )
                               ],
                             )
                           )
                          ),
                        );
                      }),
                ),
              ):Center(
                child: Container(
                    height:100,
                    width:MediaQuery.of(context).size.width,
                    child:Center(child: Text('No promo codes available!'))
                ),
              );
            } else {
              return Container(
                  child:Center(child: Text('No coupons available'))
              );
            }
          }),
    );
  }
}
