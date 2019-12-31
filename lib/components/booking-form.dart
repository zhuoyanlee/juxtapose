import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:juxtapose/states/master.dart';

class BookingForm extends StatefulWidget {

  @override
  BookingFormState createState() => BookingFormState();
}

class BookingFormState extends State<BookingForm> {

  @override
  Widget build(BuildContext context) {
    return Consumer<MasterModel>(builder: (context, directions, child) {
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

                TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'From'),
                  onChanged: (text) {
                    directions.updateAddress(text, '');
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    print('From address is ${directions.fromAddress}');
                    Navigator.pushNamed(context, '/gmap');
                  },
                  child: Icon(Icons.add),
                )
              ],
            )),

      );
    });
  }
}