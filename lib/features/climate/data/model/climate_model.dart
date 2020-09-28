import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';

class ClimateModel extends Climate {
  ClimateModel({
    @required String city,
    @required String weather,
    @required String icon,
    @required double temp,
    @required double tempMin,
    @required double tempMax,
    @required int humidity,
    @required double wind,
  }) : super(
          city: city,
          weather: weather,
          icon: icon,
          temp: temp,
          tempMax: tempMax,
          tempMin: tempMin,
          humidity: humidity,
          wind: wind,
        );

  factory ClimateModel.fromJson(Map<String, dynamic> json) {
    return ClimateModel(
      city: json['name'],
      weather: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      temp: (json['main']['temp']as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: (json['main']['humidity']as num).toInt(),
      wind: (json['wind']['speed'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "weather": [
        {
          "main": weather,
          "icon": icon,
        }
      ],
      "main": {
        "temp": temp,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "humidity": humidity
      },
      "wind": {
        "speed": wind,
      },
      "name": city,

    };
  }
}
