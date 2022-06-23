import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailtexteditingcontrolloer =  new TextEditingController();
  final TextEditingController _passwordtexteditingcontrolloer =  new TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width;
    // double _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset(
                'images/login.png',
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Login to your Account",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
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
                  ],
                )),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                _emailtexteditingcontrolloer.text.trim().isNotEmpty &&
                    _passwordtexteditingcontrolloer.text.trim().isNotEmpty
                    ? LoginUser()
                    : showDialog(
                    context: context,
                    builder: (c) {
                      return ErrorAlertDialog(
                        message: "Please write email and password",
                      );
                    });
              },
              color: Colors.pink,
              child: Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenwidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 10.0,
            ),
            // ignore: deprecated_member_use
            FlatButton.icon(
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => AdminSignInPage());
                Navigator.pushReplacement(context, route);
              },
                // onPressed: () => Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => AdminSignInPage())),
                icon: Icon(
                  Icons.nature_people,
                  color: Colors.pink,
                ),
                label: Text(
                  'Iam  ADMIN',
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: non_constant_identifier_names
  void LoginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating, Please wait.....",
          );
        });
    FirebaseUser firebaseuser;
    try{
      await _auth.signInWithEmailAndPassword(
          email: _emailtexteditingcontrolloer.text.trim(),
          password: _passwordtexteditingcontrolloer.text.trim()).then((authUser){
        firebaseuser = authUser.user;

      }).catchError((error){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "Password Or Email Is worng.",);
            });
        print(_auth);
        // builder: (c) {
        //   return ErrorAlertDialog(
        //     message: "Password Or Email Is worng.",);
        //
        // });
      });
      if(firebaseuser != null){
        readData(firebaseuser).then((s){
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c)=> StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }
    }
    catch (e){
      print(e.toString());
    }

  }
  Future readData(FirebaseUser fuser) async{
    Firestore.instance.collection("users").document(fuser.uid).get().then((datasnapshot) async{
    await EcommerceApp.sharedPreferences.setString("uid", datasnapshot.data[EcommerceApp.userUID]);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,datasnapshot.data[EcommerceApp.userEmail]);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, datasnapshot.data[EcommerceApp.userName]);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, datasnapshot.data[EcommerceApp.userAvatarUrl]);

    List<String>cartlist = datasnapshot.data[EcommerceApp.userCartList].cast<String>();
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartlist);

    });

  }
}
