import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Climate extends Equatable {
  final String city;
  final String weather;
  final String icon;
  final double temp;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double wind;

  Climate({
    @required this.city,
    @required this.weather,
    @required this.icon,
    @required this.temp,
    @required this.tempMin,
    @required this.tempMax,
    @required this.humidity,
    @required this.wind,
  }) : super([city, weather, icon, temp, tempMax, tempMin, humidity, wind]);
}
