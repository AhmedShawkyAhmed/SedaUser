import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/location_cubit/location_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/data/models/request_models/create_or_update_location_request.dart';
import 'package:seda/src/data/models/request_models/get_cars_request.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/home_views/add_favourite_bottom_sheet.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_view.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class HomeBottomView extends StatelessWidget {
  const HomeBottomView({
    super.key,
    required this.getMyLocation,
    required this.showWhereTo,
    required this.mapTypeValueNotifier,
    required this.markerPaddingValueNotifier,
    required this.getLoc,
  });

  final Function() getMyLocation;
  final bool showWhereTo;
  final ValueNotifier<bool> mapTypeValueNotifier;
  final ValueNotifier<double> markerPaddingValueNotifier;
  final ValueNotifier<bool> getLoc;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: 22.h,
            left: 4.w,
            right: 4.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  mapTypeValueNotifier.value = !mapTypeValueNotifier.value;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: showWhereTo ? 46 : 0.w,
                  width: showWhereTo ? 46 : 0.w,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkGrey : AppColors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.7),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: showWhereTo
                        ? ValueListenableBuilder<bool>(
                            valueListenable: mapTypeValueNotifier,
                            builder: (context, mapType, child) {
                              return Icon(
                                mapType == true
                                    ? Icons.map_rounded
                                    : Icons.satellite_alt_rounded,
                                color: isDark
                                    ? AppColors.lightGreen
                                    : AppColors.darkGrey,
                                size: 23,
                              );
                            })
                        : const SizedBox(),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              InkWell(
                onTap: () {
                  getLoc.value = true;
                  getMyLocation().then((value) => getLoc.value = false);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: showWhereTo ? 46 : 0.w,
                  width: showWhereTo ? 46 : 0.w,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkGrey : AppColors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.7),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: getLoc,
                    builder: (context, getLocVal, child) => getLocVal
                        ? CircularProgressIndicator(
                            color: isDark
                                ? AppColors.lightGreen
                                : AppColors.darkGrey,
                          )
                        : Center(
                            child: showWhereTo
                                ? Icon(
                                    Icons.my_location,
                                    color: isDark
                                        ? AppColors.lightGreen
                                        : AppColors.darkGrey,
                                    size: 23,
                                  )
                                : const SizedBox(),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showWhereTo ? 17.5.h : 5.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkGrey : AppColors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 3,
                  color: AppColors.grey.withOpacity(0.75),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: !showWhereTo ? 3 : 0,
                    width: 58,
                    // margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: showWhereTo ? 7.h : 0,
                    margin: const EdgeInsets.only(top: 10),
                    child: Visibility(
                      visible: showWhereTo ? true : false,
                      child: DefaultTextField(
                        controller: toLocations.last == 1
                            ? toLocationAddressController
                            : toLocations.last == 2
                                ? toLocationAddressController1
                                : toLocationAddressController2,
                        hintText: context.whereTo,
                        height: 5.h,
                        bottom: 8,
                        radius: 50,
                        color: AppColors.transparent,
                        borderColor: AppColors.lightGrey,
                        hintTextColor:
                            isDark ? AppColors.lightGrey : AppColors.darkGrey,
                        textColor:
                            isDark ? AppColors.lightGrey : AppColors.darkGrey,
                        readOnly: true,
                        onTap: () {
                          resetToLocations();
                          showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            backgroundColor: AppColors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return DraggableScrollableSheet(
                                initialChildSize: 0.95,
                                builder: (context, scrollController) {
                                  return const RidesHomeView(key: ValueKey(1));
                                },
                              );
                            },
                          );
                        },
                        suffix: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              context: context,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (context) => AddFavouriteBottomSheet(
                                onAddFavourite: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const LoadingIndicator(),
                                  );
                                  LocationCubit.get(context)
                                      .createOrUpdateLocation(
                                    createLocationRequest:
                                        CreateOrUpdateLocationRequest(
                                      lat: toLocationLat,
                                      lon: toLocationLon,
                                      address: toLocationAddressController.text,
                                      type: "fav",
                                    ),
                                    afterSuccess: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      LocationCubit.get(context)
                                          .getFavouriteLocations();
                                    },
                                    afterError: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          child: Image.asset('assets/images/saved.png'),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: showWhereTo ? 6.h : 0.h,
                    padding: EdgeInsets.symmetric(horizontal: 22.w,vertical: 0.5.h),
                    child: DefaultAppButton(
                      title: context.go,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const LoadingIndicator(),
                        );
                        OrderCubit.get(context).getCars(
                          context: context,
                          getCarsRequest: GetCarsRequest(
                              fromLat: fromLocationLat,
                              fromLng: fromLocationLon,
                              shipmentType: shipmentTypeId,
                              toLocations: toLocations
                                  .map((e) => e == 1
                                      ? <double>[
                                          toLocationLat,
                                          toLocationLon,
                                        ]
                                      : e == 2
                                          ? <double>[
                                              toLocationLat1,
                                              toLocationLon1,
                                            ]
                                          : <double>[
                                              toLocationLat2,
                                              toLocationLon2,
                                            ])
                                  .toList()),
                          afterSuccess: () {
                            Navigator.pop(context);
                            if (OrderCubit.get(context)
                                    .carTypes
                                    .data
                                    ?.serial
                                    ?.isNotEmpty ==
                                true) {
                              GlobalCubit.get(context).resetState();
                              OrderCubit.get(context).orderModel = null;
                              waitingDriverToggleView.value = true;
                            } else {
                              showToast(context.rideTypesError);
                            }
                          },
                          afterError: () => Navigator.pop(context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: ValueListenableBuilder<double>(
            valueListenable: markerPaddingValueNotifier,
            builder: (context, markerPadding, child) {
              return SizedBox(
                width: 15.w,
                height: markerPadding == 0.0 ? 18.h : 20.h,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: markerPadding == 0.0 ? 9.w : 9.w,
                      height: 9.w,
                      decoration: BoxDecoration(
                        color: AppColors.midGreen,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: markerPadding == 0.0
                            ? Image.asset("assets/images/logo.png", width: 4.w)
                            : LoadingAnimationWidget.halfTriangleDot(
                                color: AppColors.white,
                                size: 15,
                              ),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 3.5.h,
                      decoration: BoxDecoration(
                        color: AppColors.darkGrey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    markerPadding == 0.0
                        ? const SizedBox()
                        : Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 1.5.w,
                            height: 1.5.w,
                            decoration: BoxDecoration(
                              color: AppColors.midGreen.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
