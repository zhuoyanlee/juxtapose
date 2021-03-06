import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:juxtapose/models/locations.dart' as locations;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:juxtapose/states/master.dart';
import 'package:provider/provider.dart';

class MapRoute extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapRoute> {

  GoogleMapController mapController;
  bool loading;
  List<LatLng> _center_coordinates = new List<LatLng>();
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  String googlekey = DotEnv().env['googleMapsKey'];

  GoogleMapPolyline _googleMapPolyline =
      new GoogleMapPolyline(apiKey: DotEnv().env['googleMapsKey']);

  int _polylineCount = 0;

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  final LatLng _center = const LatLng(45.521563, -122.677433);

  final Map<String, Marker> _markers = {};

  //Get polyline with Address
  _getPolylinesWithAddress() async {
    print('Google key ${googlekey}');
    loading = true;
    

    print('From address ${Provider.of<MasterModel>(context).fromAddress}');
    _center_coordinates =
        await _googleMapPolyline.getPolylineCoordinatesWithAddress(
            origin: Provider.of<MasterModel>(context).fromAddress,
            destination: 'Google San Bruno',
            mode: RouteMode.driving);
    setState(() {
      _polylines.clear();
      print('Center coordinates ${_center_coordinates}');
      if (_center_coordinates != null) {
        print('animating camera');
        _addPolyline(_center_coordinates);

        // Move camera position
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _center_coordinates.first,
          zoom: 9.0,
        )));
      }
    });

    loading = false;
  }

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates,
        width: 5,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    _getPolylinesWithAddress();
    setState(() {
      mapController = controller;
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MasterModel>(builder: (context, directions, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Maps Sample App'),
            backgroundColor: Colors.green[700],
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 5.0,
            ),
            markers: _markers.values.toSet(),
            polylines: Set<Polyline>.of(_polylines.values),
          ));
    });
  }
}
