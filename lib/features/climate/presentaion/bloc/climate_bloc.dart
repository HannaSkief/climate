import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:climate/core/error/failure.dart';
import 'package:climate/core/usecases/usecase.dart';
import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:climate/features/climate/domain/usecases/get_climate_for_current_location.dart';
import 'package:climate/features/climate/domain/usecases/get_climate_for_input_location.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'climate_event.dart';

part 'climate_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';
const String Location_FAILURE_MESSAGE = 'Can not get current location ';

class ClimateBloc extends Bloc<ClimateEvent, ClimateState> {
  final GetClimateForCurrentLocation getClimateForCurrentLocation;
  final GetClimateForInputLocation getClimateForInputLocation;

  ClimateBloc({
    @required this.getClimateForCurrentLocation,
    @required this.getClimateForInputLocation,
  });

  @override
  ClimateState get initialState => Empty();

  @override
  Stream<ClimateState> mapEventToState(
    ClimateEvent event,
  ) async* {
    if (event is GetCurrentLocationClimate) {
      yield Loading();
      final failureOrClimate = await getClimateForCurrentLocation(NoParams());
      yield failureOrClimate.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (climate) => Loaded(climate: climate),
      );
    } else if (event is GetInputLocationClimate) {
      yield Loading();
      final failureOrClimate =
          await getClimateForInputLocation(Param(event.city));
      yield failureOrClimate.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (climate) => Loaded(climate: climate),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case LocationFailure:
        return Location_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
