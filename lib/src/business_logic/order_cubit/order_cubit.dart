import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/car.dart';
import 'package:seda/src/data/models/error_response.dart';
import 'package:seda/src/data/models/order_model.dart';
import 'package:seda/src/data/models/reponse_models/last_order_status_response_model.dart';
import 'package:seda/src/data/models/reponse_models/order_response.dart';
import 'package:seda/src/data/models/request_models/get_cars_request.dart';
import 'package:seda/src/data/models/request_models/make_order_request.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/toast.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(MakeOrderInitial());

  static OrderCubit get(context) => BlocProvider.of(context);

  OrderModel? orderModel;
  ErrorResponse? errorResponse;
  Future makeOrder({
    required MakeOrderRequest makeOrderRequest,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    printSuccess('==============================');
    emit(MakeOrderLoading());
    try {
      await DioHelper.postData(
        url: shipmentTypeId == 6
            ? EndPoints.epMakeHoursOrder
            : EndPoints.epMakeOrder,
        body: {
          "fromLocation[longitude]": makeOrderRequest.fromLocationLon,
          "fromLocation[latitude]": makeOrderRequest.fromLocationLat,
          "fromLocation[address]": makeOrderRequest.fromLocationAddress,
          'shipment_type_id': shipmentTypeId,
          'payment_type_id': paymentTypeId,
          if (shipmentTypeId == 6) "hours": makeOrderRequest.hours,
          'ride_type_id': rideTypeId,
          for (int i = 0; i < makeOrderRequest.toLocations.length; i++) ...{
            "toLocation[$i][latitude]": makeOrderRequest.toLocations[i][0],
            "toLocation[$i][longitude]": makeOrderRequest.toLocations[i][1],
            "toLocation[$i][address]": makeOrderRequest.toLocations[i][2],
          }
        },
        isForm: true,
      ).then((value) {
        printSuccess(
            'make order request: ${(value.requestOptions.data as FormData).fields}');
        printSuccess('make order response: ${value.data}');
        if (value.data['message'] == 'api.no driver founded please try later') {
          // showToast(
          //   'no driver founded please try later',
          //   color: AppColors.yellow,
          // );
          afterError?.call();
          emit(MakeOrderNoDrivers());
        } else {
          printResponse('MakeOrder response: $value');
          orderModel = OrderResponseModel.fromJson(value.data).data?.order ??
              OrderModel();
          CacheHelper.saveDataSharedPreference(
              key: SharedPreferenceKeys.orderId, value: orderModel?.id);
          afterSuccess();
          emit(MakeOrderSuccess());
        }
      });
    } on DioError catch (dioError) {
      printError('make order: ${dioError.response}');
      errorResponse = ErrorResponse.fromJson(dioError.response!.data);
      // showToast(errorResponse!.message.toString());
      afterError?.call();
      emit(MakeOrderFail());
    } catch (error) {
      showToast('error has occurred');
      afterError?.call();
      printError("MakeOrder Unknown Error: $error");
      emit(MakeOrderFail());
    }
  }

  Future getLastOrderStatus({
    required Function(OrderModel? order) afterSuccess,
    VoidCallback? afterError,
  }) async {
    printSuccess('==============================');
    emit(GetLastOrderStatusLoading());
    try {
      await DioHelper.getData(
        url: EndPoints.epLastStatusOrder,
      ).then((value) {
        printSuccess('getLastOrderStatus response: ${value.data}');
        if (value.statusCode == 200) {
          LastOrderStatusResponse lastOrderStatusResponse =
              LastOrderStatusResponse.fromJson(value.data);
          orderModel = OrderResponseModel.fromJson(value.data).data?.order;
          if (lastOrderStatusResponse.data?.order != null) {
            CacheHelper.saveDataSharedPreference(
                key: SharedPreferenceKeys.orderId,
                value: lastOrderStatusResponse.data?.order?.id);
            afterSuccess(lastOrderStatusResponse.data?.order);
            emit(GetLastOrderStatusSuccess());
          } else {
            afterError?.call();
            emit(GetLastOrderStatusFail());
          }
        }
      });
    } on DioError catch (dioError) {
      printError('getLastOrderStatus response error: ${dioError.response}');
      errorResponse = ErrorResponse.fromJson(dioError.response?.data);
      showToast(errorResponse!.message.toString());
      afterError?.call();
      emit(GetLastOrderStatusFail());
    } catch (error) {
      showToast('error has occurred');
      printError("getLastOrderStatus Unknown Error: $error");
      afterError?.call();
      emit(GetLastOrderStatusFail());
    }
  }

  Future addNewDropOff({
    required AddNewDropOff addNewDropOff,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    printSuccess('==============================');
    emit(AddNewDropOffLoading());
    try {
      final body = <String, dynamic>{
        "location[longitude]": addNewDropOff.toLocationLon,
        "location[latitude]": addNewDropOff.toLocationLat,
        "location[address]": addNewDropOff.toLocationAddress,
        'order_id': addNewDropOff.orderId,
      };
      await DioHelper.postData(
        url: EndPoints.epAddNewDropOff,
        body: body,
        isForm: true,
      ).then((value) {
        printSuccess(
            'add new drop off: ${(value.requestOptions.data as FormData).fields}');
        printSuccess('add new drop off: ${value.data}');
        if (value.data['message'] ==
            'api.drop off not added please try later') {
          showToast('no driver founded please try later');
          afterError?.call();
        } else {
          printResponse('add new drop off: $value');
          orderModel = OrderResponseModel.fromJson(value.data).data?.order;
          afterSuccess();
          emit(AddNewDropOffSuccess());
        }
      });
    } on DioError catch (dioError) {
      printError(
          'addNewDropOff: ${(dioError.requestOptions.data as FormData).fields}');
      printError('addNewDropOff: ${dioError.response}');
      errorResponse = ErrorResponse.fromJson(dioError.response!.data);
      showToast(errorResponse!.message.toString());
      afterError?.call();
      emit(AddNewDropOffFail());
    } catch (error) {
      showToast('error has occurred');
      afterError?.call();
      printError("AddNewDropOff Unknown Error: $error");
      emit(AddNewDropOffFail());
    }
  }

  Future cancelOrder({
    required String cancelReason,
    required int orderId,
    required VoidCallback afterSuccess,
    required VoidCallback afterError,
  }) async {
    emit(CancelOrderLoading());
    try {
      await DioHelper.postData(url: EndPoints.epCancelOrderByUser, body: {
        "orderId": orderId,
        'cancel_reason': cancelReason,
      }).then((value) {
        printSuccess(value.data["message"]);
        showToast(value.data["message"]);
        afterSuccess();
        emit(CancelOrderSuccess());
      });
    } on DioError catch (dioError) {
      afterError.call();
      printError(dioError.response.toString());
      errorResponse = ErrorResponse.fromJson(dioError.response!.data);
      showToast(errorResponse!.message.toString());
      emit(CancelOrderFail());
    } catch (error) {
      afterError.call();
      showToast('error has occurred');
      printError(error.toString());
      emit(CancelOrderFail());
    }
  }

  Cars carTypes = Cars();

  Future getCars({
    required BuildContext context,
    required GetCarsRequest getCarsRequest,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    if (getCarsRequest.fromLat == 0.0 ||
        getCarsRequest.fromLng == 0.0 ||
        getCarsRequest.toLocations
            .any((element) => element[0] == 0.0 || element[1] == 0.0)) {
      showToast(
        context.makeOrderValidationError,
        color: AppColors.yellow,
      );
      afterError?.call();
      return;
    }
    printSuccess('get cars: ${getCarsRequest.toJson().toString()}');
    emit(CarsLoading());
    try {
      await DioHelper.postData(
        url: EndPoints.epGetRideType,
        body: getCarsRequest.toJson(),
      ).then((value) {
        printSuccess(value.data.toString());
        carTypes = Cars.fromJson(value.data);
        afterSuccess();
        emit(GetCarsSuccess());
      });
    } on DioError catch (dioError) {
      printError("getCars response error: ${dioError.response}");
      printError("getCars response error: ${dioError.requestOptions.data}");
      errorResponse = ErrorResponse.fromJson(dioError.response!.data);
      if (errorResponse?.message
              ?.contains("Undefined array key \"distance\"") ==
          true) {
        showToast("You should select a valid locations");
      } else {
        showToast(errorResponse!.message.toString());
      }
      afterError?.call();
      emit(GetCarsFail());
    } catch (error) {
      showToast('error has occurred');
      printError("getCars error: $error");
      afterError?.call();
      emit(GetCarsFail());
    }
  }

  Future confirmDriverOffer({
    required int orderSentToDriverId,
    Function()? afterSuccess,
    Function()? afterError,
  }) async {
    const tag = 'confirmDriverOffer';
    emit(ConfirmDriverOfferLoading());
    try {
      final response = await DioHelper.postData(
        url: EndPoints.epAcceptOfferByUserController,
        body: {
          'order_id': CacheHelper.getDataFromSharedPreference(
            key: SharedPreferenceKeys.orderId,
          ),
          'order_sent_to_driver_id': orderSentToDriverId,
        },
        isForm: true,
      );
      printSuccess("$tag response: ${response.data}");
      afterSuccess?.call();
      emit(ConfirmDriverOfferSuccess());
    } on DioError catch (dioError) {
      printError("$tag response error: ${dioError.response}");
      errorResponse = ErrorResponse.fromJson(dioError.response!.data);
      showToast(errorResponse!.message.toString());
      afterError?.call();
      emit(ConfirmDriverOfferFail());
    } catch (error) {
      showToast('error has occurred');
      printError("$tag error: $error");
      afterError?.call();
      emit(ConfirmDriverOfferFail());
    }
  }

  Future changePayment({
    required int paymentTypeId,
    Function(int id)? afterSuccess,
    Function()? afterError,
  }) async {
    const tag = 'change Payment';
    emit(ChangePaymentLoading());
    try {
      final response = await DioHelper.postData(
        url: EndPoints.epChangePayment,
        body: {
          'order_id': CacheHelper.getDataFromSharedPreference(
            key: SharedPreferenceKeys.orderId,
          ),
          'payment_type_id': paymentTypeId,
        },
        isForm: true,
      );
      printSuccess("$tag response: ${response.data}");
      orderModel = OrderResponseModel.fromJson(response.data).data?.order ??
          OrderModel();
      afterSuccess?.call(orderModel?.paymentTypeId ?? 1);
      emit(ChangePaymentSuccess());
    } on DioError catch (dioError) {
      printError("$tag response error: ${dioError.response}");
      printError(
          "$tag request: ${(dioError.requestOptions.data as FormData).fields}");
      errorResponse = ErrorResponse.fromJson(dioError.response!.data);
      showToast(errorResponse!.message.toString());
      afterError?.call();
      emit(ChangePaymentFail());
    } catch (error) {
      showToast('error has occurred');
      printError("$tag error: $error");
      afterError?.call();
      emit(ChangePaymentFail());
    }
  }
}
