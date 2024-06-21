import 'package:flutter/material.dart';
import 'package:geolocation_flutter/geolocation_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Location location = Location();
  CameraPosition? _initialCameraPosition;
  Set<Marker> _markers = {};
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    Location().onLocationChanged.listen((LocationData currentLocation) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14.5,
          ),
        ),
      );
    });
    initializeCameraPosition();
  }

  Future<void> initializeCameraPosition() async {
    latitude = (await getcurrentLatitude())!;
    longitude = (await getcurrentLongitude())!;
    _initialCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude), // Default position
      zoom: 14.5,
    );
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('m1'),
        position: LatLng(
          latitude,
          longitude,
        ),
      ));
    });
  }

  Future<double?> getcurrentLatitude() async {
    var currentLocation = await location.getLocation();
    return (currentLocation.latitude);
  }

  Future<double?> getcurrentLongitude() async {
    var currentLocation = await location.getLocation();
    return (currentLocation.longitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeCameraPosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialCameraPosition!,
              markers: _markers,
            ),
          );
        } else {
          return Center(
              child:
                  CircularProgressIndicator()); // Show loading spinner while waiting
        }
      },
    );
  }
}
