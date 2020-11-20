import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places_app/models/place.dart';
import '../helpers/database_helper.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Future<void> addPlace(
      {String title,
      PlaceLocation location,
      File image,
      String description}) async {
    final newPlace = Place(
        id: DateTime.now().toIso8601String(),
        image: image,
        title: title,
        description: description,
        location: location);
    _places.insert(0, newPlace);

    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'description': newPlace.description,
      'address': newPlace.location.address,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
    });

    notifyListeners();
  }

  Place getPlace(String id) {
    return _places.firstWhere((element) => element.id == id);
  }

  Future<void> fetchPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _places = dataList
        .map((item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            description: item['description'],
            location: PlaceLocation(
                address: item['address'],
                latitude: item['lat'],
                longitude: item['lng'])))
        .toList();

    notifyListeners();
  }
}
