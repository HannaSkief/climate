import 'dart:convert';

import 'package:climate/core/error/exception.dart';
import 'package:climate/core/location/location.dart';
import 'package:climate/features/climate/data/datasources/remote_data_source.dart';
import 'package:climate/features/climate/data/model/climate_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockLocation extends Mock implements Location {}

const apiKey = '6f3b0107da42d553e7db513dbddf4215';
const openWeatherMapUrl = 'https://api.openweathermap.org/data/2.5/weather';

void main() {
  MockHttpClient mockHttpClient;
  MockLocation mockLocation;
  RemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockLocation = MockLocation();
    dataSource =
        RemoteDataSourceImpl(client: mockHttpClient, location: mockLocation);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any))
        .thenAnswer((_) async => http.Response(fixture('climate.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getClimateForCurrentLocation', () {
    final tClimateModel =
        ClimateModel.fromJson(json.decode(fixture('climate.json')));
    final tCoordinate = Coordinate(lat: 0.0, lon: 0.0);

    test('should perform a Get request on a URl with number being the endpoint',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      when(mockLocation.getCurrentLocation())
          .thenAnswer((_) async => Coordinate(lat: 0.0, lon: 0.0));
      // act
      await dataSource.getClimateForCurrentLocation();
      // assert
      verify(mockHttpClient.get(
          '$openWeatherMapUrl?lat=${tCoordinate.lat}&lon=${tCoordinate.lon}&appid=$apiKey&units=metric'));
    });

    test('should return Climate when resonse code is 200 ', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      when(mockLocation.getCurrentLocation())
          .thenAnswer((_) async => Coordinate(lat: 0.0, lon: 0.0));

      // act
      final result = await dataSource.getClimateForCurrentLocation();
      // assert
      expect(result, equals(tClimateModel));
    });

    test('should throw ServerException when response code is 404 or any code ',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      when(mockLocation.getCurrentLocation())
          .thenAnswer((_) async => Coordinate(lat: 0.0, lon: 0.0));
      // act

      final call = dataSource.getClimateForCurrentLocation();

      // assert

      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });
    test('should throw LocationException when can not get current location ',
        () async {
      // arrange
      when(mockLocation.getCurrentLocation()).thenThrow(LocationException());
      // act

      final call = dataSource.getClimateForCurrentLocation();

      // assert

      expect(() => call, throwsA(TypeMatcher<LocationException>()));
    });
  });

  group('getClimateForInputLocation', () {
    final tCity = 'Latakia';
    final tClimateModel =
        ClimateModel.fromJson(json.decode(fixture('climate.json')));
    final tCoordinate = Coordinate(lat: 0.0, lon: 0.0);

    test('should perform a Get request on a URl with number being the endpoint',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      await dataSource.getClimateForInputLocation(tCity);
      // assert
      verify(mockHttpClient
          .get('$openWeatherMapUrl?q=$tCity&appid=$apiKey&units=metric'));
    });

    test('should return Climate when resonse code is 200 ', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getClimateForInputLocation(tCity);
      // assert
      expect(result, equals(tClimateModel));
    });

    test('should throw ServerException when response code is 404 or any code ',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act

      final call = dataSource.getClimateForInputLocation(tCity);

      // assert

      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });

  });
}
