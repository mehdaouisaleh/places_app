import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

class LocationProvider with ChangeNotifier {
  LatLng _userCoordinates;

  LatLng get userCoordinates {
    return _userCoordinates;
  }

  void setCoordinates(LatLng latLng) {
    _userCoordinates = latLng;
    notifyListeners();
  }

  void clearLocation() {
    _userCoordinates = null;
    notifyListeners();
  }
}
