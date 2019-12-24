import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juxtapose/components/checkbox.dart';
import 'package:juxtapose/models/item.dart';
import 'package:provider/provider.dart';

import 'package:juxtapose/states/directions.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class ChecklistRoute extends StatefulWidget {
  @override
  ChecklistState createState() => ChecklistState();
}

class ChecklistState extends State<ChecklistRoute> {
  @override
  Widget build(BuildContext context) {
    List<Item> items = Provider.of<DirectionsModel>(context).items;
    print('Items: ${items}');

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_listCheckboxes(items)]);
//    return _listCheckboxes(items);
//    return Center(child: _listCheckboxes(items));
    // If using it as a page, use Scarffold
//    Scaffold(body: Center(child: _listCheckboxes(items)));
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
                  setState(() {
                    items[index].checked = newValue;
                  });
                },
              ));
        });
  }
}
