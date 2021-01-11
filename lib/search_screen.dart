import 'package:flutter/material.dart';
import 'package:hamro_gadgets/Constants/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _cont=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 backgroundColor: Colors.white,
      body:Padding(
        padding:EdgeInsets.only(top:MediaQuery.of(context).size.height*0.05),
        child: Column(
          children:[
            TextFormField(
              controller: _cont,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search,color:Colors.grey),
                hintText: 'Search products',
                focusColor: primarycolor
              ),
            )
          ]
        ),
      )
    );
  }
}
