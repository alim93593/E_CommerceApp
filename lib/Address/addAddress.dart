// ignore_for_file: unused_import

import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  final scfldformkey = GlobalKey<ScaffoldState>();
  final cname = TextEditingController();
  final cphonenumber = TextEditingController();
  final cfalthomenumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPincode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scfldformkey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              if(formkey.currentState.validate()){
                final model = AddressModel(
                  name: cname.text.trim(),
                  city: cCity.text.trim(),
                  state: cState.text.trim(),
                  phoneNumber: cphonenumber.text,
                  flatNumber: cfalthomenumber.text,
                  pincode: cPincode.text
                ).toJson();
                EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                    .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                    .collection(EcommerceApp.subCollectionAddress)
                    .document(DateTime.now().toString())
                    .setData(model).then((value) {
                      final snack = SnackBar(content: Text("New Address Added Successfully"));
                      // ignore: deprecated_member_use
                      scfldformkey.currentState.showSnackBar(snack);
                      FocusScope.of(context).requestFocus(FocusNode());
                      formkey.currentState.reset();
                });
                Route route = MaterialPageRoute(builder: (c) => StoreHome());
                Navigator.pushReplacement(context, route);
              }
            },
            label: Text("Done"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Add New Address',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
                ),
              ),
              Form(
                  key: formkey,
                  child: Column(
                    children: [
                      MyTextField(
                        hint: "Name",
                        controller: cname,
                      ),
                      MyTextField(
                        hint: "Phone Number",
                        controller: cphonenumber,
                      ),
                      MyTextField(
                        hint: "House Number",
                        controller: cfalthomenumber,
                      ),
                      MyTextField(
                        hint: "City",
                        controller: cCity,
                      ),
                      MyTextField(
                        hint: "State / Country",
                        controller: cState,
                      ),
                      MyTextField(
                        hint: "PinCode",
                        controller: cPincode,
                      )
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MyTextField extends StatelessWidget {
final String hint;
final TextEditingController controller;
MyTextField({Key key, this.hint,this.controller}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val)=>val.isEmpty ? "Field Cnnot Be Empty":null,
      ),

    );
  }
}
