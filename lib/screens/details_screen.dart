import 'package:flutter/material.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/providers/places_provider.dart';
import 'package:places_app/screens/interactive_viewer_screen.dart';
import 'package:places_app/screens/map_screen.dart';
import 'package:provider/provider.dart';
import "package:latlong/latlong.dart";
import '../widgets/route_animation.dart';

class DetailsScreen extends StatelessWidget {
  static const String routeName = 'details_screen';
  String id;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    id = ModalRoute.of(context).settings.arguments as String;
    Place selectedPlace =
        Provider.of<PlacesProvider>(context, listen: false).getPlace(id);
    var _child = Container(
      width: width * .6,
      child: Text(
        selectedPlace.title,
        overflow: TextOverflow.fade,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   brightness: Brightness.light,
      //   iconTheme: IconThemeData(color: Colors.black),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            brightness: Brightness.light,
            elevation: 8,
            iconTheme: IconThemeData(color: Colors.black),
            expandedHeight: 250,
            backgroundColor: Colors.white,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: selectedPlace.id,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(FadeRouteTransition(selectedPlace));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.file(selectedPlace.image)),
                    color: Colors.black12,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _child,
                          Container(
                            width: width * .7,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                selectedPlace.location.address,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38),
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.map,
                            size: 30.0,
                            color: Colors.orange.withOpacity(.9),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(SlideFromRightTransition(selectedPlace));
                          })
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(25.0),
                child: Text(selectedPlace.description),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
