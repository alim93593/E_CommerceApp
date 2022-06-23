// ignore_for_file: missing_required_param

import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> doclist;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: Searchwidget(),
            preferredSize: Size(56.0, 56.0),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: doclist,
          builder: (context,snap){
            return snap.hasData
                   ?ListView.builder(
                    itemCount:snap.data.documents.length ,
                    itemBuilder: (context,index){
                      if(snap.connectionState == ConnectionState.none){
                        return Text('Error Please Check Your Connection...'
                            ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,));
                      }
                      if(snap.connectionState == ConnectionState.waiting){
                        return Container(child: circularProgress(),);
                      }else{
                        ItemModel model =ItemModel.fromJson(snap.data.documents[index].data);
                        return sourceInfo(model, context);
                      }
                      // ItemModel model =ItemModel.fromJson(snap.data.documents[index].data);
                      // return sourceInfo(model, context);
                    },
            )
                   :Text('No Data Avalible');
          },
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Searchwidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin: const FractionalOffset(0.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp)),
          child: Container(
            width: MediaQuery.of(context).size.width - 40.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0)
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.search,color: Colors.blueGrey,),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      onChanged: (value){
                        startSearching(value);
                      },
                      decoration: InputDecoration.collapsed(hintText: "Search Here"),
                    ),
                  ),
                ),
              ],
            ),

          ),

    );
  }
  Future startSearching(String query) async {
    doclist = Firestore.instance.collection("items")
        .where("shortInfo",isGreaterThanOrEqualTo: query)
        .getDocuments();

  }
}

