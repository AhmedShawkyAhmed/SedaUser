import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/constants_variables.dart';

class CancelBottomSheetView extends StatelessWidget {
  const CancelBottomSheetView({Key? key, required this.reason})
      : super(key: key);

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 22,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGrey : AppColors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                left: 20,
                right: 20,
              ),
              child: DefaultText(
                text: "A \$10:00 fee may apply if you \ncancel, are you sure",
                maxLines: 2,
                fontSize: 20.sp,
                fontFamily: 'Calibri',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 30,
                left: 20,
                right: 20,
              ),
              child: DefaultText(
                text:
                    "Captain traveled 0.5 km for 1 minute \nCancellation fee may apply for \nfatigue",
                maxLines: 3,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                align: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DefaultAppButton(
                  width: 40.w,
                  height: 6.h,
                  title: context.no,
                  textColor: AppColors.red,
                  fontSize: 13.sp,
                  buttonColor: AppColors.lightGrey,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  haveShadow: false,
                  isGradient: true,
                  gradientColors: const [
                    AppColors.lightGrey,
                    AppColors.lightGrey
                  ],
                ),
                DefaultAppButton(
                  width: 40.w,
                  height: 6.h,
                  title: context.yes,
                  fontFamily: 'Calibri',
                  fontSize: 15.sp,
                  onTap: () {
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
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
