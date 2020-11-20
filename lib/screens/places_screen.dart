import 'package:flutter/material.dart';
import 'package:places_app/providers/places_provider.dart';
import 'package:places_app/screens/add_place_screen.dart';
import 'package:places_app/screens/details_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class PlacesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Places',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        tooltip: 'Add',
      ),
      body: FutureBuilder(
          future:
              Provider.of<PlacesProvider>(context, listen: false).fetchPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Container()
              : Consumer<PlacesProvider>(
                  child: Center(child: Text('No places to show')),
                  builder: (ctx, placesProvider, child) => placesProvider
                              .places.length <=
                          0
                      ? child
                      : ScrollConfiguration(
                          behavior: ScrollBehavior(),
                          child: new StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            itemCount: placesProvider.places.length,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                              onTap: () {
                                // handle on tap
                                Navigator.of(context).pushNamed(
                                    DetailsScreen.routeName,
                                    arguments: placesProvider.places[index].id);
                              },
                              child: Hero(
                                tag: placesProvider.places[index].id,
                                child: new Container(
                                  //width: 100, height: 100, color: Colors.black12,
                                  child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: FadeInImage(
                                          fit: BoxFit.cover,
                                          placeholder:
                                              Image.asset('assets/white_bg.png')
                                                  .image,
                                          image: Image.file(placesProvider
                                                  .places[index].image)
                                              .image)),
                                ),
                              ),
                            ),
                            staggeredTileBuilder: (int index) => width > 400
                                ? new StaggeredTile.count(
                                    1, index.isEven ? 1 : 1)
                                : new StaggeredTile.count(
                                    2, index.isEven ? 2 : 3),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          ),
                        ),
                )),
    );
  }
}
