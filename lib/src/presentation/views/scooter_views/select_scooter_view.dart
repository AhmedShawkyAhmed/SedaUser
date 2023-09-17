import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class SelectScooter extends StatelessWidget {
  const SelectScooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27.h,
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGrey : AppColors.white,
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.darkGrey.withOpacity(0.8)
                : AppColors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 15.h,
                  width: 20.w,
                  child: Center(
                    child: Image.asset(
                      "assets/images/scooter.png",
                      height: 14.w,
                      width: 14.w,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/battry.png",
                          width: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DefaultText(
                          text: context.usageTime,
                          fontWeight: FontWeight.w400,
                          textColor:
                              isDark ? AppColors.lightGrey : AppColors.darkGrey,
                          fontSize: 11.sp,
                          fontFamily: 'Calibri',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DefaultText(
                          text: "1:30 Hr",
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.midGreen,
                          fontSize: 11.sp,
                          fontFamily: 'Calibri',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/location.png",
                          width: 12,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DefaultText(
                          text: "1 kilometer away from you",
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Calibri',
                          textColor:
                              isDark ? AppColors.white : AppColors.darkGrey,
                          fontSize: 11.sp,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/coin.png",
                          width: 16,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DefaultText(
                          text: "1:30 EG",
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.midGreen,
                          fontSize: 11.sp,
                          fontFamily: 'Calibri',
                        ),
                        DefaultText(
                          text: " / MIN",
                          fontWeight: FontWeight.w400,
                          textColor:
                              isDark ? AppColors.white : AppColors.darkGrey,
                          fontSize: 11.sp,
                          fontFamily: 'Calibri',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          DefaultAppButton(
            title: 'Scan',
            fontFamily: 'Calibri',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            onTap: () => Navigator.pushNamed(context, AppRouterNames.qrScan),
          ),
          SizedBox(
            height: 1.h,
          )
        ],
      ),
    );
  }
}
