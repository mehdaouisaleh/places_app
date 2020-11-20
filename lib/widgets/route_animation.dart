import 'package:flutter/material.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/screens/interactive_viewer_screen.dart';
import 'package:places_app/screens/map_screen.dart';

Route SlideFromRightTransition(Place selectedPlace) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        MapScreen(selectedPlace),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route FadeRouteTransition(Place selectedPlace) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        InteractiveScreen(selectedPlace),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
