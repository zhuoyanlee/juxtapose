import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:juxtapose/locator.dart';
import 'package:juxtapose/main.dart';
import 'package:juxtapose/models/item.dart';
import 'package:juxtapose/services/api.dart';

class DirectionsModel extends ChangeNotifier {

  DirectionsModel() {

  }

  Api _api = getIt<Api>();


  String fromAddress;
  String toAddress;

  String listName = 'default';
  List<Item> _items = [];

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
    var result = await _api.getDataCollection();
    _items = result.documents
        .where((x)=> x.data['name']==this.listName)
        .map((doc) => Item.fromMap(doc.data, doc.documentID))
        .toList();
    return _items;
  }

  Stream<QuerySnapshot> fetchItemsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Item> getItemById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Item.fromMap(doc.data, doc.documentID) ;
  }


  Future removeItem(String id) async{
    await _api.removeDocument(id) ;
    notifyListeners();
    return ;
  }
  Future updateItem(Item data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    notifyListeners();
    return ;
  }

  Future addItem(Item data) async{
    var result  = await _api.addDocument(data.toJson()) ;
    _items.add(data);
    notifyListeners();
    return ;

  }
}
