part of 'location_cubit.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class GetAllLocationsLoadingState extends LocationState {}
class GetAllLocationsSuccessState extends LocationState {}
class GetAllLocationsProblemState extends LocationState {}
class GetAllLocationsFailureState extends LocationState {}

class AddLocationLoadingState extends LocationState {}
class AddLocationSuccessState extends LocationState {}
class AddLocationProblemState extends LocationState {}
class AddLocationFailureState extends LocationState {}

class UpdateLocationLoadingState extends LocationState {}
class UpdateLocationSuccessState extends LocationState {}
class UpdateLocationProblemState extends LocationState {}
class UpdateLocationFailureState extends LocationState {}

class DeleteLocationLoadingState extends LocationState {}
class DeleteLocationSuccessState extends LocationState {}
class DeleteLocationProblemState extends LocationState {}
class DeleteLocationFailureState extends LocationState {}

class GetRecentLocationLoadingState extends LocationState {}
class GetRecentLocationSuccessState extends LocationState {}
class GetRecentLocationProblemState extends LocationState {}
class GetRecentLocationFailureState extends LocationState {}
