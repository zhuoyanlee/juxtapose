import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juxtapose/components/checkbox.dart';
import 'package:juxtapose/enums/listType.dart';
import 'package:juxtapose/models/favourite.dart';
import 'package:juxtapose/models/item.dart';
import 'package:provider/provider.dart';

import 'package:juxtapose/states/master.dart';

class FavouriteRoute extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<FavouriteRoute>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animateIcon;

  Animation<double> _translateButton;
  bool isOpened = false;

  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
//    super.initState();
  }

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
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end, // to fix onPressed() issue
            children: [
                  Transform(
                    transform: Matrix4.translationValues(
                      0.0,
                      _translateButton.value * 3.0,
                      0.0,
                    ),
                    child: addToList(ListType.DEFAULT, Icons.shopping_basket),
                  ),
//              Transform(
//                transform: Matrix4.translationValues(
//                  0.0,
//                  _translateButton.value * 3.0,
//                  0.0,
//                ),
//                child: addToList(ListType.ASIAN, Icons.accessibility),
//              ),
              Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * 3.0,
                  0.0,
                ),
                child: addToList(ListType.ALDI, Icons.shutter_speed),
              ),
              Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * 3.0,
                  0.0,
                ),
                child: addToList(ListType.COSTCO, Icons.attach_money),
              ),

              toggle(),
                ]),
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

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;

  }
  Widget addToList(String listType, final IconData iconType) {
    return FloatingActionButton(
heroTag: null,
        mini: true,
        onPressed: () {
          MasterModel model = Provider.of<MasterModel>(context);
          Favourite selected = model.selectedFavourite;
          for(Item item in selected.items) {
            item.name = listType;
            item.checked = false;
            model.addItem(item);
          }
          Navigator.pushNamed(context, '/');
        },
        tooltip: 'Add to ${listType} List',
        child: Icon(iconType),

      );
  }
  Widget toggle() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.amber,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  _displaySaveListDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Copy items to'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: "List Name"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SAVE'),
                onPressed: () {
                  Favourite newFavourite = new Favourite();
                  newFavourite
                      .setItems(Provider.of<MasterModel>(context).items);
                  newFavourite.addItem(newFavourite);
                  print('Favourite ${newFavourite}');

                  Navigator.pushNamed(context, '/');
                },
              ),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
