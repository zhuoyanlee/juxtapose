import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juxtapose/components/checkbox.dart';
import 'package:juxtapose/models/item.dart';
import 'package:provider/provider.dart';

import 'package:juxtapose/states/master.dart';

class ChecklistRoute extends StatefulWidget {
  @override
  ChecklistState createState() => ChecklistState();
}

class ChecklistState extends State<ChecklistRoute> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<MasterModel>(context).fetchItems(),
        builder: (context, snapshot) {
          return _listCheckboxes(snapshot);
        });
//    List<Item> items = Provider.of<DirectionsModel>(context).items;
//
//    if(items.isEmpty) {
//      Provider.of<DirectionsModel>(context).fetchItems().then((val){
//        items = val;
//        print('loading items: ${val}');
//      });
//    }
//    print('Items: ${items}');
//
//    return Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [_listCheckboxes(items)]);
//    return _listCheckboxes(items);
//    return Center(child: _listCheckboxes(items));
    // If using it as a page, use Scarffold
//    Scaffold(body: Center(child: _listCheckboxes(items)));
  }

  Widget _listCheckboxes(AsyncSnapshot<List<Item>> snapshot) {
    if (snapshot.hasData) {
      List<Item> items = snapshot.data;

      return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Item item = items[index];

            return Dismissible(
                key: Key(item.id),
                onDismissed: (direction) {
                  setState(() {
                    Provider.of<MasterModel>(context).removeItem(item.id);
                    items.removeAt(index);
                  });
                },
                child: Container(
                    height: 50,
                    color: Colors.amber,
                    child: LabeledCheckbox(
                      label: items[index].description,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      value: item.checked,
                      onChanged: (bool newValue) {
                        setState(() {
                          print('Item updated has ID ${item.id}');
                          item.checked = newValue;
                          Provider.of<MasterModel>(context)
                              .updateItem(item, item.id);
                        });
                      },
                    )));
          });
    } else {
      return CircularProgressIndicator();
    }
  }
}
