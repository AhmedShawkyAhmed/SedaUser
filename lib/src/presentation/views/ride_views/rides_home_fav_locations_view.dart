import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/location_cubit/location_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/data/models/request_models/get_cars_request.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/location_model.dart';
import 'package:seda/src/data/models/request_models/create_or_update_location_request.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/views/ride_views/select_location_view.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_favorite_locations_view.dart';
import 'package:seda/src/presentation/widgets/toast.dart';

class RidesHomeFavLocationsView extends StatefulWidget {
  const RidesHomeFavLocationsView({
    Key? key,
    required this.onFavLocationSelected,
    required this.page,
    this.controller,
  }) : super(key: key);

  final Function(LocationModel location) onFavLocationSelected;
  final int page;
  final int? controller;

  @override
  State<RidesHomeFavLocationsView> createState() =>
      _RidesHomeFavLocationsViewState();
}

class _RidesHomeFavLocationsViewState extends State<RidesHomeFavLocationsView>
    with TickerProviderStateMixin {
  late final AnimationController controller1;
  late final AnimationController controller2;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        final favourite = LocationCubit.get(context).favouriteLocations;
        final home = LocationCubit.get(context).home;
        final work = LocationCubit.get(context).work;
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          GestureDetector(
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
                        builder: (context) => const LoadingIndicator());
                    final result = value as Map<String, dynamic>;
                    LocationCubit.get(context).createOrUpdateLocation(
                      createLocationRequest: CreateOrUpdateLocationRequest(
                        lat: result['lat'],
                        lon: result['lon'],
                        address: result['address'],
                        type: 'home',
                      ),
                      afterSuccess: () =>
                          LocationCubit.get(context).getFavouriteLocations(
                        afterSuccess: () => Navigator.pop(context),
                        afterError: () => Navigator.pop(context),
                      ),
                      afterError: () => Navigator.pop(context),
                    );
                  }
                });
              } else {
                widget.onFavLocationSelected(home);
              }
            },
            child: Container(
              color: AppColors.transparent,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.home_rounded,
                    size: 18,
                    color: isDark ? AppColors.lightGrey : AppColors.darkGrey,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    context.home,
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
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
                        builder: (context) => const LoadingIndicator());
                    final result = value as Map<String, dynamic>;
                    LocationCubit.get(context).createOrUpdateLocation(
                      createLocationRequest: CreateOrUpdateLocationRequest(
                        lat: result['lat'],
                        lon: result['lon'],
                        address: result['address'],
                        type: 'work',
                      ),
                      afterSuccess: () =>
                          LocationCubit.get(context).getFavouriteLocations(
                        afterSuccess: () => Navigator.pop(context),
                        afterError: () => Navigator.pop(context),
                      ),
                      afterError: () => Navigator.pop(context),
                    );
                  }
                });
              } else {
                widget.onFavLocationSelected(work);
              }
            },
            child: Container(
              color: AppColors.transparent,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.work_rounded,
                    size: 16,
                    color: isDark ? AppColors.lightGrey : AppColors.darkGrey,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    context.work,
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                backgroundColor: AppColors.transparent,
                transitionAnimationController: controller1,
                context: context,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.90,
                    builder: (context, scrollController) {
                      return RidesHomeFavoriteLocationsView(
                        onFavLocationSelected: widget.page == 0
                            ? (location) {
                                setState(() {
                                  toLocationLat = location.latitude!.toDouble();
                                  toLocationLon =
                                      location.longitude!.toDouble();
                                  toLocationAddressController.text =
                                      location.address!;
                                });
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
                                    if (OrderCubit.get(context)
                                            .carTypes
                                            .data
                                            ?.serial
                                            ?.isNotEmpty ==
                                        true) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      // showModalBottomSheet<dynamic>(
                                      //   isScrollControlled: true,
                                      //   transitionAnimationController:
                                      //       controller2,
                                      //   backgroundColor: AppColors.transparent,
                                      //   context: context,
                                      //   builder: (BuildContext bc) {
                                      //     return const SelectRideScreen();
                                      //   },
                                      // );
                                      GlobalCubit.get(context).resetState();
                                      OrderCubit.get(context).orderModel = null;
                                      waitingDriverToggleView.value = true;
                                    } else {
                                      showToast(context.rideTypesError);
                                    }
                                  },
                                  afterError: () => Navigator.pop(context),
                                );
                              }
                            : (location) {
                                widget.onFavLocationSelected(location);
                                Navigator.pop(context);
                              },
                      );
                    },
                  );
                },
              );
            },
            child: Container(
              color: AppColors.transparent,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/saved.png',
                    color: isDark ? AppColors.lightGrey : AppColors.darkGrey,
                    height: 15,
                    width: 16,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    context.saved,
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          )
        ]);
      },
    );
  }
}
