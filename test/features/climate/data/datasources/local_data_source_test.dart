import 'dart:convert';

import 'package:climate/core/error/exception.dart';
import 'package:climate/features/climate/data/datasources/local_data_source.dart';
import 'package:climate/features/climate/data/model/climate_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreference mockSharedPreference;
  LocalDataSource dataSource;

  setUp(() {
    mockSharedPreference = MockSharedPreference();
    dataSource = LocalDataSourceImpl(sharedPreference: mockSharedPreference);
  });

  group('getLastClimate', () {
    final tClimateModel =
        ClimateModel.fromJson(json.decode(fixture('climate.json')));

    test(
        'should return last climate  from sharedPreference when there is one in cache ',
        () async {
      // arrange
      when(mockSharedPreference.get(any)).thenReturn(fixture('climate.json'));

      // act
      final result = await dataSource.getLastClimate();

      // assert
      verify(mockSharedPreference.get(CACHED_CLIMATE));
      expect(result, equals(tClimateModel));
    });

    test('should return cachedException when no data is cached ', () async {
      // arrange
      when(mockSharedPreference.get(any)).thenReturn(null);

      // act
      final call = dataSource.getLastClimate;
      // assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheClimate', () {
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

    test('should call shared preference to cache the data ', () async {
      // act
      dataSource.cacheClimate(tClimateModel);

      // assert
      final expectedJson = json.encode(tClimateModel.toJson());
      verify(mockSharedPreference.setString(CACHED_CLIMATE, expectedJson));
    });
  });
}
