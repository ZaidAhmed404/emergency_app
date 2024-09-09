import 'dart:async';

import 'package:emergency_app/core/messages.dart';
import 'package:emergency_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Messages _messages = Messages();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? _currentPosition;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toastWidget(
          isError: true, message: _messages.locationServicesDisabledMessage);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toastWidget(
            isError: true, message: _messages.locationPermissionDeniedMessage);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      toastWidget(isError: true, message: "Location services are disabled.");
      toastWidget(
          isError: true, message: _messages.locationDeniedForeverMessage);
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentPosition();
  }

  getCurrentPosition() async {
    _currentPosition = await _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        circles: {
          Circle(
              circleId: const CircleId('1'),
              center: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              radius: 500,
              fillColor: const Color.fromARGB(59, 33, 149, 243),
              strokeWidth: 2,
              strokeColor: const Color.fromARGB(202, 255, 255, 255))
        },
      ),
    );
  }
}
