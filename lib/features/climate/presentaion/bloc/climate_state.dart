part of 'climate_bloc.dart';

abstract class ClimateState extends Equatable {
  ClimateState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends ClimateState {}

class Loading extends ClimateState {}

class Loaded extends ClimateState {
  final Climate climate;

  Loaded({this.climate}) : super([climate]);
}

class Error extends ClimateState {
  final String message;

  Error({this.message}) : super([message]);
}
