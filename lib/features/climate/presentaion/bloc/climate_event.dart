part of 'climate_bloc.dart';

abstract class ClimateEvent extends Equatable {
  ClimateEvent([List props = const <dynamic>[]]) : super(props);
}

class GetCurrentLocationClimate extends ClimateEvent {}

class GetInputLocationClimate extends ClimateEvent {
  final String city;

  GetInputLocationClimate({this.city});
}
