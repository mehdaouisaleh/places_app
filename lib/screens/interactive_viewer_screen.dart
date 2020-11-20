import 'package:flutter/material.dart';
import 'dart:io';

import 'package:places_app/models/place.dart';

class InteractiveScreen extends StatelessWidget {
  final Place place;
  InteractiveScreen(this.place);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GestureDetector(
          //  onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            )),
        Center(
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(0.0),
            minScale: 0.1,
            maxScale: 3,
            child: FittedBox(
                fit: BoxFit.cover,
                child: Hero(tag: place.id, child: Image.file(place.image))),
          ),
        ),
      ]),
    );
  }
}
