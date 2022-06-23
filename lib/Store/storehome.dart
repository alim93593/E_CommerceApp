// ignore_for_file: missing_return

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}
class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [Colors.pink, Colors.lightGreenAccent],
                    begin: const FractionalOffset(0.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          title: Text(
            'e-shop',
            style: TextStyle(
                fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (c)=> CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.pink,
                    )),
                Positioned(child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3.0,
                      bottom: 4.0,
                      left: 6.0,
                      child: Consumer<CartItemCounter>(
                        builder: (context,counter,_){
                          return Text(
                           // ignore: null_aware_before_operator
                           (EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)?.length-1 ).toString(),
                            style: TextStyle(color: Colors.white,fontSize: 12.0,fontWeight: FontWeight.w500),
                          );
                        },
                      ),),
                  ],
                ))
              ],
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true ,delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),
              builder: (context,datasnapshot){
                return !datasnapshot.hasData
                    ?SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                    :SliverStaggeredGrid.countBuilder(
                     crossAxisCount: 1,
                     staggeredTileBuilder: (c)=> StaggeredTile.fit(1),
                     itemBuilder: (context,index){
                       if(datasnapshot.connectionState == ConnectionState.none){
                         return Text('Error Please Check Your Connection...'
                             ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,));
                       }
                       if(datasnapshot.connectionState == ConnectionState.waiting){
                         return Container(child: circularProgress(),);
                       }else{
                         ItemModel model = ItemModel.fromJson(datasnapshot.data.documents[index].data);
                         return model!=null
                             ?sourceInfo(model, context)
                             :Container(child: circularProgress(),);

                       }
                       // ItemModel model = ItemModel.fromJson(datasnapshot.data.documents[index].data);
                       // return model!=null
                       //       ?sourceInfo(model, context)
                       //       :Container(child: circularProgress(),);
                     },
                    itemCount: datasnapshot.data.documents.length,
                );
              },
            ),
          ],
        ),

      ),
    );
  }
}
Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  try{
    return InkWell(
      onTap: (){
        Route route = MaterialPageRoute(builder: (c)=> ProductPage(itemmodel:model));
        Navigator.pushReplacement(context, route);
      },
      splashColor: Colors.pink,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child:Container(
          height: 210.0,
          width:  width,
          child: Row(
            children: [
              Image.network(model.thumbnailUrl,width: 140.0,height: 140.0,),
              SizedBox(width: 4.0,),
              Expanded(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 34.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(model.title,style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),
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
                            child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 12.0,fontWeight: FontWeight.bold),),
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
                            child: Text(model.isactivestock,style: TextStyle(color: Colors.blue,fontSize: 12.0,fontWeight: FontWeight.bold),),
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
                        height: 10,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      // heightFactor: .07,
                      child: removeCartFunction==null
                          ? IconButton(
                        icon: Icon(Icons.add_shopping_cart,color: Colors.pinkAccent,),
                        onPressed: (){
                          checkItemInCart(model.shortInfo,context);
                        },
                      )
                          : IconButton(icon: Icon(Icons.remove_shopping_cart,color: Colors.pinkAccent,),
                        onPressed: (){
                          removeCartFunction();
                        },
                      ),

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
Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width*.34,
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10.0),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(offset: Offset(0,5),blurRadius: 10.0,color: Colors.grey[200]),
      ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.network(imgPath,  height: 150.0,width: width*.34,fit: BoxFit.fill,),
    ),
  );
}

void checkItemInCart(String shortInfoAsId, BuildContext context) {

  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsId)
      ?Fluttertoast.showToast(msg: "Item is already in Cart")
      :additemtocart(shortInfoAsId,context);
}
additemtocart(String shortinfoid,BuildContext context){
 List temcartlist = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
 temcartlist.add(shortinfoid);
 EcommerceApp.firestore.collection(EcommerceApp.collectionUser).
 document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
 .updateData({
   EcommerceApp.userCartList:temcartlist
   }).then((value){
     Fluttertoast.showToast(msg: "Item Added to Cart successfully");
     EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,temcartlist);
     Provider.of<CartItemCounter>(context,listen: false).displayresult();
 });
}
