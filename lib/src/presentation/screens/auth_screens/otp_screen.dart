// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/constants/tools/string.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? _otp;

  _toRegister({required bool showMsg}) {
    if (showMsg) {
      showToast(
        context.guestLoginError,
        color: AppColors.orange,
        textColor: AppColors.white,
        shortLength: false,
      );
    }
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, AppRouterNames.fillProfile);
  }

  _toHome({required bool showMsg}) {
    if (showMsg) {
      showToast(
        context.userRegisterError,
        color: AppColors.orange,
        textColor: AppColors.white,
        shortLength: false,
      );
    }
    OrderCubit.get(context).getLastOrderStatus(
      afterSuccess: (order) {
        if (order != null) {
          fromLocationLat = order.fromLocation!.latitude!;
          fromLocationLon = order.fromLocation!.longitude!;
          fromLocationAddressController.text =
              order.fromLocation!.address ?? "";
          toLocations.clear();
          for (int i = 0; i < order.toLocation!.length; i++) {
            if (i == 0) {
              toLocationLat = order.toLocation![i].latitude!;
              toLocationLon = order.toLocation![i].longitude!;
              toLocationAddressController.text =
                  order.toLocation![i].address ?? "";
              toLocations.add(1);
            } else if (i == 1) {
              toLocationLat1 = order.toLocation![i].latitude!;
              toLocationLon1 = order.toLocation![i].longitude!;
              toLocationAddressController1.text =
                  order.toLocation![i].address ?? "";
              toLocations.add(2);
            } else if (i == 2) {
              toLocationLat2 = order.toLocation![i].latitude!;
              toLocationLon2 = order.toLocation![i].longitude!;
              toLocationAddressController2.text =
                  order.toLocation![i].address ?? "";
              toLocations.add(3);
            }
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouterNames.home,
            arguments: order,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouterNames.home,
            (route) => false,
          );
        }
      },
      afterError: () => Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouterNames.home,
        (route) => false,
      ),
    );
  }

  late Timer _timer;
  int _time = 119;

  String _getTimer(int timeInSeconds) {
    final min = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (timeInSeconds % 60).toString().padLeft(2, '0');
    final time = '$min:$sec';
    return time;
  }

  void _initializeTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_time == 0) {
            _timer.cancel();
            _time = 120;
          } else {
            _time--;
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkGrey : null,
        body: Container(
          width: 100.w,
          height: 100.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                AppColors.green,
                AppColors.midGreen,
                AppColors.darkGreen,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 7.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 11.w,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            CacheHelper.clearData();
                            Navigator.pushReplacementNamed(context, AppRouterNames.login);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color:  AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    DefaultText(
                      text: context.phoneVerification,
                      textColor: AppColors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                DefaultText(
                  text: context.otpCode,
                  textColor: AppColors.white,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    onChanged: (val) {
                      setState(() {
                        _otp = val;
                      });
                    },
                    onCompleted: (val) {},
                    showCursor: true,
                    cursorColor: AppColors.primary,
                    pinTheme: PinTheme(
                      activeColor: AppColors.lightGreen,
                      selectedColor: AppColors.lightGreen,
                      inactiveColor: AppColors.lightGreen,
                      disabledColor: AppColors.lightGreen,
                      selectedFillColor: AppColors.white,
                      activeFillColor: AppColors.white,
                      inactiveFillColor: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      shape: PinCodeFieldShape.box,
                      fieldWidth: 15.w,
                      fieldHeight: 7.h,
                    ),
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                    ),
                    blinkWhenObscuring: true,
                    obscureText: true,
                    autoFocus: true,
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                DefaultText(
                  text: context.minutesLeft(_getTimer(_time)),
                  fontSize: 13.sp,
                  textColor: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: _time != 120 ?null:() {
                    _initializeTimer();
                    showToast(
                      context.codeSent,
                      color: AppColors.green,
                      textColor: AppColors.white,
                    );
                  },
                  child: DefaultText(
                    text: context.resendCode,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    textColor:
                        _time != 120 ? AppColors.grey : AppColors.white,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                DefaultAppButton(
                  title: context.cont,
                  textColor: AppColors.primary,
                  buttonColor: AppColors.white,
                  isGradient: false,
                  onTap: () {
                    _timer.cancel();
                    Navigator.popAndPushNamed(context, AppRouterNames.fillProfile);
                    // FocusManager.instance.primaryFocus?.unfocus();
                    // if (_otp?.length != 4) {
                    //   context.verificationCodeRequired.toToastWarning();
                    //   return;
                    // } else {
                    //   showDialog(
                    //     context: context,
                    //     builder: (_) {
                    //       return const LoadingIndicator();
                    //     },
                    //   );
                    //   AuthCubit.get(context).verifyFirebaseOTp(code: _otp!);
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
