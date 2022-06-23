// ignore_for_file: missing_required_param

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId="";
class AdminOrderDetails extends StatelessWidget {
final String orderId ;
final String orderBy;
final String addressId;
AdminOrderDetails({Key key,this.orderId,this.addressId,this.orderBy}):super(key: key);
  @override
  Widget build(BuildContext context) {
    getOrderId = orderId;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionOrders).document(getOrderId)
                .get(),
            builder: (c,snapshot){
              Map datamap;
              if(snapshot.hasData){
                datamap = snapshot.data.data;
              }
              return snapshot.hasData
                  ?Container(
                child: Column(
                  children: [
                    AdminStatusBanner(status: datamap[EcommerceApp.isSuccess],),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "\$ " +datamap[EcommerceApp.totalAmount].toString(),
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text("Order ID "+getOrderId),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text("Ordered AT "+DateFormat("dd MMMM,yyyy - hh:mm aa")
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(datamap["orderTime"]))),
                        style: TextStyle(color: Colors.grey,fontSize: 26.0),
                      ),
                    ),
                    Divider(height: 2.0,),
                    FutureBuilder<QuerySnapshot>(
                      future: EcommerceApp.firestore.collection("items")
                          .where("shortInfo",whereIn:datamap[EcommerceApp.productID])
                          .getDocuments(),
                      builder: (c,datasnapshot){
                        return datasnapshot.hasData
                            ?OrderCard(
                          itemcount: datasnapshot.data.documents.length,
                          data: datasnapshot.data.documents,
                        )
                            :Center(child: circularProgress(),);
                      },
                    ),
                    Divider(height: 2.0,),
                    FutureBuilder<DocumentSnapshot>(
                      future: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .document(orderBy)
                          .collection(EcommerceApp.subCollectionAddress)
                          .document(addressId)
                          .get(),
                      builder: (c,snap){
                        return snap.hasData
                            ?AdminShippingDetails(model: AddressModel.fromJson(snap.data.data),)
                            :Center(child: circularProgress(),);
                      },
                    ),
                  ],
                ),

              )
                  :Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {

  final  bool status;
  AdminStatusBanner({Key key,this.status}):super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg ;
    IconData icondata ;
    status? icondata = Icons.done : icondata = Icons.cancel;
    status? msg = 'Successful' : msg = 'Unsuccessful';
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            "Order Shipped" + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(icondata,color: Colors.white,size: 14.0,),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  final AddressModel model ;
  AdminShippingDetails({Key key ,this.model}):super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child:Text(
            "Shipment Details",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ) ,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0,vertical: 5.0),
          width: screenwidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(msg: "Name",),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Phone Number",),
                  Text(model.phoneNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Flat Number",),
                  Text(model.flatNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "City",),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "State",),
                  Text(model.state),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Pin Code",),
                  Text(model.pincode),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap:  (){
                confirmParselShiftted(context,getOrderId);
              },
              child: Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Colors.pink, Colors.lightGreenAccent],
                        begin: const FractionalOffset(0.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
                width: MediaQuery.of(context).size.width -40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Confirm || Parsel Shifted",
                    style: TextStyle(color: Colors.white,fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],

    );
  }
  void confirmParselShiftted(BuildContext context, String myorderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(myorderId)
        .delete();
    getOrderId ="";

    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: "Parcel has been Shifted. Confirmed");
  }

}
