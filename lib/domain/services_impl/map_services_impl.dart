import 'package:emergency_app/domain/services/map_services.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../../core/messages.dart';
import '../../presentation/widgets/toast.dart';

class MapServicesImpl extends MapServices {
  final Messages _messages = Messages();

  @override
  Future<geo.Position> determinePosition() async {
    bool serviceEnabled;
    geo.LocationPermission permission;
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toastWidget(
          isError: true, message: _messages.locationServicesDisabledMessage);
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        toastWidget(
            isError: true, message: _messages.locationPermissionDeniedMessage);
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      toastWidget(isError: true, message: "Location services are disabled.");
      toastWidget(
          isError: true, message: _messages.locationDeniedForeverMessage);
    }

    return await geo.Geolocator.getCurrentPosition();
  }
}
