import 'package:climate/core/error/failure.dart';
import 'package:climate/core/usecases/usecase.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:climate/features/climate/domain/repositories/climate_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetClimateForInputLocation implements UseCase<Climate, Param> {
  final ClimateRepository repository;

  GetClimateForInputLocation({@required this.repository});

  @override
  Future<Either<Failure, Climate>> call(Param param) async {
    return await repository.getClimateForInputLocation(param.city);
  }
}

class Param extends Equatable {
  final String city;

  Param(this.city) : super([city]);
}
