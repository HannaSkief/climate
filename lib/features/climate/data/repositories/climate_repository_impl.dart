import 'package:climate/core/error/exception.dart';
import 'package:climate/core/error/failure.dart';
import 'package:climate/core/location/location.dart';
import 'package:climate/core/network/network_info.dart';
import 'package:climate/features/climate/data/datasources/local_data_source.dart';
import 'package:climate/features/climate/data/datasources/remote_data_source.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:climate/features/climate/domain/repositories/climate_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class ClimateRepositoryImpl implements ClimateRepository {
  final RemoteDataSource remoteDateSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ClimateRepositoryImpl({
    @required this.remoteDateSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Climate>> getClimateForCurrentLocation() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDateSource.getClimateForCurrentLocation();
        localDataSource.cacheClimate(remoteData);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      } on LocationException {
        return Left(LocationFailure());
      }
    } else {
      try {
        final localData = await localDataSource.getLastClimate();

        return Right(localData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Climate>> getClimateForInputLocation(
      String city) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDateSource.getClimateForInputLocation(city);
        localDataSource.cacheClimate(remoteData);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localData = await localDataSource.getLastClimate();

        return Right(localData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
