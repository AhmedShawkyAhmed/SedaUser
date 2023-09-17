part of 'ride_cubit.dart';

@immutable
abstract class RideState {}

class RideInitial extends RideState {}

class ConfirmRideButtonState extends RideState {}

class ConfirmRateState extends RideState {}

class IsSearchingState extends RideState {}

class IncFareState extends RideState {}

class DecFareState extends RideState {}
