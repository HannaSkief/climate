import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:flutter/material.dart';

class ClimateWidget extends StatelessWidget {
  final Climate climate;

  const ClimateWidget({Key key, this.climate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          climate.city,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              climate.weather,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Image(
              image: NetworkImage(
                  'http://openweathermap.org/img/w/${climate.icon}.png'),
              width: 50.0,
              height: 50.0,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 40.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                '${climate.temp.toInt().toString()}°',
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              Text(
                '${climate.tempMax.toInt().toString()}°',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 20.0),
              Text(
                '${climate.tempMin.toInt().toString()}°',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            WeatherItem(
              value: climate.wind.toInt(),
              iconName: 'wind.png',
              unit: 'Km/h',
            ),
            WeatherItem(
              value: climate.humidity,
              iconName: 'humidity.png',
              unit: '%',
            ),
          ],
        ),
      ],
    );
  }
}

class WeatherItem extends StatelessWidget {
  final String iconName;
  final int value;
  final String unit;

  const WeatherItem({
    Key key,
    this.iconName,
    this.value,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image(
          image: AssetImage('assets/$iconName'),
          height: 50.0,
          width: 50.0,
        ),
        SizedBox(height: 10.0),
        Text(
          '$value $unit',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
