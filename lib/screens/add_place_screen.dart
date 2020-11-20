import 'dart:io';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter/material.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/providers/location_provider.dart';
import 'package:places_app/screens/pick_location_screen.dart';
import 'package:places_app/widgets/image_input.dart';
import 'package:provider/provider.dart';
import '../providers/places_provider.dart';
import 'package:location/location.dart';
import "package:latlong/latlong.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';

class AddPlace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        autoPlay: true,
        autoPlayDelay: Duration(seconds: 3),
        autoPlayLockEnable: false,
        builder: Builder(
          builder: (context) => AddPlaceScreen(),
        ),
      ),
    );
  }
}

class AddPlaceScreen extends StatefulWidget {
  static const String routeName = 'add_place_screen';
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String locationSnapshot;
  File _savedImage;

  bool _locationSelected = true;

  final _placeNameController = TextEditingController();
  final _placeAddressController = TextEditingController();
  final _placeDescriptionController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  void _selectImage(File savedImage) {
    _savedImage = savedImage;
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    _placeAddressController.dispose();
    _placeDescriptionController.dispose();
    _addressFocusNode.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  void onSaved() async {
    final coordinates =
        Provider.of<LocationProvider>(context, listen: false).userCoordinates;
    print(coordinates);
    if (_formKey.currentState.validate()) {
      if (_savedImage == null) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Please select a picture',
              textAlign: TextAlign.center,
            )));
        return;
      } else {
        if (coordinates == null) {
          setState(() {
            _locationSelected = false;
          });
          // _scaffoldKey.currentState.hideCurrentSnackBar();
          // _scaffoldKey.currentState.showSnackBar(SnackBar(
          //     backgroundColor: Colors.red,
          //     content: Text(
          //       'Please choose a place',
          //       textAlign: TextAlign.center,
          //     )));
          return;
        } else {
          await Provider.of<PlacesProvider>(context, listen: false)
              .addPlace(
                  location: PlaceLocation(
                      address: _placeAddressController.text,
                      latitude: coordinates.latitude,
                      longitude: coordinates.longitude),
                  title: _placeNameController.text,
                  description: _placeDescriptionController.text,
                  image: _savedImage)
              .then((value) =>
                  Provider.of<LocationProvider>(context, listen: false)
                      .clearLocation());
          Navigator.of(context).pop();
        }
      }
    }
  }

  Widget CurrentLocation() {
    var userCoordinates =
        Provider.of<LocationProvider>(context, listen: true).userCoordinates;

    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black38),
        ),
        height: 200,
        width: double.infinity,
        child: Center(
          child: FlutterMap(
            options: MapOptions(
              center:
                  LatLng(userCoordinates.latitude, userCoordinates.longitude),
              zoom: 12.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mehdaouisaleh/ckhghhgpd0wkj19mw47na3z1g/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWVoZGFvdWlzYWxlaCIsImEiOiJjanR1MzF1cjIwZDNvNGRvYWZ6MHJ2bDJhIn0.cEHeQvC3O68nPVMQE2uZCQ',
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoibWVoZGFvdWlzYWxlaCIsImEiOiJjanR1MzF1cjIwZDNvNGRvYWZ6MHJ2bDJhIn0.cEHeQvC3O68nPVMQE2uZCQ',
                  }),
              MarkerLayerOptions(markers: [
                Marker(
                    width: 50.0,
                    height: 50.0,
                    point: userCoordinates,
                    builder: (ctx) => Container(
                          child: Image.asset(
                            "assets/marker.png",
                          ),
                        ))
              ]),
            ],
          ),
        ));
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Current Location'),
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Choose On Map'),
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _getAddress(LatLng coordinates) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(coordinates.latitude, coordinates.longitude));

    _placeAddressController.text = addresses.first.addressLine;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context)
            .startShowCase([_one, _two, _three, _four, _five]));
    return WillPopScope(
      onWillPop: () async {
        Provider.of<LocationProvider>(context, listen: false).clearLocation();
        return true;
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            toolbarHeight: 70,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                  tooltip: 'Submit',
                  icon: Icon(Icons.check),
                  onPressed: () {
                    onSaved();
                  })
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 40,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter a name';
                        else if (value.length < 5) return 'Name is too short';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: _titleFocusNode,
                      onFieldSubmitted: (_) {
                        _formKey.currentState.validate();
                        FocusScope.of(context).requestFocus(_addressFocusNode);
                      },
                      maxLines: 2,
                      controller: _placeNameController,
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                        labelText: 'Place name',
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Consumer<LocationProvider>(
                            builder: (_, data, child) {
                              if (data.userCoordinates != null)
                                _getAddress(data.userCoordinates);
                              return TextFormField(
                                maxLength: 120,
                                onFieldSubmitted: (_) {
                                  _formKey.currentState.validate();
                                  FocusScope.of(context)
                                      .requestFocus(_descriptionFocusNode);
                                },
                                textInputAction: TextInputAction.next,
                                focusNode: _addressFocusNode,
                                cursorColor: Colors.orange,
                                controller: _placeAddressController,
                                maxLines: 2,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please enter an address';
                                  else if (value.length < 5)
                                    return 'address is too short';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                ),
                              );
                            },
                          ),
                        ),
                        Consumer<LocationProvider>(
                          builder: (_, data, ch) {
                            return _locationSelected
                                ? IconButton(
                                    tooltip: 'Location',
                                    color: data.userCoordinates != null
                                        ? Colors.orange
                                        : Colors.black26,
                                    icon: Icon(Icons.place),
                                    onPressed: () {
                                      //_showPicker(context);
                                      Navigator.of(context).pushNamed(
                                          PickLocationScreen.routeName);
                                    })
                                : Showcase(
                                    key: _one,
                                    description: 'Tap to choose location',
                                    child: IconButton(
                                        tooltip: 'Location',
                                        color: data.userCoordinates != null
                                            ? Colors.orange
                                            : Colors.black26,
                                        icon: Icon(Icons.place),
                                        onPressed: () {
                                          //_showPicker(context);
                                          Navigator.of(context).pushNamed(
                                              PickLocationScreen.routeName);
                                        }),
                                  );
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // Consumer<LocationProvider>(
                    //   builder: (_, provider, ch) {
                    //     if (provider.userCoordinates == null)
                    //       return Container();
                    //     else
                    //       return Column(
                    //         children: [
                    //           CurrentLocation(),
                    //           SizedBox(
                    //             height: 20.0,
                    //           ),
                    //         ],
                    //       );
                    //   },
                    // ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter a description';
                        else if (value.length < 100)
                          return 'Description is too short';
                        return null;
                      },
                      textInputAction: TextInputAction.newline,
                      onFieldSubmitted: (_) {
                        _formKey.currentState.validate();
                      },
                      maxLines: 5,
                      controller: _placeDescriptionController,
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                          labelText: 'Description', alignLabelWithHint: true),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),

                    ImageInput(_selectImage),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
