import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: (){
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
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
      bottom: bottom,
      actions: [
        // IconButton(
        //   icon: Icon(Icons.arrow_drop_down_circle,color: Colors.white,),
        //   onPressed: (){
        //     Route route = MaterialPageRoute(builder: (c) => StoreHome());
        //     Navigator.pushReplacement(context, route);
        //     // SystemNavigator.pop();
        //   },
        // ),
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
                        (EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),
                        style: TextStyle(color: Colors.white,fontSize: 12.0,fontWeight: FontWeight.w500),
                      );
                    },
                  ),),
              ],
            ))
          ],
        ),
      ],
    );

  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
