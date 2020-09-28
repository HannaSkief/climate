import 'package:climate/core/error/exception.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class Location {
  Future<Coordinate> getCurrentLocation();
}

class LocationImpl implements Location {
  @override
  Future<Coordinate> getCurrentLocation() async {
    try {
      geo.Position position = await geo.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.low);
      return Coordinate(lat: position.latitude, lon: position.longitude);
    } catch (e) {
      throw LocationException();
    }
  }
}

class Coordinate extends Equatable {
  final double lat;
  final double lon;

  Coordinate({@required this.lat, @required this.lon}) : super([lat, lon]);
}
