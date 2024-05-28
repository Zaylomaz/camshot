import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController? mapController;
  late Location location;
  LatLng currentLocation = const LatLng(0, 0); // Default value
  Set<Marker> markers = {}; // New
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    location = Location();
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!mounted) return;

    mapController = controller;
    _locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      if (mapController != null && mounted) {
        mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(currentLocation.latitude!,
                    currentLocation.longitude!),
                tilt: 0,
                zoom: 17.00)));
        setState(() {
          markers.clear();
          markers.add(Marker(
            markerId: const MarkerId('myLocation'),
            position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта'),
        centerTitle: true,
        leading: const Spacer(),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 15.0,
            ),
            markers: markers,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (mapController != null) {
                        mapController!.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                                bearing: 0.0,
                                target: LatLng(currentLocation.latitude, currentLocation.longitude),
                                tilt: 0,
                                zoom: 17.00)));
                      }
                    },
                    child: const Icon(Icons.gps_fixed),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}