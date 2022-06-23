import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';


class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.pink, Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp
              )),
        ),
        title: Text('e-shop',style: TextStyle(
            fontSize: 55.0,
            color: Colors.white,
            fontFamily: "Signatra"
        ),),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}
class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController _adminIDtexteditingcontrolloer =  new TextEditingController();
  final TextEditingController _passwordtexteditingcontrolloer = new TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width;
    // double _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp
            )),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset(
                'images/admin.png',
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(color: Colors.white,fontSize: 28.0,fontWeight: FontWeight.bold),
              ),
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _adminIDtexteditingcontrolloer,
                      data: Icons.person,
                      hintText: "Id",
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
            SizedBox(
              height: 50.0,
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                _adminIDtexteditingcontrolloer.text.trim().isNotEmpty &&
                    _passwordtexteditingcontrolloer.text.trim().isNotEmpty
                    ? LoginAdmin()
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
              height: 20.0,
            ),
            // ignore: deprecated_member_use
            FlatButton.icon(
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => AuthenticScreen());
                  Navigator.pushReplacement(context, route);
                },
                icon: Icon(
                  Icons.nature_people,
                  color: Colors.pink,
                ),
                label: Text(
                  'Iam Not ADMIN',
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
  // ignore: non_constant_identifier_names
  LoginAdmin(){
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data["id"]!= _adminIDtexteditingcontrolloer.text.trim()){
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your ID is not correct")));
        }
        else if(result.data["password"]!= _passwordtexteditingcontrolloer.text.trim()){
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your Password is not correct")));
        }else{
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin" + result.data['name'])));
          setState(() {
            _adminIDtexteditingcontrolloer.text = "";
            _passwordtexteditingcontrolloer.text ="";
          });
          Route route = MaterialPageRoute(builder: (c)=> UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });

  }
}
