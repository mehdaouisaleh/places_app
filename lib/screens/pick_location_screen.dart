import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart";
import 'package:places_app/main.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:places_app/providers/location_provider.dart';

class PickLocationScreen extends StatefulWidget {
  static const String routeName = 'pick_location_screen';
  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  LatLng _userCoordinates = LatLng(0.0, 0.0);
  MapController mapController = MapController();
  List<Marker> _markers = [];
  bool _isLoading = true;

  Future<void> _getCurrentLocation() async {
    final userLocation = await Location().getLocation();
    // Location().onLocationChanged.listen((event) {
    //   if (event.latitude != _userCoordinates.latitude &&
    //       event.longitude != _userCoordinates.longitude) {
    //     print('changed');
    //     _userCoordinates.latitude = event.latitude;
    //     _userCoordinates.longitude = event.longitude;
    //     setState(() {
    //       mapController.move(_userCoordinates, 12.0);
    //     });
    //   }
    // });
    setState(() {
      _userCoordinates.latitude = userLocation.latitude;
      _userCoordinates.longitude = userLocation.longitude;

      _markers.add(Marker(
          width: 50.0,
          height: 50.0,
          point: _userCoordinates,
          builder: (ctx) => Container(
                child: Image.asset(
                  "assets/marker.png",
                ),
              )));

      mapController.move(_userCoordinates, 12.0);

      _isLoading = false;
    });
  }

  void _selectPlace() {
    Provider.of<LocationProvider>(context, listen: false)
        .setCoordinates(_markers.first.point);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  void _showMarker(LatLng point) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
          width: 50.0,
          height: 50.0,
          point: point,
          builder: (ctx) => Container(
                child: Image.asset(
                  "assets/marker.png",
                ),
              )));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        toolbarHeight: 70,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              _selectPlace();
            },
            tooltip: 'Done',
          )
        ],
      ),
      body: Stack(children: [
        Container(
          child: FlutterMap(
            options: MapOptions(
              interactive: true,
              center: LatLng(31.050478, -7.931633),
              zoom: 9.0,
              onTap: (point) => _showMarker(point),
            ),
            mapController: mapController,
            layers: [
              TileLayerOptions(
                  urlTemplate: MyApp.URL_TEMPLATE,
                  additionalOptions: {
                    'accessToken':
                       MyApp.ACCESS_TOKEN ,
                  }),
              MarkerLayerOptions(
                markers: _markers,
              ),
            ],
          ),
        ),
        if (_isLoading)
          Stack(
            children: [
              Container(
                color: Colors.black.withOpacity(.5),
                height: double.infinity,
                width: double.infinity,
              ),
              LinearProgressIndicator(
                backgroundColor: Colors.orange,
              )
            ],
          )
      ]),
    );
  }
}
