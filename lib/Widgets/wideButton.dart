import 'package:flutter/material.dart';


class WideButton extends StatelessWidget {
  final String message;
  final Function onpressed;

  WideButton({Key key,this.message,this.onpressed}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:10.0,bottom: 10.0,),
      child: Center(
        child: InkWell(
          onTap: onpressed,
          child:Container(
            decoration: BoxDecoration(
              color: Colors.pink
            ),
            width: MediaQuery.of(context).size.width *0.85,
            height: 50.0,
            child: Center(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
