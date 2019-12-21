import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:juxtapose/models/item.dart';

class ChecklistModel extends ChangeNotifier {

  final List<Item> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  void add(Item item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

}
