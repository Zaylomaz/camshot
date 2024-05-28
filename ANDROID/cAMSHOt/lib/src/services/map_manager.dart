import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapManager {
  final Location location = Location();
  GoogleMapController? mapController;

  Future<void> initializeMap(GoogleMapController controller) async {
    mapController = controller;
    await _setCurrentLocation();
  }

  Future<void> _setCurrentLocation() async {
    var _locationData = await location.getLocation();
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_locationData.latitude!, _locationData.longitude!),
          zoom: 15.0,
        ),
      ),
    );
  }
}
