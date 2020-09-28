import 'dart:convert';

import 'package:climate/core/error/exception.dart';
import 'package:climate/core/location/location.dart';
import 'package:climate/features/climate/data/model/climate_model.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

const apiKey = '6f3b0107da42d553e7db513dbddf4215';
const openWeatherMapUrl = 'https://api.openweathermap.org/data/2.5/weather';

abstract class RemoteDataSource {
  Future<Climate> getClimateForCurrentLocation();

  Future<Climate> getClimateForInputLocation(String city);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final Location location;

  RemoteDataSourceImpl({
    @required this.client,
    @required this.location,
  });

  @override
  Future<Climate> getClimateForCurrentLocation() async {
    try {
      print(11111111111);
      final coordinate = await location.getCurrentLocation();
      print(coordinate.lon);
      print(coordinate.lat);
      final response = await client.get(
          '$openWeatherMapUrl?lat=${coordinate.lat}&lon=${coordinate.lon}&appid=$apiKey&units=metric');

      if (response.statusCode == 200) {
        return ClimateModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    } on LocationException {
      throw LocationException();
    }
  }

  @override
  Future<Climate> getClimateForInputLocation(String city) async {
    final response = await client.get(
        '$openWeatherMapUrl?q=$city&appid=$apiKey&units=metric');

    if (response.statusCode == 200) {
      return ClimateModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
