import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:juxtapose/components/booking-form.dart';
import 'package:juxtapose/components/checklist-widget.dart';
import 'package:juxtapose/components/favourite-widget.dart';
import 'package:juxtapose/enums/listType.dart';
import 'package:juxtapose/models/favourite.dart';
import 'package:juxtapose/services/api.dart';
import 'package:juxtapose/models/item.dart';
import 'package:juxtapose/models/post.dart';
import 'dart:convert';
import 'package:juxtapose/components/maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:juxtapose/services/favouriteApi.dart';
import 'package:juxtapose/services/itemsApi.dart';
import 'package:juxtapose/states/master.dart';
import 'package:provider/provider.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() {
  DotEnv().load('.env');

  getIt.registerSingleton<ItemsApi>(ItemsApi());
  getIt.registerSingleton<FavouriteApi>(FavouriteApi());
  getIt.registerFactory(() => MasterModel());
  getIt.registerFactory(() => Favourite());

//  getIt.registerSingleton<DirectionsModel>(DirectionsModel(),signalsReady:true);
  runApp(ChangeNotifierProvider(
    builder: (context) => MasterModel(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Juxtapose',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.amber,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/booking': (context) => BookingForm(),
          '/gmap': (context) => MapRoute(),
          '/checklist': (context) => ChecklistRoute(),
          '/favourite': (context) => FavouriteRoute(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  TextEditingController _saveListController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    _currentIndex =
        ListType.getIndexByListName(Provider.of<MasterModel>(context).listName);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Consumer<MasterModel>(builder: (context, master, child) {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('${master.listName} shopping list'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (value) {
                //print the selected option
                print(value);

                // Save list pressed
                if (value == 0) {
                  _displaySaveListDialog(context);
                }

                //Update the current choice.
                //However, this choice won't be updated in body section since it's a Stateless widget.
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 0,
                  child: Text('Save list'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('Clear list'),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onNavigationTabTapped,
          // new
          selectedItemColor: Colors.amber,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.shopping_basket),
              title: new Text(ListType.DEFAULT),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.accessibility),
              title: new Text(ListType.ASIAN),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shutter_speed),
              title: Text(ListType.ALDI),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              title: Text(ListType.COSTCO),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_travel),
              title: Text(ListType.OTHER),
            )
          ],
        ),
        drawer: FutureBuilder(
            future: master.fetchFavourites(),
            builder: (context, snapshot) {
              return _listFavourites(snapshot);
            }),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[ChecklistRoute()],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return AddItemForm();
                  },
                  fullscreenDialog: false,
                ));
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  Widget _listFavourites(AsyncSnapshot<List<Favourite>> snapshot) {
    final ThemeData theme = Theme.of(context);
    MasterModel master = Provider.of<MasterModel>(context);

    if (snapshot.hasData) {
      List<Favourite> favourites = snapshot.data;

      List<Widget> tilesList = [];
      tilesList.add(DrawerHeader(
        child: Text('Shopping Lists'),
        decoration: BoxDecoration(
          color: theme.primaryColor,
        ),
      ));

      for (Favourite fav in favourites) {
        ListTile tile = new ListTile(
            title: Text(fav.name),
            onTap: () {
              master.selectedFavourite = fav;
              print('navigate to favourites');
              Navigator.pushNamed(context, '/favourite');
              print('Complete navigate to favourites');
            });
        tilesList.add(tile);
      }
      ListView.builder(
          itemCount: favourites.length,
          itemBuilder: (context, index) {
            final fav = favourites[index];

            return ListTile(
                title: Text(fav.name),
                onTap: () {
                  master.selectedFavourite = fav;
                  print('navigate to favourites');
                  Navigator.pushNamed(context, '/favourite');
                  print('Complete navigate to favourites');
                });
          });
      return Drawer(
        child: ListView.builder(
            itemCount: favourites.length,
            itemBuilder: (context, index) {
              final fav = favourites[index];

              return ListTile(
                  title: Text(fav.name),
                  onTap: () {
                    master.selectedFavourite = fav;
                    print('navigate to favourites');
                    Navigator.pushNamed(context, '/favourite');
                    print('Complete navigate to favourites');
                  });
            }),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  void _onNavigationTabTapped(int index) {
    setState(() {
      Provider.of<MasterModel>(context)
          .setListName(ListType.getListNameByIndex(index));
      _currentIndex = index;
    });
  }

  Widget addChecklist() {
    MasterModel directions = Provider.of<MasterModel>(context);

    return Column(
      children: <Widget>[
        TextField(
          obscureText: false,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Description'),
          onChanged: (text) {},
        ),
        RaisedButton(onPressed: () {
          print('Add item');
          Navigator.pushNamed(context, '/');
        }),
      ],
    );
  }

  Widget postWidget() {
    return FutureBuilder<Post>(
      future: fetchPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.title);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }

  Future<Post> fetchPost() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  _displaySaveListDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Save list as'),
            content: TextField(
              controller: _saveListController,
              autofocus: true,
              decoration: InputDecoration(hintText: "List Name"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SAVE'),
                onPressed: () {
                  Favourite newFavourite = new Favourite();
                  newFavourite.setName(_saveListController.text);
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

class AddItemForm extends StatefulWidget {
  @override
  State createState() => AddItemState();
}

class AddItemState extends State<AddItemForm> {
  final controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: controller,
          autofocus: true,
          onFieldSubmitted: (controller) {
            _submitAction();
          },
          textInputAction: TextInputAction.done,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          _submitAction();
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }

  void _submitAction() {
    MasterModel model = Provider.of<MasterModel>(context);
    Item newItem = new Item(model.getListName(), controller.text);
    model.addItem(newItem);

    Navigator.pushNamed(context, '/');
  }
}
