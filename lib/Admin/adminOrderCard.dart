import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderDetails.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';

int counter=0;
class AdminOrderCard extends StatelessWidget
{
  final int itemcount;
  final List<DocumentSnapshot> data;
  final String orderId;
  final String orderby;
  final String addressid;
  AdminOrderCard({Key key ,this.itemcount,this.data,this.orderId,this.orderby,this.addressid}):super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return  InkWell(
      onTap: (){
        Route route;
        if(counter==0){
          counter = counter+1;
          route = MaterialPageRoute(builder: (c)=>AdminOrderDetails(orderId:orderId,orderBy:orderby,addressId:addressid));
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
