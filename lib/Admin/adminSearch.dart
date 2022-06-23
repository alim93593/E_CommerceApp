import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminGetData.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

 class AdminSearchPage extends StatefulWidget {
   final String productId;
   AdminSearchPage({Key key,this.productId}):super(key: key);
  @override
  _AdminSearchPageState createState() => _AdminSearchPageState();
}
class _AdminSearchPageState extends State<AdminSearchPage>{

  Future<QuerySnapshot> doclist;
  String productId;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: (){
              Route route = MaterialPageRoute(builder: (c) => UploadPage());
              Navigator.pushReplacement(context, route);
              // SystemNavigator.pop();
            },
          ),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [Colors.pink, Colors.lightGreenAccent],
                    begin: const FractionalOffset(0.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          centerTitle: true,
          title:  Text(
            'e-shop',
            style: TextStyle(
                fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          bottom:  PreferredSize(
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
                ItemModel model =ItemModel.fromJson(snap.data.documents[index].data);
                productId=snap.data.documents[index].documentID.toString();
                return sourceInfoAdmin(model, context);
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
  // ignore: missing_return
  Widget sourceInfoAdmin(ItemModel model, BuildContext context,
      {Color background, removeCartFunction}) {
    try{
      return Container(
        // child: InkWell(
        //   onTap: (){
        //
        //   },
        //   splashColor: Colors.pink,
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child:Container(
              height: 190.0,
              width:  width,
              child: Row(
                children: [
                  Image.network(model.thumbnailUrl,width: 140.0,height: 140.0,),
                  SizedBox(width: 4.0,),
                  Expanded(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.0,),
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(model.title,style: TextStyle(color: Colors.black,fontSize: 14.0),),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Row(
                          children: [
                            model.discount!= 0
                                ?Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.pink,
                              ),
                              alignment: Alignment.topLeft,
                              width: 40.0,
                              height: 43.0,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(model.discount.toString(),style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.normal)),
                                    Text(
                                      "Off",style: TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                :Text(''),
                            SizedBox(width: 10.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                model.discount!= 0
                                    ?Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        r"Original Price:$",
                                        style: TextStyle(fontSize: 24.0,color: Colors.grey, decoration: TextDecoration.lineThrough,),
                                      ),
                                      Text(
                                        (model.price).toString(),
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    :Text(''),
                                Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      model.discount!=0
                                          ?Text(
                                        r"New Price: ",
                                        style: TextStyle(fontSize: 24.0,color: Colors.grey),
                                      )
                                          :Text(
                                        r"Total Price: ",
                                        style: TextStyle(fontSize: 24.0,color: Colors.grey),
                                      ),
                                      Text(
                                        r"$ ",
                                        style:TextStyle(fontSize: 16.0,color: Colors.red) ,
                                      ),
                                      model.discount!= 0
                                          ?Text(
                                        (model.price-(model.price*model.discount/100)).toString(),
                                        style: TextStyle(fontSize: 15.0,color: Colors.grey),
                                      )
                                          :Text(
                                        (model.price).toString(),
                                        style: TextStyle(fontSize: 15.0,color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Flexible(
                          child: Container(
                            height: 50,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: IconButton(
                                  icon: Icon(Icons.delete,color: Colors.red,),
                                  onPressed: (){
                                    removeItemFromDataBase();
                                  },
                                ) ,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: IconButton(
                                  icon: Icon(Icons.edit,color: Colors.pinkAccent,),
                                  onPressed: (){
                                    Route route = MaterialPageRoute(builder: (c)=> AdminGetProduct(itemmodel:model,productId: productId,));
                                    Navigator.pushReplacement(context, route);
                                  },
                                ) ,
                              ),
                            ),
                          ],
                        ),
                        Divider(height:5.0,color: Colors.pink,),
                      ],
                    ) ,
                  ),
                ],
              ),
            ) ,
          ),
      );
    }catch(ex){
      print(ex.toString());
    }
  }
  removeItemFromDataBase()async {
    // print(productId);
    if(productId != null){
      final itemref =  Firestore.instance.collection("items");
      await  itemref.document(getproductId).delete();
          // .then((value) =>
          // Fluttertoast.showToast(msg: "Item Have Been Deleted"));
      final Future<bool> stoargerefrenece =  await  FirebaseStorage.instance.ref().child("items").delete().then((value) =>
          Fluttertoast.showToast(msg: "Item Have Been Deleted"));
       print(stoargerefrenece);

    }else{return;}
    Route route = MaterialPageRoute(builder: (c)=> AdminSearchPage());
    Navigator.pushReplacement(context, route);
  }
  confirmDeletion(mcontext){
      return showDialog(
          context: mcontext,
          builder: (con){
            return SimpleDialog(
              title: Text('Would You Like To Dlete This Product?',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              children: [
                SimpleDialogOption(
                  child: Text('Yes',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  onPressed: removeItemFromDataBase(),
                ),
                SimpleDialogOption(
                  child: Text('Cancel',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
    }
  }

