import 'package:flutter/cupertino.dart';

class DirectionsModel extends ChangeNotifier {
  String fromAddress;
  String toAddress;

  void updateAddress(String from, String to) {
    this.fromAddress = from;
    this.toAddress = to;
    notifyListeners();
  }
  void setFromAddress(String value) {
    this.fromAddress = value;
    notifyListeners();
  }

  void setToAddress(String value) {
    this.toAddress = value;
    notifyListeners();
  }
}
