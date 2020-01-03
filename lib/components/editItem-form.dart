import 'package:flutter/material.dart';
import 'package:juxtapose/models/item.dart';
import 'package:juxtapose/states/master.dart';
import 'package:provider/provider.dart';

class EditItemForm extends StatefulWidget {
  final Item editItem;

  const EditItemForm({Key key, this.editItem}) : super(key: key);

  @override
  State createState() => EditItemState();
}

class EditItemState extends State<EditItemForm> {
  final controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    controller.text = widget.editItem.description;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
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
        child: Icon(Icons.edit),
      ),
    );
  }

  void _submitAction() {
    MasterModel model = Provider.of<MasterModel>(context);
    Item updatedItem = new Item(model.getListName(), controller.text);
    model.updateItem(updatedItem, widget.editItem.id);

    Navigator.pushNamed(context, '/');
  }
}
