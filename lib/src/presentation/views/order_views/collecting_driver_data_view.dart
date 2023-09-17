import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

import 'payment_view.dart';
import '../../widgets/default_text.dart';
import 'add_drop_off_screen.dart';

class CollectingDriverDataScreen extends StatefulWidget {
  const CollectingDriverDataScreen({Key? key, required this.cancelOrder})
      : super(key: key);
  final Function() cancelOrder;

  @override
  State<CollectingDriverDataScreen> createState() =>
      _CollectingDriverDataScreenState();
}

class _CollectingDriverDataScreenState extends State<CollectingDriverDataScreen>
    with TickerProviderStateMixin {
  List<bool> _selected = [false, false, false, false];
  bool expand = false;
  int select = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  late AnimationController controller;

  @override
  void didUpdateWidget(dynamic oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => incTimer());
  }

  void incTimer() {
    if (select < 4) {
      setState(() {
        _selected[select] = true;
        select++;
      });
    } else {
      resetTimer();
    }
  }

  void stopTimer() {
    setState(() => timer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    timer = null;
    select = 0;
    _selected = [false, false, false, false];
    startTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
    controller.dispose();
  }

  _onDragEnd(DragEndDetails details) {
    // if (details.primaryVelocity != 0.0) {
    if (height > 10.h && !expand) {
      printError('gggggggggggggggggggggggg');
      expand = true;
      location = (72.h + (4.h * toLocations.length) + 2.h);
      setState(() {});
    } else if (height < (80.h + (4.h * toLocations.length))) {
      printError('errorrrrrrrrrrrrrrrr');
      expand = false;
      location = 42.h;
    }
    // }
  }

  _onDragUpdate(DragUpdateDetails details) {
    height =
        (MediaQuery.of(context).size.height - details.globalPosition.dy).abs();
    setState(() {
      if (height > 42.h &&
          height < (72.h + (4.h * toLocations.length)) &&
          (details.primaryDelta != 0.0)) {
        // if (location > 60.h) {
        //   expand = true;
        //   setState(() {});
        // } else if (location < (68.h + (4.h * toLocations.length))) {
        //   expand = false;
        //   setState(() {});
        // }
        location = height;
      }
    });
  }

  double location = 42.h;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 100.w,
      height: location,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGrey : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onVerticalDragEnd: _onDragEnd,
        onVerticalDragUpdate: _onDragUpdate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Container(
                    height: 3,
                    width: 15.w,
                    decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                    child: DefaultText(
                      text: context.theTripHasBeenRequested,
                      fontSize: 13.sp,
                      maxLines: 2,
                      align: TextAlign.center,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Divider(
                    color: isDark ? AppColors.lightGrey : AppColors.white,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: SizedBox(
                        height: 6.h,
                        width: 100.w,
                        child: BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 2.5.h),
                              itemBuilder: (context, position) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 50),
                                  height: 0.5.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                      color: _selected[position]
                                          ? AppColors.primary
                                          : AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(15)),
                                );
                              },
                              separatorBuilder: (context, position) {
                                return SizedBox(
                                  width: 2.w,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 2.5.h, horizontal: 5.w),
                      child: Image.asset(
                        'assets/images/delivery_map.gif',
                        height: 16.h,
                        width: 16.h,
                      ),
                    ),
                    Container(
                      color: AppColors.lightGrey,
                      height: 1.7.h,
                    ),
                    if (expand)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 100),
                        child: Column(
                          children: [
                            SizedBox(
                              height: (7.h * toLocations.length) + 1.h,
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: toLocations.length,
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
                                                  text: toLocations[position] ==
                                                          1
                                                      ? toLocationAddressController
                                                          .text
                                                      : toLocations[position] ==
                                                              2
                                                          ? toLocationAddressController1
                                                              .text
                                                          : toLocationAddressController2
                                                              .text,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.sp,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (toLocations[position] ==
                                                toLocations.last &&
                                            toLocations.length != 3)
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
                                                  return const AddDropOffScreen();
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
                                  DefaultText(
                                    text: context.change,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                    textColor: AppColors.primary,
                                    onTap: () {
                                      showModalBottomSheet<dynamic>(
                                        isScrollControlled: true,
                                        // transitionAnimationController: controller,
                                        backgroundColor: AppColors.transparent,
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return const PaymentView(
                                            newOrder: true,
                                          );
                                        },
                                      );
                                    },
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
                            Padding(
                              padding: EdgeInsets.only(
                                top: 1.h,
                                bottom: 2.h,
                              ),
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
