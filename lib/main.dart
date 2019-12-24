import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:juxtapose/components/booking-form.dart';
import 'package:juxtapose/components/checklist-widget.dart';
import 'package:juxtapose/services/api.dart';
import 'package:juxtapose/services/database-service.dart';
import 'package:juxtapose/models/item.dart';
import 'package:juxtapose/models/post.dart';
import 'dart:convert';
import 'package:juxtapose/components/maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:juxtapose/states/directions.dart';
import 'package:provider/provider.dart';
import 'package:juxtapose/locator.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;


void main() {
  DotEnv().load('.env');

  getIt.registerLazySingleton(() => Api('items'));
  getIt.registerFactory(() => DirectionsModel());
//  getIt.registerSingleton<DirectionsModel>(DirectionsModel(),signalsReady:true);
  runApp(ChangeNotifierProvider(
    builder: (context) => DirectionsModel(),
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
  int _counter = 0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Consumer<DirectionsModel>(builder: (context, directions, child) {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('My Home page'),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ChecklistRoute()
          ],
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

  Widget addChecklist() {
    DirectionsModel directions = Provider.of<DirectionsModel>(context);

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
        child: TextField(
          controller: controller,
          autofocus: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          Item newItem = new Item(controller.text);
          Provider.of<DirectionsModel>(context).addItem(newItem);
          DatabaseService.createRecord(controller.text, true);
          Navigator.pushNamed(context, '/');
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}
