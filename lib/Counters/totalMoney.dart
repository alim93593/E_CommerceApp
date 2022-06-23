import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
    double _totalamount = 0;
    double get totalamaount => _totalamount;
  display(double d)async {
     _totalamount=d;
     await Future.delayed(const Duration(milliseconds: 100),(){
       notifyListeners();
     });
  }
}
