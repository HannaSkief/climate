import 'package:climate/core/error/failure.dart';
import 'package:climate/core/usecases/usecase.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:climate/features/climate/domain/repositories/climate_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetClimateForCurrentLocation implements UseCase<Climate, NoParams> {
  final ClimateRepository repository;

  GetClimateForCurrentLocation({@required this.repository});

  @override
  Future<Either<Failure, Climate>> call(NoParams param) async {
    return await repository.getClimateForCurrentLocation();
  }
}
