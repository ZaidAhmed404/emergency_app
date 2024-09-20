import 'package:geolocator/geolocator.dart';

import '../../domain/services/map_services.dart';

class MapController {
  final MapServices mapServices;

  MapController(this.mapServices);

  Future<Position> handleGettingCurrentPosition() async {
    return await mapServices.determinePosition();
  }
}
