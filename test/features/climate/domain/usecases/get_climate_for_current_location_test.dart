import 'package:climate/core/usecases/usecase.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:climate/features/climate/domain/repositories/climate_repository.dart';
import 'package:climate/features/climate/domain/usecases/get_climate_for_current_location.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockClimateRepository extends Mock implements ClimateRepository {}

void main() {
  MockClimateRepository mockClimateRepository;
  GetClimateForCurrentLocation useCase;

  setUp(() {
    mockClimateRepository = MockClimateRepository();
    useCase = GetClimateForCurrentLocation(repository: mockClimateRepository);
  });

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

  test('should return climate for current city ', () async {
    // arrange
    when(mockClimateRepository.getClimateForCurrentLocation())
        .thenAnswer((_) async => Right(tClimate));

    // act

    final result = await useCase(NoParams());

    // assert

    expect(result, Right(tClimate));
    verify(mockClimateRepository.getClimateForCurrentLocation());
    verifyNoMoreInteractions(mockClimateRepository);
  });
}
