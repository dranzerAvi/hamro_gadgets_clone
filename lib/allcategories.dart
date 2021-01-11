import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gadgets/Constants/colors.dart';
import 'package:hamro_gadgets/Constants/screens.dart';
import 'package:hamro_gadgets/widgets/custom_floating_button.dart';

class AllCategories extends StatefulWidget {
  static const int TAB_NO = 1;
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<Widget>allcats=[];
void categories()async{
await FirebaseFirestore.instance.collection('Categories').get().then((value) {
  for(int i =0;i<value.docs.length;i++){
    print(value.docs[i]['catName']);
    setState(() {
      allcats.add(Container(
        height:MediaQuery.of(context).size.height*0.2,
        width:MediaQuery.of(context).size.width*0.4,
        child: Card(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(value.docs[i]['catName'],style:TextStyle(color:Colors.black.withOpacity(0.7),fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height*0.03)),
                    Text(value.docs[i]['description'],style:TextStyle(color:Colors.black.withOpacity(0.7),fontWeight: FontWeight.w400,fontSize: MediaQuery.of(context).size.height*0.025)),
                  ],
                ),
              ),
            )
        ),
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
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
        floatingActionButton: CustomFloatingButton(CurrentScreen(
            tab_no: AllCategories.TAB_NO,
            currentScreen: AllCategories())),
      appBar:AppBar(


      backgroundColor: primarycolor,
      title:Text('Hamro Gadgets'),
      centerTitle:true,
    ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:height*0.03),
            Center(child: Text('Shop by Category',textAlign:TextAlign.center,style:TextStyle(color:Colors.black.withOpacity(0.7),fontWeight: FontWeight.bold,fontSize: height*0.03))),
              SizedBox(height:height*0.02),
            StreamBuilder(



                stream:FirebaseFirestore.instance.collection('Categories').snapshots(),



                builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snap){



                  if(snap.hasData&&!snap.hasError&&snap.data!=null){



                    allcats.clear();



                    for(int i =0;i<snap.data.docs.length;i++){

                      allcats.add(Container(
                        height:MediaQuery.of(context).size.height*0.2,
                        width:MediaQuery.of(context).size.width*0.4,
                        child: Card(
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snap.data.docs[i]['catName'],style:TextStyle(color:Colors.black.withOpacity(0.7),fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height*0.03)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snap.data.docs[i]['description'],style:TextStyle(color:Colors.black.withOpacity(0.7),fontWeight: FontWeight.w400,fontSize: MediaQuery.of(context).size.height*0.025)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ));





                    }



                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height:height*0.7,
                        child: GridView.count(crossAxisCount: 2,
                          childAspectRatio: 0.95,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          scrollDirection: Axis.vertical,
                          children: allcats,),
                      ),
                    );



                  }else {return Container();}}),

          ],
        ),
      ),


    );
  }
}
