import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/login.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nametexteditingcontrolloer =
  new TextEditingController();
  final TextEditingController _emailtexteditingcontrolloer =
  new TextEditingController();
  final TextEditingController _passwordtexteditingcontrolloer =
  new TextEditingController();
  final TextEditingController _cpasswordtexteditingcontrolloer =
  new TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imagefile;
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width;
    // double _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: SizedBox(
                height: 30,
              ),
            ),
            InkWell(
              onTap: () {
                _selectAndPickImage();
              },
              child: CircleAvatar(
                  radius: _screenwidth * 0.15,
                  backgroundColor: Colors.white,
                  backgroundImage:
                  _imagefile == null ? null : FileImage(_imagefile),
                  child: _imagefile == null
                      ? Icon(
                    Icons.add_photo_alternate,
                    size: _screenwidth * 0.15,
                    color: Colors.grey,
                  )
                      : null),
            ),
            SizedBox(
              height: 40.0,
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nametexteditingcontrolloer,
                      data: Icons.person,
                      hintText: "Name",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _emailtexteditingcontrolloer,
                      data: Icons.email,
                      hintText: "Email",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordtexteditingcontrolloer,
                      data: Icons.password_outlined,
                      hintText: "Password",
                      isObsecure: true,
                    ),
                    CustomTextField(
                      controller: _cpasswordtexteditingcontrolloer,
                      data: Icons.password_outlined,
                      hintText: "Confirm Password",
                      isObsecure: true,
                    ),
                  ],
                )),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              color: Colors.pink,
              child: Text(
                "Sign up",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenwidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _selectAndPickImage() async {
    // ignore: deprecated_member_use
    _imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  Future<void> uploadAndSaveImage() async {
    if (_imagefile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please Select An Image",
            );
          });
    } else {
      _passwordtexteditingcontrolloer.text ==
          _cpasswordtexteditingcontrolloer.text
          ? _emailtexteditingcontrolloer.text.isNotEmpty &&
          _passwordtexteditingcontrolloer.text.isNotEmpty &&
          _cpasswordtexteditingcontrolloer.text.isNotEmpty &&
          _nametexteditingcontrolloer.text.isNotEmpty
          ? uploadToStorage()
          : displaydialog('Please fill up the registration complete form..')
          : displaydialog('Password do not match..');
    }
  }
  displaydialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: msg);
        });
  }
  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Registration, Please wait.....',
          );
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storagerefrence = FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask stoargeuploadtask = storagerefrence.putFile(_imagefile);
    StorageTaskSnapshot tasksanpshot = await stoargeuploadtask.onComplete;
    // ignore: non_constant_identifier_names
    await tasksanpshot.ref.getDownloadURL().then((UrlImage) {
      userImageUrl = UrlImage;
      print(UrlImage);
      _registerUser();
    });
  }
  FirebaseAuth _auth =  FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseuser;
    await _auth.createUserWithEmailAndPassword(
      email: _emailtexteditingcontrolloer.text.trim(),
      password: _passwordtexteditingcontrolloer.text.trim(),).then((auth) {
      firebaseuser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            print(error.toString());
            return ErrorAlertDialog(
              message: "This User Already Used",);
          });
    });
    if(firebaseuser != null){
      // await FirebaseAuth.instance.signInAnonymously();
        saveUserInfoToFireStore(firebaseuser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c)=> Login());
        Navigator.pushReplacement(context, route);
      });
    }
  }
  Future saveUserInfoToFireStore(FirebaseUser fUser)async{
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid":fUser.uid,
      "email":fUser.email,
      "name":_nametexteditingcontrolloer.text.trim(),
      "url":userImageUrl,
      EcommerceApp.userCartList:["garbageValue"]
    });
    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nametexteditingcontrolloer.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,["garbageValue"] );
  }
}
