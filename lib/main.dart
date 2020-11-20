import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:places_app/providers/location_provider.dart';
import 'package:places_app/providers/places_provider.dart';
import 'package:places_app/screens/add_place_screen.dart';
import 'package:places_app/screens/details_screen.dart';
import 'package:places_app/screens/map_screen.dart';
import 'package:places_app/screens/pick_location_screen.dart';
import 'package:places_app/screens/places_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static const MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
  static const int _blackPrimaryValue = 0xFF000000;

  static const String URL_TEMPLATE =
      'https://api.mapbox.com/styles/v1/mehdaouisaleh/ckhghhgpd0wkj19mw47na3z1g/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWVoZGFvdWlzYWxlaCIsImEiOiJjanR1MzF1cjIwZDNvNGRvYWZ6MHJ2bDJhIn0.cEHeQvC3O68nPVMQE2uZCQ';
  static const String ACCESS_TOKEN =
      'pk.eyJ1IjoibWVoZGFvdWlzYWxlaCIsImEiOiJjanR1MzF1cjIwZDNvNGRvYWZ6MHJ2bDJhIn0.cEHeQvC3O68nPVMQE2uZCQ';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Colors.transparent,
        ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.orange,
          accentColor: Colors.orange[100],
          inputDecorationTheme: new InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange))),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PlacesScreen(),
        routes: {
          PickLocationScreen.routeName: (_) => PickLocationScreen(),
          AddPlaceScreen.routeName: (_) => AddPlace(),
          DetailsScreen.routeName: (_) => DetailsScreen(),
        },
      ),
    );
  }
}
