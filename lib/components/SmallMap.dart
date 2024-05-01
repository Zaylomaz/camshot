import 'package:camshot/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';




class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late LatLng currentLocation;

  @override
  void initState() {
    super.initState();
    currentLocation = LatLng(0,0); // Default location (Google HQ)
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updateLocation(LatLng newLocation) async {
    setState(() {
      currentLocation = newLocation;
    });

    final placemarks = await placemarkFromCoordinates(newLocation.latitude, newLocation.longitude);
    if (placemarks.isNotEmpty) {
      final address = placemarks.first;
      Navigator.pop(context, '${address.street}, ${address.locality}, ${address.country}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTextField("coords", hint: '???????? ??????????????', controllerName: mapController, hintStyle: null, validator: (String ) {  },),      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _updateLocation,
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 9.0,
        ),
      ),
    );
  }
}