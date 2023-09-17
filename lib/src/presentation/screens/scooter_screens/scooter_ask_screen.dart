import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class ScooterAskScreen extends StatelessWidget {
  const ScooterAskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkGrey : AppColors.midGreen,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 80,
              left: 25,
              right: 30,
              bottom: 25,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 12),
                DefaultText(
                  text: 'Not available in your country',
                  textColor: AppColors.white,
                  fontSize: 12.sp,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100.w,
            height: 25.h,
            child: Image.asset(
              "assets/images/scooterAd.png",
              width: 100.w,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 30,
              right: 100,
              bottom: 10,
            ),
            child: DefaultText(
              text: context.scooterRideAsk,
              textColor: AppColors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Calibri',
              maxLines: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 30,
              right: 30,
              bottom: 60,
            ),
            child: DefaultText(
              text: context.scooterRideAskDesc,
              textColor: AppColors.white,
              fontSize: 13.sp,
              height: 1.35,
              fontWeight: FontWeight.w400,
              fontFamily: 'Calibri',
              maxLines: 12,
            ),
          ),
          Center(
            child: SizedBox(
              height: 7.h,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Material(
                  color: isDark ? AppColors.midGreen : AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(50),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    // onTap: () =>
                    //     Navigator.pushNamed(context, AppRouterNames.scooterMap),
                    onTap: () {
                      showToast('Not available in your country',
                          color: AppColors.yellow, textColor: AppColors.black);
                    },
                    child: Center(
                      child: DefaultText(
                        text: context.startNow,
                        textColor: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Calibri',
                        fontSize: 14.5.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
