import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/custom_app_bar.dart';
import 'package:seda/src/presentation/views/order_views/end_views/rate_driver_bottom_sheet.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = OrderCubit.get(context).orderModel;
    final driver = OrderCubit.get(context).orderModel?.captain;
    final vehicle = OrderCubit.get(context).orderModel?.vehicle;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  CustomAppBar(
                    title: context.checkout,
                    height: 130,
                    customWidget: const SizedBox(),
                    historyWidget: const SizedBox(),
                    onTap: () {},
                    hasBack: false,
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 35,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isDark ? AppColors.lightGrey : AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withOpacity(0.7),
                          spreadRadius: 4,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 18.w,
                              height: 18.w,
                              decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(100)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9.w),
                                child: driver?.image == null
                                    ? const Icon(
                                        Icons.person,
                                        color: AppColors.white,
                                      )
                                    : Image.network(
                                        '${EndPoints.imageBaseUrl}${driver?.image}',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultText(
                                    text: driver?.name ?? '',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    textColor:
                                        isDark ? AppColors.darkGrey : null,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 4.w,
                                        height: 4.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Image.asset(
                                            "assets/images/star.png"),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      DefaultText(
                                        text: driver?.rate ?? "",
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        textColor:
                                            isDark ? AppColors.midGrey : null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: DefaultText(
                                text: context.totalPrice,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                textColor: isDark ? AppColors.darkGrey : null,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    width: 15.h,
                                    height: 9.h,
                                    child: Center(
                                      child: Image.asset(
                                          "assets/images/carGreen.png"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  DefaultText(
                                    text: vehicle!.carNumber!,
                                    textColor: AppColors.midGreen,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  DefaultText(
                                    text:
                                        "${vehicle.vehicleTypesCompany} - ${vehicle.vehicleColorName}",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        Container(
                          width: 35.h,
                          height: 35.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(
                                    2, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          child: DefaultText(
                            text: order?.price != null
                                ? double.parse(order!.price!)
                                    .ceil()
                                    .toStringAsFixed(0)
                                : '',
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.white,
                            fontSize: 110.sp,
                            shadows: [
                              Shadow(
                                  color: AppColors.grey.withOpacity(0.8),
                                  offset: const Offset(2, 2),
                                  blurRadius: 10)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        DefaultAppButton(
                          title: context.rateDriver,
                          radius: 25,
                          onTap: () {
                            showModalBottomSheet<dynamic>(
                              isScrollControlled: true,
                              backgroundColor: AppColors.transparent,
                              context: context,
                              builder: (BuildContext bc) {
                                return const RateDriverBottomSheet();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: Image.asset("assets/images/logo4.png"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
