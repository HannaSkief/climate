import 'package:dartz/dartz.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:climate/core/error/failure.dart';

abstract class ClimateRepository{

  Future<Either<Failure,Climate>> getClimateForCurrentLocation();
  Future<Either<Failure,Climate>> getClimateForInputLocation(String city);

}