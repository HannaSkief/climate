import 'dart:convert';

import 'package:climate/features/climate/data/model/climate_model.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tClimateModel = ClimateModel(
    city: 'Latakia',
    weather: 'Sunny',
    icon: '01n',
    temp: 30.0,
    tempMin: 20.0,
    tempMax: 33.0,
    humidity: 20,
    wind: 30,
  );

  test('should be a subclass of Climate entity ', () async {
    expect(tClimateModel, isA<Climate>());
  });

  group('fromJson', () {
    test('should return a valid climate ', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('climate.json'));

      // act
      final result = ClimateModel.fromJson(jsonMap);

      // assert
      expect(result, tClimateModel);
    });
  });

  group('toJson', () {
    test('should return a JSON containing the proper data ', () async {
      // act
      final result = tClimateModel.toJson();

      // assert
      final expectedMap = {
        "weather": [
          {
            "main": "Sunny",
            "icon": "01n",
          }
        ],
        "main": {
          "temp": 30.0,
          "temp_min": 20.0,
          "temp_max": 33.0,
          "humidity": 20
        },
        "wind": {
          "speed": 30,
        },
        "name": "Latakia",
      };

      expect(result, expectedMap);
    });
  });
}
