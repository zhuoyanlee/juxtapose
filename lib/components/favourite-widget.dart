import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juxtapose/components/checkbox.dart';
import 'package:juxtapose/models/favourite.dart';
import 'package:juxtapose/models/item.dart';
import 'package:provider/provider.dart';

import 'package:juxtapose/states/master.dart';

class FavouriteRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MasterModel master = Provider.of<MasterModel>(context);

    Favourite selectedFavourite = master.selectedFavourite;
    List<Item> items = selectedFavourite.items;

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('${master.selectedFavourite.name} saved list'),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final Item item = items[index];

              return Dismissible(
                  key: Key(item.id),
                  child: Container(
                      height: 50,
                      color: Colors.amber,
                      child: ListTile(
                        title: Text(items[index].description),
                      )));
            }));
  }


}
