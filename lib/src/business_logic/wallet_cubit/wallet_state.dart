part of 'wallet_cubit.dart';

@immutable
abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletGetDataLoadingState extends WalletState {}

class WalletGetDataSuccessState extends WalletState {}

class WalletGetDataFailureState extends WalletState {}

class WalletGetPointDataLoadingState extends WalletState {}

class WalletGetPointDataSuccessState extends WalletState {}

class WalletGetPointDataFailureState extends WalletState {}
