import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/location/location.dart';
import 'core/network/network_info.dart';
import 'features/climate/data/datasources/local_data_source.dart';
import 'features/climate/data/datasources/remote_data_source.dart';
import 'features/climate/data/repositories/climate_repository_impl.dart';
import 'features/climate/domain/repositories/climate_repository.dart';
import 'features/climate/domain/usecases/get_climate_for_current_location.dart';
import 'features/climate/domain/usecases/get_climate_for_input_location.dart';
import 'features/climate/presentaion/bloc/climate_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // 1.Features

  //Bloc

  sl.registerFactory(() => ClimateBloc(
        getClimateForCurrentLocation: sl(),
        getClimateForInputLocation: sl(),
      ));

  //UseCases

  sl.registerLazySingleton(
      () => GetClimateForCurrentLocation(repository: sl()));
  sl.registerLazySingleton(() => GetClimateForInputLocation(repository: sl()));

  //Repository

  sl.registerLazySingleton<ClimateRepository>(() => ClimateRepositoryImpl(
        remoteDateSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));

  //Data sources

  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(
        location: sl(),
        client: sl(),
      ));
  sl.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(sharedPreference: sl()));

  // 2.Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<Location>(() => LocationImpl());

  // 3.External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => DataConnectionChecker());
}
