import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/car.dart';
import 'package:seda/src/presentation/views/ride_views/ride_info_view.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/ride_views/choose_ride_view.dart';
import 'package:seda/src/presentation/views/order_views/payment_view.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class SelectRideView extends StatelessWidget {
  const SelectRideView({
    super.key,
    required this.time,
    required this.location,
    required this.onDragEnd,
    required this.onDragUpdate,
    required this.expand,
    required this.hours,
    required this.onAdd,
    required this.onMinus,
    required this.updateState,
    required this.makeOrder,
    required this.paymentMethods,
  });

  final List<String> time;
  final double location;
  final Function(DragEndDetails d) onDragEnd;
  final Function(DragUpdateDetails d) onDragUpdate;
  final bool expand;
  final ValueNotifier<int> hours;
  final Function() onAdd;
  final Function() onMinus;
  final Function() updateState;
  final Function() makeOrder;
  final List<dynamic> Function(BuildContext context) paymentMethods;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 100.w,
            height: location,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(35),
              ),
              color: isDark ? AppColors.darkGrey : AppColors.transparent,
            ),
            child: GestureDetector(
              onVerticalDragEnd: onDragEnd,
              onVerticalDragUpdate: onDragUpdate,
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.lightGreen : AppColors.green,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 50),
                      child: Container(
                        height: !expand ? null : 0,
                        width: double.infinity,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.lightGreen : AppColors.green,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultText(
                              text: context.youHaveCoupon,
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp,
                              textColor: AppColors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                              height: 5.h,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 3.w,
                                    height: 2.h,
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(50),
                                        bottomLeft: Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 3.w,
                                    height: 2.h,
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DefaultText(
                              text: '50%OFF',
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              textColor: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkGrey : AppColors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 100.w,
                              height: 1.h,
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
                            DefaultText(
                              text: context.chooseRide,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: !expand ? 35.h : 80.h,
                                      child:
                                          BlocBuilder<OrderCubit, OrderState>(
                                        builder: (context, state) {
                                          final data = <Car>[
                                            ...(OrderCubit.get(context)
                                                    .carTypes
                                                    .data
                                                    ?.serial ??
                                                []),
                                            ...(OrderCubit.get(context)
                                                    .carTypes
                                                    .data
                                                    ?.hours ??
                                                [])
                                          ];
                                          List<Car> types = [];
                                          if (expand) {
                                            types.addAll(data);
                                          } else {
                                            types.addAll(data.sublist(0, 3));
                                          }
                                          return ListView.separated(
                                            padding: const EdgeInsets.all(0.0),
                                            itemCount: expand
                                                ? types.length + 2
                                                : types.length,
                                            itemBuilder: (context, position) {
                                              if (expand) {
                                                if (position == 0) {
                                                  return Align(
                                                    alignment: context.isAr
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                      ),
                                                      child: DefaultText(
                                                        text: context.justGo,
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (position == 4) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        DefaultText(
                                                          text: context.byHours,
                                                          fontSize: 15.sp,
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: onAdd,
                                                              child: Icon(
                                                                Icons
                                                                    .add_circle_outline_rounded,
                                                                color: isDark
                                                                    ? AppColors
                                                                        .lightGrey
                                                                    : AppColors
                                                                        .darkGrey,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child:
                                                                  ValueListenableBuilder(
                                                                      valueListenable:
                                                                          hours,
                                                                      builder: (context,
                                                                          hoursVal,
                                                                          child) {
                                                                        return DefaultText(
                                                                          text:
                                                                              hoursVal.toString(),
                                                                          textColor: isDark
                                                                              ? AppColors.lightGrey
                                                                              : AppColors.darkGrey,
                                                                          fontSize:
                                                                              15.sp,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        );
                                                                      }),
                                                            ),
                                                            InkWell(
                                                              onTap: onMinus,
                                                              child: Icon(
                                                                Icons
                                                                    .remove_circle_outline_rounded,
                                                                color: isDark
                                                                    ? AppColors
                                                                        .lightGrey
                                                                    : AppColors
                                                                        .darkGrey,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return InkWell(
                                                  onTap: () {
                                                    printSuccess(
                                                        expand.toString());
                                                    if (rideTypeId ==
                                                            types[position > 4
                                                                    ? position -
                                                                        2
                                                                    : position -
                                                                        1]
                                                                .id! &&
                                                        shipmentTypeId ==
                                                            types[position > 4
                                                                    ? position -
                                                                        2
                                                                    : position -
                                                                        1]
                                                                .shipmentTypeId &&
                                                        !expand) {
                                                      showModalBottomSheet<
                                                          dynamic>(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            AppColors
                                                                .transparent,
                                                        context: context,
                                                        builder:
                                                            (BuildContext bc) {
                                                          return const RideInfoView();
                                                        },
                                                      );
                                                    } else if (expand) {
                                                      rideTypeId = types[
                                                              position > 4
                                                                  ? position - 2
                                                                  : position -
                                                                      1]
                                                          .id!;
                                                      shipmentTypeId = types[
                                                              position > 4
                                                                  ? position - 2
                                                                  : position -
                                                                      1]
                                                          .shipmentTypeId!;
                                                      updateState();
                                                      makeOrder();
                                                    } else {
                                                      rideTypeId = types[
                                                              position > 4
                                                                  ? position - 2
                                                                  : position -
                                                                      1]
                                                          .id!;
                                                      shipmentTypeId = types[
                                                              position > 4
                                                                  ? position - 2
                                                                  : position -
                                                                      1]
                                                          .shipmentTypeId!;
                                                      updateState();
                                                    }
                                                    printWarning(
                                                        'rideType: $rideTypeId');
                                                    printWarning(
                                                        'shipmentType: $shipmentTypeId');
                                                  },
                                                  child: ValueListenableBuilder(
                                                      valueListenable: hours,
                                                      builder: (context,
                                                          hoursVal, child) {
                                                        return ChooseRideView(
                                                          shipmentTypeId: types[
                                                                      position > 4
                                                                          ? position -
                                                                              2
                                                                          : position -
                                                                              1]
                                                                  .shipmentTypeId ??
                                                              2,
                                                          image: types[position > 4
                                                                              ? position -
                                                                                  2
                                                                              : position -
                                                                                  1]
                                                                          .image !=
                                                                      null &&
                                                                  types[position > 4
                                                                          ? position -
                                                                              2
                                                                          : position -
                                                                              1]
                                                                      .image!
                                                                      .isNotEmpty
                                                              ? '${EndPoints.imageBaseUrl}${types[position > 4 ? position - 2 : position - 1].image}'
                                                              : "assets/images/car.png",
                                                          title:
                                                              '${types[position > 4 ? position - 2 : position - 1].name}',
                                                          time:
                                                              "${types[position > 4 ? position - 2 : position - 1].time}",
                                                          price:
                                                              "${position > 4 ? (types[position - 2].moveMinutePrice! * hoursVal * 60) : types[position - 1].price}",
                                                          currency: "SAR",
                                                          subTitle: types[position > 4
                                                                          ? position -
                                                                              2
                                                                          : position -
                                                                              1]
                                                                      .name!
                                                                      .split(
                                                                          ' ')
                                                                      .first ==
                                                                  'just'
                                                              ? 'Better for short trips'
                                                              : types[position > 4
                                                                              ? position - 2
                                                                              : position - 1]
                                                                          .name!
                                                                          .split(' ')
                                                                          .first ==
                                                                      'by'
                                                                  ? 'Better for long trips'
                                                                  : 'Book a driver for hours',
                                                          selected: !expand
                                                              ? rideTypeId ==
                                                                      types[position > 4
                                                                              ? position -
                                                                                  2
                                                                              : position -
                                                                                  1]
                                                                          .id &&
                                                                  shipmentTypeId ==
                                                                      types[position > 4
                                                                              ? position - 2
                                                                              : position - 1]
                                                                          .shipmentTypeId
                                                              : false,
                                                        );
                                                      }),
                                                );
                                              } else {
                                                return InkWell(
                                                  onTap: () {
                                                    printSuccess(
                                                        expand.toString());
                                                    if (rideTypeId ==
                                                            types[position]
                                                                .id! &&
                                                        shipmentTypeId ==
                                                            types[position]
                                                                .shipmentTypeId &&
                                                        !expand) {
                                                      showModalBottomSheet<
                                                          dynamic>(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            AppColors
                                                                .transparent,
                                                        context: context,
                                                        builder:
                                                            (BuildContext bc) {
                                                          return const RideInfoView();
                                                        },
                                                      );
                                                    } else if (expand) {
                                                      rideTypeId =
                                                          types[position].id!;
                                                      shipmentTypeId =
                                                          types[position]
                                                              .shipmentTypeId!;
                                                      updateState();
                                                      makeOrder();
                                                    } else {
                                                      rideTypeId =
                                                          types[position].id!;
                                                      shipmentTypeId =
                                                          types[position]
                                                              .shipmentTypeId!;
                                                      updateState();
                                                    }
                                                    printWarning(
                                                        'rideType: $rideTypeId');
                                                    printWarning(
                                                        'shipmentType: $shipmentTypeId');
                                                  },
                                                  child: ChooseRideView(
                                                    shipmentTypeId: types[
                                                                position]
                                                            .shipmentTypeId ??
                                                        2,
                                                    image: types[position]
                                                                    .image !=
                                                                null &&
                                                            types[position]
                                                                .image!
                                                                .isNotEmpty
                                                        ? '${EndPoints.imageBaseUrl}${types[position].image}'
                                                        : "assets/images/car.png",
                                                    title:
                                                        '${types[position].name}',
                                                    time:
                                                        "${types[position].time}",
                                                    price:
                                                        "${types[position].price}",
                                                    currency: "SAR",
                                                    subTitle: types[position]
                                                                .name!
                                                                .split(' ')
                                                                .first ==
                                                            'just'
                                                        ? 'Better for short trips'
                                                        : types[position]
                                                                    .name!
                                                                    .split(' ')
                                                                    .first ==
                                                                'by'
                                                            ? 'Better for long trips'
                                                            : 'Book a driver for hours',
                                                    selected: !expand
                                                        ? rideTypeId ==
                                                                types[position]
                                                                    .id &&
                                                            shipmentTypeId ==
                                                                types[position]
                                                                    .shipmentTypeId
                                                        : false,
                                                  ),
                                                );
                                              }
                                            },
                                            separatorBuilder:
                                                (context, position) {
                                              return const SizedBox(
                                                height: 10,
                                                // thickness: 1,
                                                // color: AppColors.white,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: SizedBox(
                                        height: !expand ? null : 0,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Divider(
                                              height: 10,
                                              thickness: 1,
                                              color: AppColors.lightGrey,
                                            ),
                                            Container(
                                              color: AppColors.lightGrey
                                                  .withOpacity(0.1),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 31,
                                                            right: 31,
                                                            bottom: 11),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        DefaultText(
                                                          text: context
                                                              .choosePayment,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showModalBottomSheet<
                                                                dynamic>(
                                                              isScrollControlled:
                                                                  true,
                                                              // transitionAnimationController: controller,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .transparent,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      bc) {
                                                                return const PaymentView(
                                                                  newOrder:
                                                                      false,
                                                                );
                                                              },
                                                            ).then(
                                                              (value) =>
                                                                  updateState(),
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              paymentMethods(context)[paymentTypeId -
                                                                              1]
                                                                          [1] ==
                                                                      context
                                                                          .wallet
                                                                  ? Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5,
                                                                          horizontal:
                                                                              4),
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .primary,
                                                                          borderRadius:
                                                                              BorderRadius.circular(2)),
                                                                      child:
                                                                          DefaultText(
                                                                        text: context
                                                                            .seda,
                                                                        fontSize:
                                                                            8.sp,
                                                                        textColor:
                                                                            AppColors.white,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    )
                                                                  : SvgPicture
                                                                      .asset(
                                                                      paymentMethods(
                                                                              context)[
                                                                          paymentTypeId -
                                                                              1][0],
                                                                    ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              FittedBox(
                                                                child:
                                                                    DefaultText(
                                                                  text: paymentMethods(
                                                                          context)[
                                                                      paymentTypeId -
                                                                          1][1],
                                                                  fontSize:
                                                                      17.sp,
                                                                  align: context
                                                                          .isAr
                                                                      ? TextAlign
                                                                          .end
                                                                      : TextAlign
                                                                          .start,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      'Calibri',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DefaultAppButton(
                                                    title: context.choose,
                                                    onTap: makeOrder,
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 5.h,
          left: 5.w,
          child: Material(
            type: MaterialType.circle,
            color: isDark ? AppColors.darkGrey : AppColors.white,
            child: InkWell(
              onTap: () {
                resetToLocations();
                updateState();
                waitingDriverToggleView.value = false;
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  context.isAr
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_back_rounded,
                  size: 26,
                  color: isDark ? AppColors.white : AppColors.darkGrey,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(top: 6.h, right: 5.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppColors.midGreen,
              borderRadius: BorderRadius.circular(15),
            ),
            child: DefaultText(
              text: context.estimatedTime(time.length == 1
                  ? time[0]
                  : time
                      .map((e) => "\nPoint ${time.indexOf(e) + 1}: $e")
                      .toList()
                      .join("")),
              fontSize: 11.sp,
              textColor: AppColors.white,
              maxLines: 5,
            ),
          ),
        )
      ],
    );
  }
}
