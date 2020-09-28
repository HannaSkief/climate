import 'package:climate/core/error/failure.dart';
import 'package:climate/core/usecases/usecase.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:climate/features/climate/domain/usecases/get_climate_for_current_location.dart';
import 'package:climate/features/climate/domain/usecases/get_climate_for_input_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:climate/features/climate/presentaion/bloc/climate_bloc.dart';

class MockGetClimateForCurrentLocation extends Mock
    implements GetClimateForCurrentLocation {}

class MockGetClimateForInputLocation extends Mock
    implements GetClimateForInputLocation {}

void main() {
  MockGetClimateForCurrentLocation mockGetClimateForCurrentLocation;
  MockGetClimateForInputLocation mockGetClimateForInputLocation;
  ClimateBloc bloc;

  setUp(() {
    mockGetClimateForInputLocation = MockGetClimateForInputLocation();
    mockGetClimateForCurrentLocation = MockGetClimateForCurrentLocation();
    bloc = ClimateBloc(
      getClimateForCurrentLocation: mockGetClimateForCurrentLocation,
      getClimateForInputLocation: mockGetClimateForInputLocation,
    );
  });

  test('initial state is Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetCurrentLocationClimate', () {
    final tClimate = Climate(
      icon: 'icon',
      city: 'latakia',
      humidity: 50,
      temp: 33.0,
      tempMax: 35.0,
      tempMin: 25.0,
      weather: 'sunny',
      wind: 22.0,
    );

    test('should get data from the current location useCase  ', () async {
      // arrange
      when(mockGetClimateForCurrentLocation(any))
          .thenAnswer((_) async => Right(tClimate));
      // act
      bloc.dispatch(GetCurrentLocationClimate());
      await untilCalled(mockGetClimateForCurrentLocation(any));

      // assert
      verify(mockGetClimateForCurrentLocation(NoParams()));
    });

    test('should emit [loading,loaded] when data loaded successfully ',
        () async {
      // arrange
      when(mockGetClimateForCurrentLocation(any))
          .thenAnswer((_) async => Right(tClimate));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(climate: tClimate),
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetCurrentLocationClimate());
    });

    test(
        'should emit [loading,Error] with a proper message for the error where getting data fails ',
        () async {
      // arrange
      when(mockGetClimateForCurrentLocation(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetCurrentLocationClimate());
    });
  });

  group('GetInputLocationClimate', () {
    final tCity = 'Latakia';
    final tClimate = Climate(
      icon: 'icon',
      city: 'latakia',
      humidity: 50,
      temp: 33.0,
      tempMax: 35.0,
      tempMin: 25.0,
      weather: 'sunny',
      wind: 22.0,
    );

    test('should get data from the input location useCase  ', () async {
      // arrange
      when(mockGetClimateForInputLocation(any))
          .thenAnswer((_) async => Right(tClimate));
      // act
      bloc.dispatch(GetInputLocationClimate(city: tCity));
      await untilCalled(mockGetClimateForInputLocation(any));

      // assert
      verify(mockGetClimateForInputLocation(Param(tCity)));
    });

    test('should emit [loading,loaded] when data loaded successfully ',
        () async {
      // arrange
      when(mockGetClimateForInputLocation(any))
          .thenAnswer((_) async => Right(tClimate));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(climate: tClimate),
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetInputLocationClimate(city: tCity));
    });

    test(
        'should emit [loading,Error] with a proper message for the error where getting data fails ',
        () async {
      // arrange
      when(mockGetClimateForInputLocation(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetInputLocationClimate(city: tCity));
    });
  });
}
