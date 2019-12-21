import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juxtapose/components/checkbox.dart';
import 'package:juxtapose/models/item.dart';
import 'package:provider/provider.dart';

import 'package:juxtapose/states/directions.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class ChecklistRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Item> items = Provider
        .of<DirectionsModel>(context)
        .items;
    print('Items: ${items}');

    return Scaffold(
        body: Center(
            child: _listCheckboxes(items)));

//    return ListView.builder(
//        padding: const EdgeInsets.all(8),
//        itemCount: items.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
//          return Container(
//            height: 50,
//            color: Colors.amber,
//            child: Center(child: Text('Entry ${items[index]}')),
//          );
//        });
  }

  ListView _listCheckboxes(List<Item> items) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber,
            child: LabeledCheckbox(
                label: items[index].description,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                value: items[index].checked,
                onChanged: (bool newValue) {
                  items[index].checked = newValue;
                },
          ));
        });
  }
}

