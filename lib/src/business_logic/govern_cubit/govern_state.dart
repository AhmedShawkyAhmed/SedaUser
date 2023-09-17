part of 'govern_cubit.dart';

@immutable
abstract class GovernState {}

class GovernInitial extends GovernState {}

class GetValidSharedOrdersLoadingState extends GovernState {}

class GetValidSharedOrdersSuccessState extends GovernState {}

class GetValidSharedOrdersFailureState extends GovernState {}

class GetMyValidSharedOrdersLoadingState extends GovernState {}

class GetMyValidSharedOrdersSuccessState extends GovernState {}

class GetMyValidSharedOrdersFailureState extends GovernState {}

class ApplySharedOrderLoadingState extends GovernState {}

class ApplySharedOrderSuccessState extends GovernState {}

class ApplySharedOrderFailureState extends GovernState {}
