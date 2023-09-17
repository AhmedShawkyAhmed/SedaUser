import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../ride_views/rides_home_view.dart';
import '../../widgets/default_text.dart';
import 'choose_passenger_view.dart';

class JustGoExtendedView extends StatefulWidget {
  const JustGoExtendedView(
      {Key? key,
      required this.started,
      required this.cancelOrder,
      required this.opacity})
      : super(key: key);
  final bool started;
  final double opacity;
  final Function() cancelOrder;

  @override
  State<JustGoExtendedView> createState() => _JustGoExtendedViewState();
}

class _JustGoExtendedViewState extends State<JustGoExtendedView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.opacity,
      duration: const Duration(milliseconds: 20),
      child: Container(
        width: 100.w,
        // height: 90.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGrey : AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 1.9.h,
                  ),
                  Container(
                    height: 1.w,
                    width: 15.w,
                    decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isDark ? AppColors.lightGrey : AppColors.darkGrey,
                        ),
                        borderRadius: BorderRadius.circular(9)),
                    child: DefaultText(
                      text: OrderCubit.get(context)
                              .orderModel
                              ?.vehicle
                              ?.carNumber ??
                          "",
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                  Divider(
                    color: isDark ? AppColors.white : AppColors.lightGrey,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 19, vertical: 30),
                                decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(20))),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff4DDBB0),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff5AF1C4),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    // child: Image.asset('assets/images/.png'),
                                    child: const Icon(
                                      Icons.shield_sharp,
                                      color: AppColors.yellow,
                                      size: 50,
                                    ),
                                  ),
                                )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 36),
                              width: 55.w,
                              decoration: const BoxDecoration(
                                  color: AppColors.green1,
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultText(
                                    text: context.beCarefulWithYourMovements,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    maxLines: 2,
                                    textColor: AppColors.white,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  DefaultText(
                                    text: context.stayInformed,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11.sp,
                                    textColor: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Container(
                      color: AppColors.lightGrey,
                      height: 1.2.h,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<dynamic>(
                              isScrollControlled: true,
                              transitionAnimationController: controller,
                              backgroundColor: AppColors.transparent,
                              context: context,
                              builder: (BuildContext bc) {
                                return const ChoosePassengerView();
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.black
                                                  .withOpacity(0.25),
                                              blurRadius: 7)
                                        ]),
                                    child: Image.asset(
                                        'assets/images/instant_ride_verification.png')),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DefaultText(
                                      text: context.instantRideVerification,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.sp,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    DefaultText(
                                      text: context.sharingTripFare,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: isDark ? AppColors.white : AppColors.lightGrey,
                        ),
                        Column(
                          children: [
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                final cubit = OrderCubit.get(context);
                                return SizedBox(
                                  height: (7.h *
                                          cubit
                                              .orderModel!.toLocation!.length) +
                                      1.h,
                                  child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        cubit.orderModel!.toLocation!.length,
                                    padding: EdgeInsets.only(top: 1.h),
                                    itemBuilder: (context, position) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 1.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/gis_location.png',
                                                    color: isDark
                                                        ? AppColors.white
                                                        : AppColors.darkGrey,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
                                                    child: DefaultText(
                                                      text: cubit
                                                              .orderModel!
                                                              .toLocation![
                                                                  position]
                                                              .address ??
                                                          'Empty Address',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13.sp,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (cubit.orderModel!.toLocation![
                                                        position] ==
                                                    cubit.orderModel!
                                                        .toLocation!.last &&
                                                cubit.orderModel!.toLocation!
                                                        .length !=
                                                    3)
                                              DefaultText(
                                                text: context.addOrChange,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13.sp,
                                                textColor: AppColors.primary,
                                                onTap: () {
                                                  showModalBottomSheet<dynamic>(
                                                    isScrollControlled: true,
                                                    transitionAnimationController:
                                                        controller,
                                                    backgroundColor:
                                                        AppColors.transparent,
                                                    context: context,
                                                    builder: (BuildContext bc) {
                                                      return const RidesHomeView(
                                                          key: ValueKey(2));
                                                    },
                                                  ).then((value) {
                                                    if (value == true) {
                                                      setState(() {});
                                                    }
                                                  });
                                                },
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, position) {
                                      return const Divider(
                                        height: 10,
                                        thickness: 1,
                                        color: AppColors.lightGrey,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            Divider(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.lightGrey,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 1.5.h),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/money.png',
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.darkGrey,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  DefaultText(
                                    text:
                                        "SAR  ${OrderCubit.get(context).orderModel?.price.toString()} , ${paymentTypeId == 1 ? context.wallet : paymentTypeId == 1 ? context.visa : context.cash} ",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.lightGrey,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 1.5.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/share1.png',
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.darkGrey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      DefaultText(
                                        text: context.shareYourTripStatus,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.sp,
                                      ),
                                    ],
                                  ),
                                  DefaultText(
                                    text: context.share,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                    textColor: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.lightGrey,
                            ),
                          ],
                        ),
                        if (!widget.started)
                          Padding(
                            padding: EdgeInsets.only(top: 1.5.h, bottom: 2.h),
                            child: DefaultText(
                              text: context.cancel,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              textColor: AppColors.red,
                              onTap: widget.cancelOrder,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
