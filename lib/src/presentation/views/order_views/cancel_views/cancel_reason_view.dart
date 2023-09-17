import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/order_views/cancel_views/cancel_bottom_sheet_view.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/default_app_button.dart';

class CancelReasonView extends StatelessWidget {
  const CancelReasonView({
    Key? key,
    required this.driverArrived,
  }) : super(key: key);

  final bool driverArrived;

  _selectReason(BuildContext context, String reason) {
    if (driverArrived) {
      Navigator.pop(context);
      showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        backgroundColor: AppColors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return CancelBottomSheetView(
            reason: reason,
          );
        },
      );
    }else{
      showDialog(
          context: context,
          builder: (context) => const LoadingIndicator());
      OrderCubit.get(context).cancelOrder(
        afterError: () => Navigator.pop(context),
        cancelReason: reason,
        orderId: CacheHelper.getDataFromSharedPreference(
            key: SharedPreferenceKeys.orderId),
        afterSuccess: () =>
            Future.delayed(const Duration(seconds: 1))
                .then((value) {
              resetOrder();
              GlobalCubit.get(context).resetState();
              resetToLocations();
              waitingDriverToggleView.value = false;
              Navigator.popUntil(context, (route) => route.isFirst);
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
        color: isDark ? AppColors.darkGrey : AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 1.5.h,
          ),
          Container(
            height: 1.w,
            width: 15.w,
            decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(15)),
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
            child: DefaultText(
              text: context.cancelTrip,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
          Divider(
            height: 1.5.h,
            thickness: 1,
            color: AppColors.lightGrey,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
            child: DefaultText(
              text: context.whyCancel,
              fontSize: 13.sp,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 2.h),
                        child: DefaultText(
                          text: context.reasonRelatedToUser,
                          fontSize: 13.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 1.h),
                        child: DefaultText(
                          onTap: () {
                            _selectReason(context, context.personalReason);
                          },
                          text: context.personalReason,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: isDark ? AppColors.white : AppColors.lightGrey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 1.h),
                        child: DefaultText(
                          onTap: () {
                            _selectReason(context, context.anotherCarArrived);
                          },
                          text: context.anotherCarArrived,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: isDark ? AppColors.white : AppColors.lightGrey,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 2.h),
                        child: DefaultText(
                          text: context.reasonRelatedToCaptain,
                          fontSize: 13.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 1.h),
                        child: DefaultText(
                          onTap: () {
                            _selectReason(context, context.waitLong);
                          },
                          text: context.waitLong,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: isDark ? AppColors.white : AppColors.lightGrey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 1.h),
                        child: DefaultText(
                          onTap: () {
                            _selectReason(context, context.capNotMove);
                          },
                          text: context.capNotMove,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: isDark ? AppColors.white : AppColors.lightGrey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 1.h),
                        child: DefaultText(
                          onTap: () {
                            _selectReason(context, context.capLate);
                          },
                          text: context.capLate,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: isDark ? AppColors.white : AppColors.lightGrey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 1.h),
                        child: DefaultText(
                          onTap: () {
                            _selectReason(context, context.waitLong);
                          },
                          text: context.waitLong,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: isDark ? AppColors.white : AppColors.lightGrey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 1.h),
                        child: DefaultText(
                          onTap: () {
                            _selectReason(context, context.capNotMove);
                          },
                          text: context.capNotMove,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: isDark ? AppColors.white : AppColors.lightGrey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 1.h),
                        child: DefaultText(
                          onTap: () {
                            _selectReason(context, context.capLate);
                          },
                          text: context.capLate,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: isDark ? AppColors.white : AppColors.lightGrey,
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DefaultText(
                        onTap: () {
                          _selectReason(context, context.anotherReason);
                        },
                        text: context.anotherReason,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
            child: DefaultText(
              onTap: () {
                _selectReason(context, context.skip);
              },
              text: context.skip,
              fontSize: 13.sp,
              textColor: AppColors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
          DefaultAppButton(
            width: 75.w,
            height: 6.h,
            title: context.backToMyTrip,
            onTap: () {
              Navigator.pop(context, true);
            },
            isGradient: true,
            gradientColors: const [Color(0xff185A9D), Color(0xff43CEA2)],
          ),
          SizedBox(
            height: 2.2.h,
          ),
        ],
      ),
    );
  }
}
