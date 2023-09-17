import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/location_cubit/location_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/request_models/create_or_update_location_request.dart';
import 'package:seda/src/data/models/request_models/get_cars_request.dart';
import 'package:seda/src/presentation/views/home_views/home_app_bar_view.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_view.dart';
import 'package:seda/src/presentation/views/ride_views/select_location_view.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/category_item.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:seda/src/presentation/widgets/quick_location.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class HomeAboveSheet extends StatelessWidget {
  const HomeAboveSheet({
    Key? key,
    required this.fav,
    required this.updateState,
    required this.updateFav,
    required this.showWhereTo,
  }) : super(key: key);

  final bool fav;
  final bool showWhereTo;
  final Function() updateState;
  final Function(bool fav) updateFav;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 40,
      ),
      width: 100.w,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGrey : AppColors.white,
      ),
      child: showWhereTo
          ? const HomeAppBarView()
          : ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const HomeAppBarView(),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: CategoryItem(
                    title: context.ride,
                    image: "assets/images/carBlack.png",
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
                              return const RidesHomeView(
                                  key: ValueKey(1));
                            },
                          );
                        },
                      );
                    },
                    imageWidth: 20.w,
                    imageHeight: 13.w,
                    width: 90.w,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryItem(
                      title: context.scooter,
                      image: "assets/images/scooter.svg",
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouterNames.scooterAsk,
                      ),
                      isNew: true,
                      imageWidth: 13.w,
                      imageHeight: 13.w,
                      width: 90.w,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 21,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 20),
                  child: InkWell(
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
                    child: Container(
                      width: 86.w,
                      height: 5.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.lightGrey,
                          )),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DefaultTextField(
                            enabled: false,
                            height: 7.h,
                            width: 50.w,
                            alignment: Alignment.centerLeft,
                            controller: toLocationAddressController,
                            hintText: context.whereTo,
                            borderColor: AppColors.transparent,
                            textColor: AppColors.grey,
                            color: AppColors.transparent,
                          ),
                          Container(
                            width: 0.5.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          Container(
                            width: 22.w,
                            height: 3.5.h,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Transform.rotate(
                                    angle: -90,
                                    child: Icon(
                                      Icons.access_time_filled_rounded,
                                      color: AppColors.darkGrey,
                                      size: 12.sp,
                                    ),
                                  ),
                                  DefaultText(
                                    text: context.now,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp,
                                    fontFamily: 'Calibri',
                                    textColor: AppColors.darkGrey,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: AppColors.darkGrey,
                                    size: 10.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => updateFav(!fav),
                            child: Image.asset(
                              'assets/images/saved.png',
                              color: AppColors.midGreen,
                              height: 2.6.h,
                              width: 5.2.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  color: isDark ? AppColors.white : AppColors.lightGrey,
                ),
                SizedBox(
                  height: 23.h,
                  child: BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, state) {
                      final favourites =
                          LocationCubit.get(context).favouriteLocations;
                      final home = LocationCubit.get(context).home;
                      final work = LocationCubit.get(context).work;
                      final recent = LocationCubit.get(context).recentLocations;
                      if (!fav && recent.isEmpty) {
                        return Center(
                          child: DefaultText(
                            text: context.emptyRecent,
                          ),
                        );
                      }
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount:
                              fav ? favourites.length + 3 : recent.length,
                          itemBuilder: (context, position) {
                            if (position == 0 && fav) {
                              return QuickLocation(
                                onDelete: home != null
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const LoadingIndicator(),
                                        );
                                        LocationCubit.get(context)
                                            .deleteLocation(
                                          id: home.id!,
                                          afterSuccess: () =>
                                              Navigator.pop(context),
                                          afterError: () =>
                                              Navigator.pop(context),
                                        );
                                      }
                                    : null,
                                onUpdate: home != null
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const SelectLocationView();
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const LoadingIndicator());
                                            final result =
                                                value as Map<String, dynamic>;
                                            LocationCubit.get(context)
                                                .createOrUpdateLocation(
                                              createLocationRequest:
                                                  CreateOrUpdateLocationRequest(
                                                lat: result['lat'],
                                                lon: result['lon'],
                                                address: result['address'],
                                                type: 'home',
                                                locationId: home.id,
                                              ),
                                              afterSuccess: () =>
                                                  LocationCubit.get(context)
                                                      .getFavouriteLocations(
                                                afterSuccess: () =>
                                                    Navigator.pop(context),
                                                afterError: () =>
                                                    Navigator.pop(context),
                                              ),
                                              afterError: () =>
                                                  Navigator.pop(context),
                                            );
                                          }
                                        });
                                      }
                                    : null,
                                onTap: () {
                                  if (home == null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const SelectLocationView();
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const LoadingIndicator());
                                        final result =
                                            value as Map<String, dynamic>;
                                        LocationCubit.get(context)
                                            .createOrUpdateLocation(
                                          createLocationRequest:
                                              CreateOrUpdateLocationRequest(
                                            lat: result['lat'],
                                            lon: result['lon'],
                                            address: result['address'],
                                            type: 'home',
                                          ),
                                          afterSuccess: () =>
                                              LocationCubit.get(context)
                                                  .getFavouriteLocations(
                                            afterSuccess: () =>
                                                Navigator.pop(context),
                                            afterError: () =>
                                                Navigator.pop(context),
                                          ),
                                          afterError: () =>
                                              Navigator.pop(context),
                                        );
                                      }
                                    });
                                  } else {
                                    toLocationLat = home.latitude!.toDouble();
                                    toLocationLon = home.longitude!.toDouble();
                                    toLocationAddressController.text =
                                        home.address!;
                                    toLocations
                                      ..clear()
                                      ..add(1);
                                    updateState();
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const LoadingIndicator(),
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
                                            .toList(),
                                      ),
                                      afterSuccess: () {
                                        Navigator.pop(context);
                                        if (OrderCubit.get(context)
                                                .carTypes
                                                .data
                                                ?.serial
                                                ?.isNotEmpty ==
                                            true) {
                                          // showModalBottomSheet<dynamic>(
                                          //   isScrollControlled: true,
                                          //   transitionAnimationController:
                                          //       controller,
                                          //   backgroundColor:
                                          //       AppColors.transparent,
                                          //   context: context,
                                          //   builder: (BuildContext bc) {
                                          //     return const SelectRideScreen();
                                          //   },
                                          // );
                                          GlobalCubit.get(context).resetState();
                                          OrderCubit.get(context).orderModel =
                                              null;
                                          waitingDriverToggleView.value = true;
                                        } else {
                                          showToast(context.rideTypesError);
                                        }
                                      },
                                      afterError: () => Navigator.pop(context),
                                    );
                                  }
                                },
                                address: home?.address ?? context.home,
                                title: context.home,
                                icon: Icons.home_rounded,
                              );
                            } else if (position == 1 && fav) {
                              return QuickLocation(
                                onDelete: work != null
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const LoadingIndicator(),
                                        );
                                        LocationCubit.get(context)
                                            .deleteLocation(
                                          id: work.id!,
                                          afterSuccess: () =>
                                              Navigator.pop(context),
                                          afterError: () =>
                                              Navigator.pop(context),
                                        );
                                      }
                                    : null,
                                onUpdate: work != null
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const SelectLocationView();
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const LoadingIndicator());
                                            final result =
                                                value as Map<String, dynamic>;
                                            LocationCubit.get(context)
                                                .createOrUpdateLocation(
                                              createLocationRequest:
                                                  CreateOrUpdateLocationRequest(
                                                lat: result['lat'],
                                                lon: result['lon'],
                                                address: result['address'],
                                                type: 'work',
                                                locationId: work.id,
                                              ),
                                              afterSuccess: () =>
                                                  LocationCubit.get(context)
                                                      .getFavouriteLocations(
                                                afterSuccess: () =>
                                                    Navigator.pop(context),
                                                afterError: () =>
                                                    Navigator.pop(context),
                                              ),
                                              afterError: () =>
                                                  Navigator.pop(context),
                                            );
                                          }
                                        });
                                      }
                                    : null,
                                onTap: () {
                                  if (work == null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const SelectLocationView();
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const LoadingIndicator());
                                        final result =
                                            value as Map<String, dynamic>;
                                        LocationCubit.get(context)
                                            .createOrUpdateLocation(
                                          createLocationRequest:
                                              CreateOrUpdateLocationRequest(
                                            lat: result['lat'],
                                            lon: result['lon'],
                                            address: result['address'],
                                            type: 'work',
                                          ),
                                          afterSuccess: () =>
                                              LocationCubit.get(context)
                                                  .getFavouriteLocations(
                                            afterSuccess: () =>
                                                Navigator.pop(context),
                                            afterError: () =>
                                                Navigator.pop(context),
                                          ),
                                          afterError: () =>
                                              Navigator.pop(context),
                                        );
                                      }
                                    });
                                  } else {
                                    toLocationLat = work.latitude!.toDouble();
                                    toLocationLon = work.longitude!.toDouble();
                                    toLocationAddressController.text =
                                        work.address!;
                                    toLocations
                                      ..clear()
                                      ..add(1);
                                    updateState();
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const LoadingIndicator(),
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
                                            .toList(),
                                      ),
                                      afterSuccess: () {
                                        Navigator.pop(context);
                                        if (OrderCubit.get(context)
                                                .carTypes
                                                .data
                                                ?.serial
                                                ?.isNotEmpty ==
                                            true) {
                                          // showModalBottomSheet<dynamic>(
                                          //   isScrollControlled: true,
                                          //   transitionAnimationController:
                                          //       controller,
                                          //   backgroundColor:
                                          //       AppColors.transparent,
                                          //   context: context,
                                          //   builder: (BuildContext bc) {
                                          //     return const SelectRideScreen();
                                          //   },
                                          // );
                                          GlobalCubit.get(context).resetState();
                                          OrderCubit.get(context).orderModel =
                                              null;
                                          waitingDriverToggleView.value = true;
                                        } else {
                                          showToast(context.rideTypesError);
                                        }
                                      },
                                      afterError: () => Navigator.pop(context),
                                    );
                                  }
                                },
                                address: work?.address ?? context.work,
                                title: context.work,
                                icon: Icons.work_rounded,
                              );
                            } else if (position == 2 && fav) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DefaultText(
                                        text: context.favourite,
                                        fontSize: 20,
                                        textColor: Colors.blueGrey),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const SelectLocationView();
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const LoadingIndicator(),
                                            );
                                            final result =
                                                value as Map<String, dynamic>;
                                            LocationCubit.get(context)
                                                .createOrUpdateLocation(
                                                    createLocationRequest:
                                                        CreateOrUpdateLocationRequest(
                                                      lat: result['lat'],
                                                      lon: result['lon'],
                                                      address:
                                                          result['address'],
                                                      type: "fav",
                                                    ),
                                                    afterSuccess: () {
                                                      Navigator.pop(context);
                                                      LocationCubit.get(context)
                                                          .getFavouriteLocations();
                                                    },
                                                    afterError: () {
                                                      Navigator.pop(context);
                                                    });
                                          }
                                        });
                                      },
                                      child: DefaultText(
                                        text: context.addOne,
                                        fontSize: 18,
                                        textColor: AppColors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(),
                              child: QuickLocation(
                                onDelete: fav
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const LoadingIndicator(),
                                        );
                                        LocationCubit.get(context)
                                            .deleteLocation(
                                          id: favourites[position - 3]
                                              .id!
                                              .toInt(),
                                          afterSuccess: () =>
                                              Navigator.pop(context),
                                          afterError: () =>
                                              Navigator.pop(context),
                                        );
                                      }
                                    : null,
                                onUpdate: fav
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const SelectLocationView();
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const LoadingIndicator());
                                            final result =
                                                value as Map<String, dynamic>;
                                            LocationCubit.get(context)
                                                .createOrUpdateLocation(
                                              createLocationRequest:
                                                  CreateOrUpdateLocationRequest(
                                                lat: result['lat'],
                                                lon: result['lon'],
                                                address: result['address'],
                                                type: 'fav',
                                                locationId:
                                                    favourites[position - 3].id,
                                              ),
                                              afterSuccess: () =>
                                                  LocationCubit.get(context)
                                                      .getFavouriteLocations(
                                                afterSuccess: () =>
                                                    Navigator.pop(context),
                                                afterError: () =>
                                                    Navigator.pop(context),
                                              ),
                                              afterError: () =>
                                                  Navigator.pop(context),
                                            );
                                          }
                                        });
                                      }
                                    : null,
                                onTap: () async {
                                  final lat = fav
                                      ? favourites[position - 3]
                                          .latitude
                                          ?.toDouble()
                                      : recent[position].latitude;
                                  final lon = fav
                                      ? favourites[position - 3]
                                          .longitude
                                          ?.toDouble()
                                      : recent[position].longitude;
                                  final address = fav
                                      ? favourites[position - 3].address
                                      : recent[position].address;
                                  if (lat != null && lon != null) {
                                    toLocationLat = lat;
                                    toLocationLon = lon;
                                    toLocationAddressController.text = address!;
                                    toLocations
                                      ..clear()
                                      ..add(1);
                                    updateState();
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const LoadingIndicator(),
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
                                            .toList(),
                                      ),
                                      afterSuccess: () {
                                        Navigator.pop(context);
                                        if (OrderCubit.get(context)
                                                .carTypes
                                                .data
                                                ?.serial
                                                ?.isNotEmpty ==
                                            true) {
                                          // showModalBottomSheet<dynamic>(
                                          //   isScrollControlled: true,
                                          //   transitionAnimationController:
                                          //       controller,
                                          //   backgroundColor:
                                          //       AppColors.transparent,
                                          //   context: context,
                                          //   builder: (BuildContext bc) {
                                          //     return const SelectRideScreen();
                                          //   },
                                          // );
                                          OrderCubit.get(context).orderModel =
                                              null;
                                          GlobalCubit.get(context).resetState();
                                          waitingDriverToggleView.value = true;
                                        } else {
                                          showToast(context.rideTypesError);
                                        }
                                      },
                                      afterError: () => Navigator.pop(context),
                                    );
                                  }
                                },
                                title: fav
                                    ? context.favoriteLocations
                                    : context.recentLocations,
                                address:
                                    "${fav ? favourites[position - 3].address : recent[position].address}",
                                icon: Icons.access_time_filled_rounded,
                              ),
                            );
                          });
                    },
                  ),
                )
              ],
            ),
    );
  }
}
