import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';


class ProductPage extends StatefulWidget {

  final ItemModel itemmodel;
  ProductPage({this.itemmodel});
  @override
  _ProductPageState createState() => _ProductPageState();
}
class _ProductPageState extends State<ProductPage> {
  int quantityofitems = 1;
  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(40.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemmodel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.itemmodel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.itemmodel.longDescription,
                            // style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          widget.itemmodel.discount!=0
                              ?Text(
                           r"$ "+ widget.itemmodel.price.toString(),
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, decoration: TextDecoration.lineThrough),
                          )
                           :Text(
                            r"$ "+ widget.itemmodel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          widget.itemmodel.discount!=0
                          ?Text(
                            r"$ "+ (widget.itemmodel.price-( widget.itemmodel.discount*widget.itemmodel.price/100)) .toString(),
                            style: boldTextStyle,
                          )
                          :Text(
                          ''
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 0.0),
                    child: Center(
                      child: InkWell(
                        onTap: ()=>checkItemInCart(widget.itemmodel.shortInfo, context),
                        child: Container(
                          decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [Colors.pink, Colors.lightGreenAccent],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp)),
                          width: MediaQuery.of(context).size.width-40.0,
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Add To Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
