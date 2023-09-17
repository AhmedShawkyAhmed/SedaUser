import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

import '../../../../business_logic/global_cubit/global_cubit.dart';
import '../../../../business_logic/order_cubit/order_cubit.dart';
import '../../../../constants/constants_methods.dart';
import '../../../../constants/constants_variables.dart';
import '../../../../constants/shared_preference_keys.dart';
import '../../../../data/models/request_models/make_order_request.dart';
import '../../../widgets/loading_indicator.dart';
import 'cancel_reason_view.dart';
import '../../ride_views/select_location_view.dart';

class CancelRideView extends StatefulWidget {
  const CancelRideView(
      {Key? key,
      required this.updateCancel,
      required this.accepted,
      required this.driverArrived})
      : super(key: key);

  final Function() updateCancel;
  final bool accepted;
  final bool driverArrived;

  @override
  State<CancelRideView> createState() => _CancelRideViewState();
}

class _CancelRideViewState extends State<CancelRideView> {


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
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
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
              child: DefaultText(
                text: context.doYouWantToCancelTrip,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
            Divider(
              height: 1.5.h,
              thickness: 1,
              color: AppColors.lightGrey,
            ),
            if (widget.accepted)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                child: DefaultText(
                    text: context.alternativelyYouCanFindAnotherDriver,
                    align: TextAlign.center,
                    fontSize: 13.sp,
                    maxLines: 2,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter'),
              ),
            if (widget.accepted)
              Divider(
                height: 1.5.h,
                thickness: 1,
                color: AppColors.lightGrey,
              ),
            SizedBox(
              height: (6.h *
                      (OrderCubit.get(context).orderModel?.toLocation!.length ??
                          0)) +
                  0.5.h,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    OrderCubit.get(context).orderModel?.toLocation!.length ?? 0,
                padding: EdgeInsets.zero,
                itemBuilder: (context, position) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  text: OrderCubit.get(context)
                                          .orderModel
                                          ?.toLocation![position]
                                          .address ??
                                      'Empty Address',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (OrderCubit.get(context)
                                    .orderModel!
                                    .toLocation![position] ==
                                OrderCubit.get(context)
                                    .orderModel!
                                    .toLocation!
                                    .last &&
                            OrderCubit.get(context)
                                    .orderModel!
                                    .toLocation!
                                    .length !=
                                3)
                          DefaultText(
                            text: context.addOrChange,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            textColor: AppColors.primary,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const SelectLocationView();
                                },
                              ).then((value) {
                                if (value != null) {
                                  toLocations.add(toLocations.contains(1)
                                      ? toLocations.contains(2)
                                          ? 3
                                          : 2
                                      : 1);
                                  final result = value as Map<String, dynamic>;
                                  OrderCubit.get(context).addNewDropOff(
                                    addNewDropOff: AddNewDropOff(
                                      orderId: int.parse(CacheHelper
                                          .sharedPreferences
                                          .get(SharedPreferenceKeys.orderId)
                                          .toString()),
                                      toLocationLat: result['lat'],
                                      toLocationLon: result['lon'],
                                      toLocationAddress: result['address'],
                                    ),
                                    afterError: () {
                                      toLocations.removeLast();
                                      printError("add new location error!");
                                    },
                                    afterSuccess: () {
                                      resetToLocations();
                                      final orderToLocations =
                                          OrderCubit.get(context)
                                              .orderModel!
                                              .toLocation!;
                                      for (int i = 0;
                                          i < orderToLocations.length;
                                          i++) {
                                        if (i == 0) {
                                          toLocationLat =
                                              orderToLocations[i].latitude!;
                                          toLocationLon =
                                              orderToLocations[i].longitude!;
                                          toLocationAddressController.text =
                                              orderToLocations[i].address ?? '';
                                        } else if (i == 1) {
                                          toLocations.add(2);
                                          toLocationLat1 =
                                              orderToLocations[i].latitude!;
                                          toLocationLon1 =
                                              orderToLocations[i].longitude!;
                                          toLocationAddressController1.text =
                                              orderToLocations[i].address ?? '';
                                        } else if (i == 2) {
                                          toLocations.add(3);
                                          toLocationLat2 =
                                              orderToLocations[i].latitude!;
                                          toLocationLon2 =
                                              orderToLocations[i].longitude!;
                                          toLocationAddressController2.text =
                                              orderToLocations[i].address ?? '';
                                        }
                                      }
                                      printSuccess(
                                          'gggggggggggggggggggggggggggggggggggggggggg');

                                      setState(() {});
                                    },
                                  );
                                  printSuccess(toLocations.toString());
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
              height: 1.5.h,
              thickness: 1,
              color: AppColors.lightGrey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: DefaultText(
                onTap: () {
                  if (OrderCubit.get(context).orderModel != null) {
                    showModalBottomSheet<dynamic>(
                      isScrollControlled: true,
                      backgroundColor: AppColors.transparent,
                      context: context,
                      builder: (BuildContext bc) {
                        return CancelReasonView(
                          driverArrived: widget.driverArrived,
                        );
                      },
                    ).then((value) {
                      if (value == true) {
                        widget.updateCancel();
                      }
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => WillPopScope(
                        child: const LoadingIndicator(),
                        onWillPop: () => Future.value(false),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 1)).then(
                      (value) => {
                        resetOrder(),
                        GlobalCubit.get(context).resetState(),
                        waitingDriverToggleView.value = false,
                        Navigator.popUntil(context, (route) => route.isFirst),
                      },
                    );
                  }
                },
                text: context.yesCancelTrip,
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                textColor: AppColors.red,
              ),
            ),
            // if (widget.accepted)
            //   DefaultAppButton(
            //     width: 75.w,
            //     height: 6.h,
            //     title: context.findAnotherDriver,
            //     onTap: () {
            //     },
            //     isGradient: true,
            //     gradientColors: const [Color(0xff185A9D), Color(0xff43CEA2)],
            //   ),
            SizedBox(
              height: 2.2.h,
            ),
          ],
        ),
      ),
    );
  }
}
