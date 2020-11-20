import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart";
import 'package:places_app/models/place.dart';

import '../main.dart';

class MapScreen extends StatelessWidget {
  final Place selectedPlace;

  MapScreen(this.selectedPlace);

  @override
  Widget build(BuildContext context) {
    final lat = selectedPlace.location.latitude;
    final lng = selectedPlace.location.longitude;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Hero(tag: 1, child: Text(selectedPlace.title)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: FlutterMap(
          options: MapOptions(center: LatLng(lat, lng), zoom: 12.0),
          layers: [
            TileLayerOptions(
                urlTemplate: MyApp.URL_TEMPLATE,
                additionalOptions: {
                  'accessToken': MyApp.ACCESS_TOKEN,
                }),
            MarkerLayerOptions(markers: [
              Marker(
                  width: 50.0,
                  height: 50.0,
                  point: LatLng(lat, lng),
                  builder: (ctx) => Container(
                        child: Image.asset(
                          "assets/marker.png",
                        ),
                      ))
            ])
          ]),
    );
  }
}
