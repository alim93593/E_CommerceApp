import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Orders/OrderDetailsPage.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

int counter =0;
class OrderCard extends StatelessWidget {
  final int itemcount;
  final List<DocumentSnapshot> data;
  final String orderId;
  OrderCard({Key key,this.itemcount,this.data,this.orderId}):super(key:key);


  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Route route;
        if(counter==0){
          counter = counter+1;
          route = MaterialPageRoute(builder: (c)=>OrderDetails(orderId:orderId));
        }
        Navigator.push(context, route);
    },
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemcount*190.0,
        child: ListView.builder(
          itemCount: itemcount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c,index){
            ItemModel modeL = ItemModel.fromJson(data[index].data);
            return  sourceOrderInfo(modeL,context);
          },
        ),
      ),
    );
  }
}
Widget sourceOrderInfo(ItemModel model, BuildContext context,{Color background})
{
  width =  MediaQuery.of(context).size.width;
  return  Container(
    color: Colors.grey[100],
    height: 180.0,
    width:  width,
    child: Row(
      children: [
        Image.network(model.thumbnailUrl,width: 130.0,),
        SizedBox(width: 10.0,),
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
                      child: Text(model.title,style: TextStyle(color: Colors.black,fontSize: 21.0,fontWeight: FontWeight.bold),),
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
                      child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 20.0),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Row(
                children: [
                  SizedBox(width: 10.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,left: 1.0,right: 0.0),
                        child: Row(
                          children: [
                            Text(
                              r"Total Price: ",
                              style: TextStyle(fontSize: 24.0,color: Colors.grey),

                            ),
                            Text(
                              r"$ ",
                              style:TextStyle(fontSize: 16.0,color: Colors.red) ,
                            ),
                            Text(
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
              Divider(height:25.0,color: Colors.pink,),
              Flexible(
                child: Container(

                ),
              ),
              // Divider(height:5.0,color: Colors.pink,),
            ],
          ) ,
        ),

      ],
    ),

  );
}
