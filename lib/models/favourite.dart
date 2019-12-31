import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:juxtapose/main.dart';
import 'package:juxtapose/models/item.dart';
import 'package:juxtapose/services/favouriteApi.dart';

class Favourite extends ChangeNotifier {


  FavouriteApi _api = getIt<FavouriteApi>();

  String _id;
  String _name;
  List<Item> _items;
  List<Favourite> _favourites;

  Favourite();

  String get name => _name;

  void setName(String value) {
    _name = value;
  }

  @override
  String toString() {
    return 'Favourite{name: $_name, items: $_items}';
  }

  Future addItem(Favourite data) async{
    var result  = await _api.addDocument(json.decode(jsonEncode(data.toJson()))) ;
    _items = data.items;
    notifyListeners();
    return ;

  }

  Future<List<Favourite>> fetchItems() async {
    var result = await _api.getDataCollection();

    _favourites = result.documents
        .map((doc) => Favourite.fromMap(doc.data, doc.documentID))
        .toList();
    return _favourites;
  }

  List<Item> get items => _items;

  void setItems(List<Item> value) {
    _items = value;
  }

  Favourite.fromMap(Map snapshot, String id) {
    _id = id ?? '';
    _name = snapshot['name'];

    var list = snapshot['items'] as List;

    _items = list.map((i)=> Item.fromJson(i)).toList();
  }

  toJson() {
    return {
      "name": name,
      "items": items,
    };
  }


}