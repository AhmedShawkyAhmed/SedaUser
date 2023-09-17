import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/car.dart';
import 'package:seda/src/data/models/reponse_models/auth/profile_response/profile_response_model.dart';
import 'package:seda/src/data/models/reponse_models/auth/register_response/register_response_model.dart';
import 'package:seda/src/data/models/reponse_models/auth/verify_orp_response/verify_otp_response_model.dart';
import 'package:seda/src/data/models/reponse_models/auth/verify_phone_response/verify_phone_response_model.dart';
import 'package:seda/src/data/models/reponse_models/order_details_response.dart';
import 'package:seda/src/data/models/reponse_models/order_history_response.dart';
import 'package:seda/src/data/models/request_models/request_model.dart';
import 'package:seda/src/data/models/user_model.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/toast.dart';

import '../../constants/constants_variables.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;

  AuthCubit(this._auth) : super(AuthInitial());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  List<String>? phone;
  String? _verId;
  UserCredential? _user;
  UserModel? currentUser;

  Future verifyFirebasePhone({
    required List<String> phoneNumber,
    required Function() afterSuccess,
    required Function() afterError,
  }) async {
    try {
      phone = phoneNumber;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.join(''),
        timeout: const Duration(minutes: 2),
        verificationCompleted: (cred) {},
        verificationFailed: (e) {
          showToast(
            'Phone Verification ${e.message}',
            color: AppColors.green,
            textColor: AppColors.white,
          );
          debugPrint('\x1B[31m verifyPhone error message: ${e.message}\x1B[0m');
          afterError();
          if (Platform.isAndroid) {
            emit(VerifyPhoneVerifyErrorState());
          }
        },
        codeSent: (verId, resCode) {
          _verId = verId;
          afterSuccess();
        },
        codeAutoRetrievalTimeout: (verID) {
          if (_user == null) {
            showToast('Phone Verification Timeout', color: AppColors.red);
            debugPrint('\x1B[31m Phone Verification Timeout\x1B[0m');
            // afterError();
          }
        },
      );
    } catch (e) {
      showToast('Phone Verification Failure', color: AppColors.red);
      afterError();
    }
  }

  Future verifyFirebaseOTp({
    required String code,
  }) async {
    try {
      emit(VerifyingOtpLoadingState());
      final cred = PhoneAuthProvider.credential(
        verificationId: _verId!,
        smsCode: code,
      );
      _user = await _auth.signInWithCredential(cred);
      if (_user?.user != null) {
        // showToast(
        //   'Phone Verification Success',
        //   color: AppColors.green,
        //   textColor: AppColors.white,
        // );
        _user?.user?.delete();
        emit(VerifyingOtpSuccessState());
      } else {
        showToast('Invalid OTP', color: AppColors.red);
        emit(VerifyingOtpFailureState());
      }
    } catch (e) {
      showToast('OTP Verification Failure', color: AppColors.red);
      debugPrint('\x1B[31m verifyOTp error: $e\x1B[0m');
      emit(VerifyingOtpFailureState());
    }
  }

  Future verifyPhone({
    required List<String> phone,
    required Function() afterSuccess,
    Function()? afterError,
  }) async {
    String tag = 'AuthCubit - verifyPhone - ';
    try {
      emit(AuthVerifyPhoneLoadingState());
      final response = await DioHelper.postData(
        url: EndPoints.epVerifyPhone,
        body: {
          'dial_code': phone[0],
          'phone': phone[1],
          'type': 'user',
        },
      );
      printSuccess(
        '${tag}response: $response',
      );
      if (response.statusCode == 200) {
        final verifyPhoneResponseModel = VerifyPhoneResponseModel.fromJson(
          response.data,
        );
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.gistVerifyPhoneToken,
          value: verifyPhoneResponseModel.data?.token,
        );
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.gistVerifyPhoneOtp,
          value: verifyPhoneResponseModel.data?.otp,
        );
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.gistPhone,
          value: phone[1],
        );
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.gistDialCode,
          value: phone[0],
        );
        afterSuccess();
        emit(AuthVerifyPhoneSuccessState());
      } else {
        emit(
          AuthVerifyPhoneErrorState(
            (response.data['message'] as String?)?.replaceAll('api.', '') ??
                'Error Verifying Phone',
          ),
        );
      }
    } on DioError catch (e) {
      afterError?.call();
      printWarning(
        '${tag}error request end point: ${e.requestOptions.path}',
      );
      printWarning(
        '${tag}error request data: ${e.requestOptions.data}',
      );
      printError(
        '${tag}error response: ${e.response}',
      );
      printError(
        '${tag}error Dio response: $e',
      );
      showToast(e.response?.data['message'] ?? 'Error Verifying Phone');
      emit(
        AuthVerifyPhoneErrorState(
          (e.response?.data['message'] as String?)?.replaceAll('api.', '') ??
              'Error Verifying Phone',
        ),
      );
    } catch (e) {
      afterError?.call();
      printError('${tag}error: $e');
      emit(AuthVerifyPhoneErrorState('Error Verifying Phone'));
    }
  }

  Future verifyOTP({
    required String otp,
    required Function({required bool showMsg}) toHome,
    required Function({required bool showMsg}) toRegister,
    Function()? afterError,
  }) async {
    String tag = 'AuthCubit - verifyOTP - ';
    try {
      emit(AuthVerifyOTPLoadingState());
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.gistVerifyPhoneToken,
      );
      final response = await DioHelper.postData(
        url: EndPoints.epVerifyOTP,
        token: token,
        body: {
          'otp': otp,
        },
      );
      printSuccess(
        '${tag}response: $response',
      );
      // if (response.statusCode == 200) {
      //   final verifyOtpResponseModel = VerifyOtpResponseModel.fromJson(
      //     response.data,
      //   );
      //   CacheHelper.saveDataSharedPreference(
      //     // key: verifyOtpResponseModel.data?.user == true && login
      //     key: verifyOtpResponseModel.data?.user == true
      //         ? SharedPreferenceKeys.userToken
      //         : SharedPreferenceKeys.gistVerifyOtpToken,
      //     value: verifyOtpResponseModel.data?.token,
      //   );
      //   if (isLogin && verifyOtpResponseModel.data?.user == true) {
      //     toHome(showMsg: false);
      //   } else if (isLogin && verifyOtpResponseModel.data?.user == false) {
      //     toRegister(
      //       showMsg: true,
      //     );
      //   } else if (!isLogin && verifyOtpResponseModel.data?.user == true) {
      //     toHome(
      //       showMsg: true,
      //     );
      //   } else if (!isLogin && verifyOtpResponseModel.data?.user == false) {
      //     toRegister(showMsg: false);
      //   }
      //   emit(
      //     AuthVerifyOTPSuccessState(
      //       verifyOtpResponseModel.data?.user == true,
      //     ),
      //   );
      // } else {
      //   emit(
      //     AuthVerifyOTPErrorState(
      //       (response.data['message'] as String?)?.replaceAll('api.', '') ??
      //           'Error Verifying OTP Code',
      //     ),
      //   );
      // }
    } on DioError catch (e) {
      printWarning(
        '${tag}error request end point: ${e.requestOptions.path}',
      );
      printWarning(
        '${tag}error request data: ${e.requestOptions.data}',
      );
      printError(
        '${tag}error response: ${e.response}',
      );
      afterError?.call();
      emit(
        AuthVerifyOTPErrorState(
          (e.response?.data['message'] as String?)?.replaceAll('api.', '') ??
              'Error Verifying OTP Code',
        ),
      );
    } catch (e) {
      printError('${tag}error: $e');
      afterError?.call();
      emit(AuthVerifyOTPErrorState('Error Verifying OTP Code'));
    }
  }

  Future register({
    required RegisterRequest registerRequest,
    required Function() afterSuccess,
    Function()? afterError,
  }) async {
    String tag = 'AuthCubit - register - ';
    try {
      emit(AuthRegisterLoadingState());
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.gistVerifyOtpToken,
      );

      final response = await DioHelper.postData(
        token: token,
        url: EndPoints.epRegister,
        body: {
          'name': registerRequest.name,
          if (registerRequest.nickName != null)
            'nickName': registerRequest.nickName,
          if (registerRequest.birth != null) 'birth': registerRequest.birth,
          if (registerRequest.email != null) 'email': registerRequest.email,
          'userDetails[type]': 'user',
          if (registerRequest.image != null)
            'image': MultipartFile.fromFileSync(
              registerRequest.image!,
              filename: registerRequest.image!.split('/').last,
            ),
          if (registerRequest.gender != null)
            'gender': registerRequest.gender?.val,
        },
        isForm: true,
      );
      printSuccess(
        '${tag}response: $response',
      );
      if (response.statusCode == 200) {
        final registerResponseModel = RegisterResponseModel.fromJson(
          response.data,
        );
        afterSuccess();
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.userToken,
          value: registerResponseModel.data?.token,
        );
        emit(AuthRegisterSuccessState());
      } else {
        emit(
          AuthVerifyOTPErrorState(
            (response.data['message'] as String?)?.replaceAll('api.', '') ??
                'Error creating new account',
          ),
        );
      }
    } on DioError catch (e) {
      afterError?.call();
      printWarning(
        '${tag}error request end point: ${e.requestOptions.path}',
      );
      printWarning(
        '${tag}error request data: ${e.requestOptions.data}',
      );
      printError(
        '${tag}error response: ${e.response}',
      );
      emit(
        AuthRegisterErrorState(
          (e.response?.data['message'] as String?)?.replaceAll('api.', '') ??
              'Error creating new account',
        ),
      );
    } catch (e) {
      afterError?.call();
      printError('${tag}error: $e');
      emit(AuthRegisterErrorState('Error creating new account'));
    }
  }

  Future updateProfile({
    String? name,
    String? nickName,
    String? birthDate,
    String? email,
    String? image,
  }) async {
    String tag = 'AuthCubit - updateProfile - ';
    try {
      emit(AuthUpdateProfileLoadingState());
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.userToken,
      );
      final body = <String, dynamic>{};
      body['name'] = name;
      body['nickName'] = nickName;
      body['birth'] = birthDate;
      body['email'] = email;
      if (image != null) {
        body['image'] = MultipartFile.fromFileSync(
          image,
          filename: image,
        );
      }
      final response = await DioHelper.postData(
        token: token,
        url: EndPoints.epUpdateProfile,
        body: body,
        isForm: true,
      );
      printSuccess(
        '${tag}request: ${(response.requestOptions.data as FormData).fields}',
      );
      printSuccess(
        '${tag}response: $response',
      );
      if (response.statusCode == 200) {
        final profileResponseModel = ProfileResponseModel.fromJson(
          response.data,
        );
        currentUser = profileResponseModel.data?.user;
        emit(AuthUpdateProfileSuccessState());
      } else {
        emit(
          AuthUpdateProfileErrorState(
            (response.data['message'] as String?)?.replaceAll('api.', '') ??
                'Error Updating Profile Data',
          ),
        );
      }
    } on DioError catch (e) {
      printWarning(
        '${tag}error request end point: ${e.requestOptions.path}',
      );
      printWarning(
        '${tag}error request data: ${e.requestOptions.data}',
      );
      printError(
        '${tag}error response: ${e.response}',
      );
      emit(
        AuthUpdateProfileErrorState(
          (e.response?.data['message'] as String?)?.replaceAll('api.', '') ??
              'Error Updating Profile Data',
        ),
      );
    } catch (e) {
      printError('${tag}error: $e');
      emit(AuthUpdateProfileErrorState('Error Updating Profile Data'));
    }
  }

  Future sendFCM(
      {required String fcm, required VoidCallback afterSuccess}) async {
    emit(AuthFcmSendingLoadingState());
    try {
      await DioHelper.putData(
        url: EndPoints.epUpdateFcm,
        body: {
          'fcm': fcm,
        },
      ).then((value) {
        afterSuccess();
        emit(AuthFcmSendingSuccessState());
      });
    } on DioError catch (dioError) {
      emit(AuthFcmSendingProblemState());
      showToast(dioError.message);
    } catch (error) {
      emit(AuthFcmSendingFailureState());
      printError(error.toString());
      showToast('error has occurred');
    }
  }

  OrdersHistory ordersHistory = OrdersHistory();
  int pages = 0;
  List<Orders> historyOrders = [];

  Future getHistory(
      {VoidCallback? afterSuccess, int? page, String? date}) async {
    if (page == null) ordersHistory = OrdersHistory();
    emit(AuthOrderHistoryLoadingState());
    try {
      await DioHelper.getData(
        url: EndPoints.epHistoryOrder,
        query: {
          'page': page,
          'date': date,
          'per_page': 5000,
        },
      ).then((value) {
        if (page == null) {
          ordersHistory = OrdersHistory.fromJson(value.data);
          historyOrders = ordersHistory.data.orders;
          historyOrders = historyOrders.reversed.toList();
          pages = ordersHistory.data.pages;
          printSuccess('-----------$pages');
          printSuccess('-----------$historyOrders');
        } else {
          final newOrdersHistory = OrdersHistory.fromJson(value.data);
          ordersHistory.data.orders.addAll(newOrdersHistory.data.orders);
          historyOrders = ordersHistory.data.orders;
        }
        afterSuccess?.call();
        emit(AuthOrderHistorySuccessState());
      });
    } on DioError catch (dioError) {
      emit(AuthOrderHistoryProblemState());
      printError("getHistory response error: ${dioError.response}");
      showToast(dioError.message);
    } catch (error) {
      emit(AuthOrderHistoryFailureState());
      printError("getHistory unknown error: $error");
      showToast('error has occurred');
    }
  }

  Car? driverCar;
  OrderDetails? orderDetails;

  Future getOrderDetails(
      {required VoidCallback afterSuccess,
      VoidCallback? afterError,
      int? id}) async {
    emit(AuthOrderHistoryLoadingState());
    try {
      await DioHelper.postData(
          url: EndPoints.epGetMyOrders, body: {'order_id': id}).then((value) {
        log(value.data.toString());
        orderDetails = OrderDetails.fromJson(value.data);
        log(value.data['data']['car'].toString());
        if (value.data['data']['car'] != null) {
          driverCar = Car.fromJson(value.data['data']['car']);
        }
        afterSuccess();
        emit(AuthOrderHistorySuccessState());
      });
    } on DioError catch (dioError) {
      emit(AuthOrderHistoryProblemState());
      printError("getOrderDetails response error: ${dioError.response}");
      showToast(dioError.message);
      afterError?.call();
    } catch (error) {
      emit(AuthOrderHistoryFailureState());
      printError("getOrderDetails unknown error: $error");
      showToast('error has occurred');
      afterError?.call();
    }
  }

  Future getProfile({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    String tag = 'AuthCubit - getProfile - ';
    try {
      emit(AuthGetProfileLoadingState());
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.userToken,
      );

      final response = await DioHelper.getData(
        token: token,
        url: EndPoints.epGetProfile,
      );
      printSuccess(
        '${tag}response: $response',
      );
      if (response.statusCode == 200) {
        final profileResponseModel = ProfileResponseModel.fromJson(
          response.data,
        );
        currentUser = profileResponseModel.data?.user;
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.userId,
          value: currentUser?.id,
        );
        emit(AuthGetProfileSuccessState());
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        emit(
          AuthGetProfileErrorState(
            (response.data['message'] as String?)?.replaceAll('api.', '') ??
                'Error Getting Profile Data',
          ),
        );
      }
    } on DioError catch (e) {
      printWarning(
        '${tag}error request end point: ${e.requestOptions.path}',
      );
      printWarning(
        '${tag}error request data: ${e.requestOptions.data}',
      );
      printError(
        '${tag}error response: ${e.response}',
      );
      emit(
        AuthGetProfileErrorState(
          (e.response?.data['message'] as String?)?.replaceAll('api.', '') ??
              'Error Getting Profile Data',
        ),
      );
      if (onFailure != null) {
        onFailure();
      }
    } catch (e) {
      printError('${tag}error: $e');
      emit(AuthGetProfileErrorState('Error Getting Profile Data'));
    }
  }

  Future logout({
    VoidCallback? afterSuccess,
    VoidCallback? afterError,
  }) async {
    String tag = 'AuthCubit - logout - ';
    try {
      emit(AuthLogoutLoadingState());
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.userToken,
      );
      final response = await DioHelper.getData(
        url: EndPoints.epLogout,
        token: token,
      );
      printSuccess(
        '${tag}response: $response',
      );
      if (response.statusCode == 200) {
        // final logoutResponseModel = LogoutResponseModel.fromJson(
        //   response.data,
        // );
        await CacheHelper.clearData();
        emit(AuthLogoutSuccessState());
        afterSuccess?.call();
      } else {
        emit(
          AuthVerifyOTPErrorState(
            (response.data['message'] as String?)?.replaceAll('api.', '') ??
                'Error Logging Out',
          ),
        );
        afterError?.call();
      }
    } on DioError catch (e) {
      printWarning(
        '${tag}error request end point: ${e.requestOptions.path}',
      );
      printWarning(
        '${tag}error request data: ${e.requestOptions.data}',
      );
      printError(
        '${tag}error response: ${e.response}',
      );
      emit(
        AuthLogoutErrorState(
          (e.response?.data['message'] as String?)?.replaceAll('api.', '') ??
              'Error Logging Out',
        ),
      );
      afterError?.call();
    } catch (e) {
      printError('${tag}error: $e');
      emit(AuthLogoutErrorState('Error Logging Out'));
      afterError?.call();
    }
  }
}
