
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:convert';

import 'package:juxtapose/models/item.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  static Future<List<Item>> getItems() async {
    Completer<List<Item>> completer = new Completer<List<Item>>();

    List<Item> bookings = new List<Item>();

    FirebaseDatabase.instance
        .reference()
        .child("items")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> yearMap = snapshot.value;
      yearMap.forEach((key, value) {
        bookings.add(Item.fromJson(key, value));
      });

      completer.complete(bookings);
    });

    return completer.future;
  }


  void getData() {
    _db.reference().once().then((DataSnapshot snapshot) {

//      print('Data : ${snapshot.value}');


    });
  }

  static void createRecord(description, checked) {
    FirebaseDatabase.instance
        .reference().child("items").push().set({
      'id': 1234,
      'description': description,
      'checked': checked
    });
  }
}
