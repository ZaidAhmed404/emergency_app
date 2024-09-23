import 'dart:async';

import 'package:emergency_app/core/messages.dart';
import 'package:emergency_app/presentation/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:lottie/lottie.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  final Completer<gmaps.GoogleMapController> _controller =
      Completer<gmaps.GoogleMapController>();

  final Messages _messages = Messages();

  Set<gmaps.Marker> _markers = {};

  static gmaps.CameraPosition _kGooglePlex = gmaps.CameraPosition(
    target: gmaps.LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentPosition();
  }

  bool isLoading = false;

  final MapController _mapController = GetIt.I<MapController>();

  getCurrentPosition() async {
    setState(() {
      isLoading = true;
    });
    _currentPosition = await _mapController.handleGettingCurrentPosition();
    var locationData =
        gmaps.LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    _markers.add(gmaps.Marker(
      markerId: const gmaps.MarkerId('currentLocation'),
      position: locationData,
      infoWindow: const gmaps.InfoWindow(title: 'Your Location'),
    ));
    _kGooglePlex = gmaps.CameraPosition(
      target:
          gmaps.LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      zoom: 14.4746,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Lottie.asset('assets/lottie/loading.json')),
            )
          : gmaps.GoogleMap(
              markers: _markers,
              mapType: gmaps.MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (gmaps.GoogleMapController controller) {
                _controller.complete(controller);
              },
              circles: {
                if (isLoading == false)
                  gmaps.Circle(
                      circleId: const gmaps.CircleId('1'),
                      center: gmaps.LatLng(
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
