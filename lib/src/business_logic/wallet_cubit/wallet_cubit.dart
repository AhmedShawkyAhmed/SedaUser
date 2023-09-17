import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/points.dart';
import 'package:seda/src/data/models/wallet.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  static WalletCubit get(BuildContext context) => BlocProvider.of(context);

  final _globalTag = 'WalletCubit';

  WalletModel wallet = WalletModel();
  Points points = Points();

  Future getWalletData({
    Function()? onSuccess,
    Function()? onError,
  }) async {
    final localTag = '$_globalTag - getWalletData';
    try {
      emit(WalletGetDataLoadingState());
      final response = await DioHelper.getData(
        url: EndPoints.getWalletData,
      );
      if (response.statusCode == 200) {
        printSuccess('$localTag - response: ${response.data}');
        wallet = WalletModel.fromJson(response.data);
        emit(WalletGetDataSuccessState());
        onSuccess?.call();
      } else {
        printError('$localTag - response error: ${response.data}');
        emit(WalletGetDataFailureState());
        onError?.call();
      }
    } on DioError catch (e) {
      printError('$localTag - response error: ${e.response}');
      emit(WalletGetDataFailureState());
      onError?.call();
    } catch (e) {
      printError('$localTag - Error: $e');
      emit(WalletGetDataFailureState());
      onError?.call();
    }
  }

  Future getPointData({
    Function()? onSuccess,
    Function()? onError,
  }) async {
    final localTag = '$_globalTag - getPointData';
    try {
      emit(WalletGetPointDataLoadingState());
      final response = await DioHelper.getData(
        url: EndPoints.getUserPointData,
      );
      if (response.statusCode == 200) {
        printSuccess('$localTag - response: ${response.data}');
        points = Points.fromJson(response.data);
        emit(WalletGetPointDataSuccessState());
        onSuccess?.call();
      } else {
        printError('$localTag - response error: ${response.data}');
        emit(WalletGetPointDataFailureState());
        onError?.call();
      }
    } on DioError catch (e) {
      printError('$localTag - response error: ${e.response}');
      emit(WalletGetPointDataFailureState());
      onError?.call();
    } catch (e) {
      printError('$localTag - Error: $e');
      emit(WalletGetPointDataFailureState());
      onError?.call();
    }
  }
}
