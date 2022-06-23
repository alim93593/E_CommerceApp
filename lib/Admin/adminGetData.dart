
// ignore_for_file: avoid_web_libraries_in_flutter, non_constant_identifier_names, duplicate_ignore

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'adminSearch.dart';
import 'adminShiftOrders.dart';
 String getproductId="";
class AdminGetProduct extends StatefulWidget {
  final ItemModel itemmodel;
  final String  productId;
  AdminGetProduct({Key key,this.itemmodel,this.productId}):super(key: key);
  @override
  _AdminGetProductState createState() => _AdminGetProductState();

}
class _AdminGetProductState extends State<AdminGetProduct> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptiontexteditingcontroller = new TextEditingController();
  TextEditingController _pricetexteditingcontroller = new TextEditingController();
  TextEditingController _titletexteditingcontroller = new TextEditingController();
  TextEditingController _shortinfotexteditingcontroller = new TextEditingController();
  TextEditingController _discounttexteditingcontroller = new TextEditingController();
  TextEditingController _activitytexteditcontrolloer = new TextEditingController();
  TextEditingController _offertrialcontrolloer = new TextEditingController();
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    _discounttexteditingcontroller.text=widget.itemmodel.discount.toString();
    _activitytexteditcontrolloer.text = widget.itemmodel.isactivestock.trim();
    _pricetexteditingcontroller.text=widget.itemmodel.price.toString();
    _titletexteditingcontroller.text = widget.itemmodel.title.trim();
    _descriptiontexteditingcontroller.text = widget.itemmodel.longDescription.trim();
    _shortinfotexteditingcontroller.text =  widget.itemmodel.shortInfo.trim();
    _offertrialcontrolloer.text = widget.itemmodel.offertrial.toString();

  }
  @override
  Widget build(BuildContext context) {
    getproductId = widget.productId.toString();
    // return getproductId==null? displayAdminHomeScreen() : displayadminUploadFromscreen();
    return SafeArea(
      child: Scaffold(
        body: displayadminUploadFromscreen(),
      ),
    );
  }
  takeImage( mcontext) {
    return showDialog(
        context: mcontext,
        builder: (con){
          return SimpleDialog(
            title: Text('Item Image',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                child: Text('Capture with Camera',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                onPressed: capturePhotowithCamera,
              ),
              SimpleDialogOption(
                child: Text('Selelct from Camera',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                onPressed: pickPhotofromGallery,
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
  void capturePhotowithCamera()async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File imagefile =  await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680.0,maxWidth: 970.0);
    setState(() {
      file = imagefile;
    });
  }
  void pickPhotofromGallery() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File imagefile =  await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imagefile;
    });
  }
  getAdminHomeScreenBody() {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two,color: Colors.white,size: 200.0,),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                child: Text('Add New Items',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                color: Colors.green,
                onPressed: ()=> takeImage(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                child: Text('Update Items',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                color: Colors.green,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c)=> AdminSearchPage());
                  Navigator.pushReplacement(context, route);
                  // onPressed: ()=> takeImage(context),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.pink, Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        // ignore: deprecated_member_use
        actions: [FlatButton(
          child: Text("Logout",style: TextStyle(color: Colors.pink,fontSize: 16.0,fontWeight: FontWeight.bold),),
          onPressed: (){
            Route route = MaterialPageRoute(builder: (c) => SplashScreen());
            Navigator.pushReplacement(context, route);
          },
        )],
      ),
      body: getAdminHomeScreenBody(),
    );
  }
  displayadminUploadFromscreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.pink, Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        } ,),
        title: Text('Update Product',style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
            // onPressed: ()=> print(file.toString()),
            onPressed:uploading?null:()=>uploadiamgeandsaveiteminfo(),
            child: Text('Update',style: TextStyle(color: Colors.pink,fontSize: 16.0,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
      body: ListView(
        // padding: EdgeInsets.all(10.0),
        children: [
          uploading ? circularProgress():Text(''),
          SizedBox(height: 10,),
          Container(
            height: 190.0,
            width: MediaQuery.of(context).size.width *0.8,
            child: InkWell(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    child: Image.network(widget.itemmodel.thumbnailUrl),
                  ),
                ),
              ),
              onTap: ()=> takeImage(context),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240.0,
              child: TextField(

                controller: _shortinfotexteditingcontroller,
                decoration: InputDecoration(
                  // hintText: "Short Info",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,thickness: 2,),
          ListTile(
            leading: Icon(Icons.title,color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _titletexteditingcontroller,
                decoration: InputDecoration(
                  // hintText: "Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,thickness: 2,),
          ListTile(
            leading: Icon(Icons.description,color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _descriptiontexteditingcontroller,
                decoration: InputDecoration(
                  // hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,thickness: 2,),
          ListTile(
            leading: Icon(Icons.price_change,color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _pricetexteditingcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,thickness: 2,),
          ListTile(
            leading: Icon(Icons.price_change,color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                controller:_discounttexteditingcontroller.text!=null
                    ?_discounttexteditingcontroller
                    :0,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // hintText: "Discount",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,thickness: 2,),
          ListTile(
            leading: Icon(Icons.date_range,color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                controller:_offertrialcontrolloer,
                decoration: InputDecoration(
                  // hintText: "Offer Trial",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,thickness: 2,),
          ListTile(
            leading: Icon(Icons.info,color: Colors.pink,),
            title: Container(
              width: 240.0,
              child: TextField(
                controller: _activitytexteditcontrolloer,
                decoration: InputDecoration(
                  // hintText: "Status Of Stock",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,thickness: 2,),
        ],
      ),
    );
  }
  // ignore: duplicate_ignore
  uploadiamgeandsaveiteminfo()async {
    setState(() {
      uploading = true;
    });
    // ignore: non_constant_identifier_names
    if(file == null){
      saveItemInfowithoutImage();
    }else{
      String ImageDownloadUrl=await upLoadItemImage(file);
      saveItemInfo(ImageDownloadUrl);
    }
    Route route = MaterialPageRoute(builder: (c) => AdminSearchPage());
    Navigator.pushReplacement(context, route);
  }
  Future<String>  upLoadItemImage(mFileImage)async {
    final StorageReference stoargerefrenece = FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask = stoargerefrenece.child("product_$getproductId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  // String downloadurl
  saveItemInfo(String downloadurl){
      print(getproductId);
      final itemref = Firestore.instance.collection("items");
      itemref.document(getproductId).updateData({
      "shortInfo":_shortinfotexteditingcontroller.text.trim(),
      "LongDescription":_descriptiontexteditingcontroller.text.trim(),
      "price":int.parse(_pricetexteditingcontroller.text),
      "publishedDate":DateTime.now(),
      "status":"avalible",
      "thumbnailUrl":downloadurl!= null?downloadurl:widget.itemmodel.thumbnailUrl,
      "title":_titletexteditingcontroller.text.trim(),
      "discount":_discounttexteditingcontroller.text!= ""
          ?int.parse(_discounttexteditingcontroller.text):0,
      "isactivestock":_activitytexteditcontrolloer.text.trim(),
      "offertrial":_offertrialcontrolloer.text!= ""
            ?int.parse(_offertrialcontrolloer.text):0,
    }).then((value) =>
          Fluttertoast.showToast(msg: "Item Have Been Updated"));
    setState(() {
       file = null;
       uploading =false;
       getproductId =null;
      _descriptiontexteditingcontroller.clear();
      _titletexteditingcontroller.clear();
      _shortinfotexteditingcontroller.clear();
      _pricetexteditingcontroller.clear();
      _discounttexteditingcontroller.clear();
      _activitytexteditcontrolloer.clear();
    });
  }
  saveItemInfowithoutImage(){
    final itemref = Firestore.instance.collection("items");
    itemref.document(getproductId).updateData({
      "shortInfo":_shortinfotexteditingcontroller.text.trim(),
      "LongDescription":_descriptiontexteditingcontroller.text.trim(),
      "price":int.parse(_pricetexteditingcontroller.text),
      "publishedDate":DateTime.now(),
      "status":"avalible",
      "title":_titletexteditingcontroller.text.trim(),
      "discount":_discounttexteditingcontroller.text!= ""
          ?int.parse(_discounttexteditingcontroller.text):0,
      "isactivestock":_activitytexteditcontrolloer.text.trim(),
      "offertrial":_offertrialcontrolloer.text!= ""
          ?int.parse(_offertrialcontrolloer.text):0,
    }).then((value) =>
        Fluttertoast.showToast(msg: "Item Have Been Updated"));
    setState(() {
      file = null;
      uploading =false;
      getproductId =null;
      _descriptiontexteditingcontroller.clear();
      _titletexteditingcontroller.clear();
      _shortinfotexteditingcontroller.clear();
      _pricetexteditingcontroller.clear();
      _discounttexteditingcontroller.clear();
      _activitytexteditcontrolloer.clear();
    });
  }
  clearFormInfo() {
    setState(() {
      _pricetexteditingcontroller.clear();
      _descriptiontexteditingcontroller.clear();
      _titletexteditingcontroller.clear();
      _shortinfotexteditingcontroller.clear();
      _discounttexteditingcontroller.clear();
      _activitytexteditcontrolloer.clear();
      getproductId =null;
    });
  }
}
const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);