import 'package:geolocator/geolocator.dart';

abstract class MapServices {
  Future<Position> determinePosition();
}
