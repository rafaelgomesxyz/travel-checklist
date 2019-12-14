import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:travel_checklist/secrets.dart';

class MapScreen extends StatelessWidget {
  final LatLng initialLocation;

  MapScreen({ Key key , this.initialLocation }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      googleMapsApiKey,
      displayLocation: initialLocation,
    );
  }
}