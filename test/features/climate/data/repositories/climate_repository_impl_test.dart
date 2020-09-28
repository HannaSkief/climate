import 'package:climate/core/error/exception.dart';
import 'package:climate/core/error/failure.dart';
import 'package:climate/core/location/location.dart';
import 'package:climate/core/network/network_info.dart';
import 'package:climate/features/climate/data/datasources/local_data_source.dart';
import 'package:climate/features/climate/data/datasources/remote_data_source.dart';
import 'package:climate/features/climate/data/model/climate_model.dart';
import 'package:climate/features/climate/data/repositories/climate_repository_impl.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  ClimateRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = ClimateRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDateSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getClimateForCurrentLocation', () {
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

    final Climate tClimate = tClimateModel;

    test('should check if the device is online ', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // act
      repository.getClimateForCurrentLocation();
      // assert

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return  remote data when the call to remote data source is successful ',
          () async {
        // arrange
        when(mockRemoteDataSource.getClimateForCurrentLocation())
            .thenAnswer((_) async => tClimateModel);
        // act

        final result = await repository.getClimateForCurrentLocation();

        // assert

        verify(mockRemoteDataSource.getClimateForCurrentLocation());
        expect(result, equals(Right(tClimateModel)));
      });

      test(
          'should  cache the data localy when the call to remote data source is successful  ',
          () async {
        // arrange
        when(mockRemoteDataSource.getClimateForCurrentLocation())
            .thenAnswer((_) async => tClimateModel);
        // act

        await repository.getClimateForCurrentLocation();

        // assert
        verify(mockRemoteDataSource.getClimateForCurrentLocation());
        verify(mockLocalDataSource.cacheClimate(tClimateModel));
      });

      test(
          ' should return server failure whene the call to remote data source unsuccessful ',
          () async {
        // arrange

        when(mockRemoteDataSource.getClimateForCurrentLocation())
            .thenThrow(ServerException());

        // act

        final result = await repository.getClimateForCurrentLocation();

        // assert
        verify(mockRemoteDataSource.getClimateForCurrentLocation());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });

      test(
          ' should return location failure whene the call to remote data source unsuccessful ',
          () async {
        // arrange

        when(mockRemoteDataSource.getClimateForCurrentLocation())
            .thenThrow(LocationException());

        // act

        final result = await repository.getClimateForCurrentLocation();

        // assert
        verify(mockRemoteDataSource.getClimateForCurrentLocation());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(LocationFailure())));
      });
    });

    runTestOffline(() {
      test('should return last locally cached data when last data is present ',
          () async {
        // arrange
        when(mockLocalDataSource.getLastClimate())
            .thenAnswer((_) async => tClimateModel);

        // act

        final result = await repository.getClimateForCurrentLocation();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastClimate());
        expect(result, equals(Right(tClimateModel)));
      });

      test(' should return CacheFailure when no data is cached ', () async {
        // arrange
        when(mockLocalDataSource.getLastClimate()).thenThrow(CacheException());

        // act
        final result = await repository.getClimateForCurrentLocation();
        // assert
        verify(mockLocalDataSource.getLastClimate());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getClimateForInputLocation', () {
    final tCity = 'Latakia';
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

    final Climate tClimate = tClimateModel;

    test('should check if the device is online ', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // act
      repository.getClimateForCurrentLocation();
      // assert

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return  remote data when the call to remote data source is successful ',
          () async {
        // arrange
        when(mockRemoteDataSource.getClimateForInputLocation(any))
            .thenAnswer((_) async => tClimateModel);
        // act

        final result = await repository.getClimateForInputLocation(tCity);

        // assert

        verify(mockRemoteDataSource.getClimateForInputLocation(tCity));
        expect(result, equals(Right(tClimateModel)));
      });

      test(
          'should  cache the data localy when the call to remote data source is successful  ',
          () async {
        // arrange
        when(mockRemoteDataSource.getClimateForInputLocation(any))
            .thenAnswer((_) async => tClimateModel);
        // act

        await repository.getClimateForInputLocation(tCity);

        // assert
        verify(mockRemoteDataSource.getClimateForInputLocation(tCity));
        verify(mockLocalDataSource.cacheClimate(tClimateModel));
      });

      test(
          ' should return server failure whene the call to remote data source unsuccessful ',
          () async {
        // arrange

        when(mockRemoteDataSource.getClimateForInputLocation(any))
            .thenThrow(ServerException());

        // act

        final result = await repository.getClimateForInputLocation(tCity);

        // assert
        verify(mockRemoteDataSource.getClimateForInputLocation(tCity));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    runTestOffline(() {
      test('should return last locally cached data when last data is present ',
          () async {
        // arrange
        when(mockLocalDataSource.getLastClimate())
            .thenAnswer((_) async => tClimateModel);

        // act

        final result = await repository.getClimateForInputLocation(tCity);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastClimate());
        expect(result, equals(Right(tClimateModel)));
      });

      test(' should return CacheFailure when no data is cached ', () async {
        // arrange
        when(mockLocalDataSource.getLastClimate()).thenThrow(CacheException());

        // act
        final result = await repository.getClimateForInputLocation(tCity);
        // assert
        verify(mockLocalDataSource.getLastClimate());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
