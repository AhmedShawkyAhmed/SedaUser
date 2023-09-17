import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ride_state.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit() : super(RideInitial());

  static RideCubit get(BuildContext context) => BlocProvider.of(context);

  bool isSearchingLocation = false;

  void toggleIsSearching(bool active) {
    isSearchingLocation = active;
    emit(IsSearchingState());
  }

  double fare = 0;

  void incFare() {
    fare += 1;
    emit(IncFareState());
  }

  void decFare() {
    fare -= 1;
    emit(DecFareState());
  }
}
