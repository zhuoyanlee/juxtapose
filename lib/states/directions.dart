import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:juxtapose/models/item.dart';

class DirectionsModel extends ChangeNotifier {
  String fromAddress;
  String toAddress;

  final List<Item> _items = [];

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
  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  void add(Item item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
