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
  }

  Widget _listCheckboxes(AsyncSnapshot<List<Item>> snapshot) {
    if (snapshot.hasData) {
      List<Item> items = snapshot.data;

      return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          itemCount: items.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Item item = items[index];

            return Dismissible(
                key: Key(item.id),
                direction: DismissDirection.startToEnd,
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
