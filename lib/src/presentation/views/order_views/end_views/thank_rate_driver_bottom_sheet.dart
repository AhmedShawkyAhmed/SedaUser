// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class ThankRateDriverBottomSheet extends StatefulWidget {
  const ThankRateDriverBottomSheet({Key? key}) : super(key: key);

  @override
  State<ThankRateDriverBottomSheet> createState() =>
      _ThankRateDriverBottomSheetState();
}

class _ThankRateDriverBottomSheetState
    extends State<ThankRateDriverBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: 100.w,
        // height: 90.h,
        padding: EdgeInsets.only(bottom: 4.h, top: 19.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(50),
          ),
          color: isDark ? AppColors.darkGrey : AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/thanks_for_rating.gif',
              height: 25.h,
              width: 25.h,
            ),
            SizedBox(
              height: 6.h,
            ),
            DefaultText(
              text: context.thankYouForUsingOurServices,
              fontWeight: FontWeight.w400,
              textColor: AppColors.darkGrey,
              fontSize: 15.sp,
            ),
            SizedBox(
              height: 13.4.h,
            ),
            DefaultAppButton(
              title: context.backToHome,
              onTap: () {
                resetToLocations();
                waitingDriverToggleView.value = false;
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
