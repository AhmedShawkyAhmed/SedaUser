import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/reponse_models/govern_response_model.dart';
import 'package:seda/src/data/models/request_models/apply_shared_order_request_model.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/toast.dart';

part 'govern_state.dart';

class GovernCubit extends Cubit<GovernState> {
  GovernCubit() : super(GovernInitial());

  static GovernCubit get(BuildContext context) => BlocProvider.of(context);

  GovernResponseModel? _myValidModel;

  GovernResponseModel? _validModel;

  GovernResponseModel? get validModel => _validModel;

  GovernResponseModel? get myValidModel => _myValidModel;

  Future getValidSharedOrders() async {
    emit(GetValidSharedOrdersLoadingState());
    try {
      await DioHelper.getData(
        url: EndPoints.epGetValidShardOrders,
      ).then((value) {
        if (value.statusCode == 200) {
          _validModel = GovernResponseModel.fromJson(value.data);
          printSuccess("GovernCubit getValidSharedOrders response: $value");
          showToast(
            value.data["message"] ?? 'Valid Orders Fetched Successfully',
            color: AppColors.midGreen,
            gravity: ToastGravity.BOTTOM,
          );
          emit(GetValidSharedOrdersSuccessState());
        } else {
          showToast(
            value.data["message"] ?? 'error has occurred',
            color: AppColors.lightRed,
            gravity: ToastGravity.BOTTOM,
          );
          printError("GovernCubit getValidSharedOrders error response: $value");
          emit(GetValidSharedOrdersFailureState());
        }
      });
    } on DioError catch (dioError) {
      printError("GovernCubit getValidSharedOrders error response: $dioError");
      showToast(
        dioError.response?.statusMessage.toString() ?? 'error has occurred',
        color: AppColors.lightRed,
        gravity: ToastGravity.BOTTOM,
      );
      emit(GetValidSharedOrdersFailureState());
    } catch (error) {
      showToast(
        'error has occurred',
        color: AppColors.lightRed,
        gravity: ToastGravity.BOTTOM,
      );
      printError("GovernCubit getValidSharedOrders error: $error");
      emit(GetValidSharedOrdersFailureState());
    }
  }

  Future getMyValidSharedOrders() async {
    emit(GetMyValidSharedOrdersLoadingState());
    try {
      await DioHelper.getData(
        url: EndPoints.epGetMyValidShardOrders,
      ).then((value) {
        if (value.statusCode == 200) {
          _myValidModel = GovernResponseModel.fromJson(value.data);
          printSuccess("GovernCubit getValidSharedOrders response: $value");
          showToast(
            value.data["message"] ?? 'My Valid Orders Fetched Successfully',
            color: AppColors.midGreen,
            gravity: ToastGravity.BOTTOM,
          );
          emit(GetMyValidSharedOrdersSuccessState());
        } else {
          showToast(
            value.data["message"] ?? 'error has occurred',
            color: AppColors.lightRed,
            gravity: ToastGravity.BOTTOM,
          );
          printError("GovernCubit getValidSharedOrders error response: $value");
          emit(GetMyValidSharedOrdersFailureState());
        }
      });
    } on DioError catch (dioError) {
      printError("GovernCubit getValidSharedOrders error response: $dioError");
      showToast(
        dioError.response?.statusMessage.toString() ?? 'error has occurred',
        color: AppColors.lightRed,
        gravity: ToastGravity.BOTTOM,
      );
      emit(GetMyValidSharedOrdersFailureState());
    } catch (error) {
      showToast(
        'error has occurred',
        color: AppColors.lightRed,
        gravity: ToastGravity.BOTTOM,
      );
      printError("GovernCubit getValidSharedOrders error: $error");
      emit(GetMyValidSharedOrdersFailureState());
    }
  }

  Future applySharedOrder(ApplySharedOrderRequestModel requestModel) async {
    emit(ApplySharedOrderLoadingState());
    try {
      await DioHelper.postData(
              url: EndPoints.epApplyShardOrder,
              body: requestModel.toJson(),
              isForm: true)
          .then((value) {
        if (value.statusCode == 200) {
          printSuccess("GovernCubit applySharedOrder response: $value");
          showToast(
            value.data["message"] ?? 'Order Applied Successfully',
            color: AppColors.midGreen,
            gravity: ToastGravity.BOTTOM,
          );
          emit(ApplySharedOrderSuccessState());
        } else {
          showToast(
            value.data["message"] ?? 'error has occurred',
            color: AppColors.lightRed,
            gravity: ToastGravity.BOTTOM,
          );
          printError("GovernCubit applySharedOrder error response: $value");
          emit(ApplySharedOrderFailureState());
        }
      });
    } on DioError catch (dioError) {
      printError("GovernCubit applySharedOrder error response: $dioError");
      showToast(
        dioError.response?.statusMessage ?? 'error has occurred',
        color: AppColors.lightRed,
        gravity: ToastGravity.BOTTOM,
      );
      emit(ApplySharedOrderFailureState());
    } catch (error) {
      showToast(
        'error has occurred',
        color: AppColors.lightRed,
        gravity: ToastGravity.BOTTOM,
      );
      printError("GovernCubit applySharedOrder error: $error");
      emit(ApplySharedOrderFailureState());
    }
  }
}
