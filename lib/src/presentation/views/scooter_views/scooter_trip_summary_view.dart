import 'package:flutter/cupertino.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:sizer/sizer.dart';

import '../../router/app_router_names.dart';
import '../../styles/app_colors.dart';
import '../../widgets/default_app_button.dart';
import '../../widgets/default_text.dart';

class ScooterTripSummaryView extends StatelessWidget {
  const ScooterTripSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        height: 500,
        padding: EdgeInsets.only(
          top: 5.h,
          right: 10.w,
          left: 10.w,
        ),
        decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  DefaultText(
                    text: context.tripSummary,
                    textColor: AppColors.darkGrey,
                    fontSize: 25.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Calibri',
                  ),
                  SizedBox(
                    height: 4.8.h,
                  ),
                  DefaultText(
                    text: '${context.date}: 26 Jun 2023',
                    textColor: AppColors.darkGrey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 1.8.h,
                  ),
                  DefaultText(
                    text: '${context.time}: 14:00pm',
                    textColor: AppColors.darkGrey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 83,
                        width: 91,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xffC4C4C4))),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/scooter_distance.png'),
                            const SizedBox(
                              height: 8,
                            ),
                            DefaultText(
                              text: '5 km',
                              textColor: AppColors.darkGrey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DefaultText(
                        text: context.distance,
                        textColor: AppColors.darkGrey,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 83,
                        width: 91,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xffC4C4C4))),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/scooter_clock.png'),
                            const SizedBox(
                              height: 8,
                            ),
                            DefaultText(
                              text: '18m 20s',
                              textColor: AppColors.darkGrey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DefaultText(
                        text: context.time,
                        textColor: AppColors.darkGrey,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 83,
                        width: 91,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xffC4C4C4))),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/scooter_price.png'),
                            const SizedBox(
                              height: 8,
                            ),
                            DefaultText(
                              text: '33 EGP',
                              textColor: AppColors.darkGrey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DefaultText(
                        text: context.price,
                        textColor: AppColors.darkGrey,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              DefaultAppButton(
                title: context.backToHome,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
                onTap: () {
                  Navigator.pushNamed(context, AppRouterNames.home);
                },
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
