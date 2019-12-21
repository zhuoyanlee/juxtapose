import 'package:flutter/cupertino.dart';
import 'package:juxtapose/states/checklist.dart';
import 'package:juxtapose/states/directions.dart';

class MasterState extends ChangeNotifier {

  ChecklistModel checklistModel = new ChecklistModel();
  DirectionsModel directionsModel = new DirectionsModel();

}