import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:juxtapose/enums/listType.dart';
import 'package:juxtapose/main.dart';
import 'package:juxtapose/models/favourite.dart';
import 'package:juxtapose/models/item.dart';
import 'package:juxtapose/services/favouriteApi.dart';
import 'package:juxtapose/services/itemsApi.dart';

class MasterModel extends ChangeNotifier {

  ItemsApi _itemsApi = getIt<ItemsApi>();
  FavouriteApi _favouriteApi = getIt<FavouriteApi>();

  String fromAddress;
  String toAddress;

  String listName = ListType.DEFAULT;
  List<Item> _items = [];
  List<Favourite> _favourites = [];
  Favourite selectedFavourite;

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

  String getListName() {
    return listName;
  }

  void setListName(String value) {
    this.listName = value;
    notifyListeners();
  }

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  Future<List<Item>> fetchItems() async {
    var result = await _itemsApi.getDataCollection();

    _items = result.documents
        .where((x)=> x.data['name']==this.listName)
        .map((doc) => Item.fromMap(doc.data, doc.documentID))
        .toList();
    return _items;
  }

  Stream<QuerySnapshot> fetchItemsAsStream() {
    return _itemsApi.streamDataCollection();
  }

  Future<Item> getItemById(String id) async {
    var doc = await _itemsApi.getDocumentById(id);
    return  Item.fromMap(doc.data, doc.documentID) ;
  }


  Future removeItem(String id) async{
    await _itemsApi.removeDocument(id) ;
    notifyListeners();
    return ;
  }
  Future updateItem(Item data,String id) async{
    await _itemsApi.updateDocument(data.toJson(), id) ;
    notifyListeners();
    return ;
  }

  Future addItem(Item data) async{
    var result  = await _itemsApi.addDocument(data.toJson()) ;
    _items.add(data);
    notifyListeners();
    return ;
  }

  /*
  Favourites API
   */

  Future addFavourite(Favourite data) async{
    var result  = await _favouriteApi.addDocument(json.decode(jsonEncode(data.toJson()))) ;
    _favourites.add(data);
    notifyListeners();
    return ;

  }

  Future<List<Favourite>> fetchFavourites() async {
    var result = await _favouriteApi.getDataCollection();

    _favourites = result.documents
        .map((doc) => Favourite.fromMap(doc.data, doc.documentID))
        .toList();

    print('list of favourites ${_favourites}');

    return _favourites;
  }
}
