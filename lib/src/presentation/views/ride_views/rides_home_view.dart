import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/business_logic/ride_cubit/ride_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/data/models/request_models/get_cars_request.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/ride_views/location_picker_search_places_bottom_view.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_fav_locations_view.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_recent_locations_view.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_text_field_view.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class RidesHomeView extends StatefulWidget {
  const RidesHomeView({Key? key}) : super(key: key);

  @override
  State<RidesHomeView> createState() => _RidesHomeViewState();
}

class _RidesHomeViewState extends State<RidesHomeView>
    with TickerProviderStateMixin {
  bool show = false;
  int count = toLocations.length;
  int? _focusedLocation;

  late GoogleMapsPlaces _mapsPlaces;

  final List<Prediction> _predictions = [];

  @override
  void initState() {
    super.initState();
    _mapsPlaces = GoogleMapsPlaces(apiKey: EndPoints.googleMapKey);
    RideCubit.get(context).toggleIsSearching(false);
    getMyLocation((location, address) => setState(() {
          userLocation = address;
        }));
  }

  autoCompleteSearch(String input) async {
    var result = await _mapsPlaces.autocomplete(
      input,
      components: [
        Component(Component.country, "eg"),
        Component(Component.country, "sa")
      ],
      language: context.isAr ? 'ar' : 'en',
      location: Location(
        lat: fromLocationLat,
        lng: fromLocationLon,
      ),
    );
    if (result.errorMessage == null && mounted) {
      printResponse(
        '${result.predictions[0].description}',
      );
      // printResponse(
      //   result.predictions[0].structuredFormatting!.secondaryText.toString(),
      // );
      _predictions.clear();
      _predictions.addAll(result.predictions);
    } else {
      showToast(
        result.errorMessage!,
        gravity: ToastGravity.SNACKBAR,
        color: AppColors.lightRed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
      builder: (BuildContext context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 100.w,
            height: 95.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkGrey : AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Container(
                    width: 15.w,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(
                  width: 95.w,
                  height: ((count + 1) * 7).h + 3.h,
                  child: RidesHomeTextFieldView(
                    key: widget.key,
                    updateFocusedLocation: (index) {
                      printSuccess(index.toString());
                      setState(() {
                        _focusedLocation = index;
                      });
                    },
                    updateState: () => setState(() {}),
                    count: count,
                    updateCount: (index) {
                      setState(() {
                        count == 1 && index == 0
                            ? count = count + 1
                            : count == 2 && index == 1
                                ? count = count + 1
                                : count = count - 1;
                      });
                    },
                    autoCompleteSearch: autoCompleteSearch,
                  ),
                ),
                RideCubit.get(context).isSearchingLocation
                    ? const SizedBox()
                    : Column(
                        children: [
                          Center(
                            child: SizedBox(
                              height: 6.5.h,
                              width: double.infinity,
                              child: RidesHomeFavLocationsView(
                                page: 0,
                                onFavLocationSelected: (location) {
                                  if (_focusedLocation != null) {
                                    switch (_focusedLocation) {
                                      case 0:
                                        fromLocationLat = location.latitude!;
                                        fromLocationLon = location.longitude!;
                                        fromLocationAddressController.text =
                                            location.address!;
                                        break;
                                      case 1:
                                        toLocationLat = location.latitude!;
                                        toLocationLon = location.longitude!;
                                        toLocationAddressController.text =
                                            location.address!;
                                        break;
                                      case 2:
                                        toLocationLat1 = location.latitude!;
                                        toLocationLon1 = location.longitude!;
                                        toLocationAddressController1.text =
                                            location.address!;
                                        break;
                                      case 3:
                                        toLocationLat2 = location.latitude!;
                                        toLocationLon2 = location.longitude!;
                                        toLocationAddressController2.text =
                                            location.address!;
                                        break;
                                    }
                                    setState(() {
                                      _focusedLocation = null;
                                    });
                                  } else {
                                    setState(() {
                                      toLocationLat =
                                          location.latitude!.toDouble();
                                      toLocationLon =
                                          location.longitude!.toDouble();
                                      toLocationAddressController.text =
                                          location.address!;
                                      toLocations
                                        ..clear()
                                        ..add(1);
                                      count = toLocations.length;
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
                                        Navigator.pop(context);
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
                              ),
                            ),
                          ),
                          Container(
                            width: 100.w,
                            height: 1.h,
                            color: AppColors.lightGrey,
                          ),
                          if (widget.key == const ValueKey(1))
                            InkWell(
                              onTap: () {
                                getMyLocation((location, address) {
                                  fromLocationAddressController.text = address;
                                  fromLocationLat = location.latitude;
                                  fromLocationLon = location.longitude;
                                  userLocation = address;
                                  setState(() {});
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 10,
                                  left: 25,
                                  right: 25,
                                ),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        // width: 5.w,
                                        // height: 4.w,
                                        radius: 20,
                                        backgroundColor: AppColors.lightGrey,
                                        child: SvgPicture.asset(
                                          "assets/images/gis_location.svg",
                                          color: AppColors.darkGrey
                                              .withOpacity(.8),
                                          height: 18,
                                          width: 18,
                                        )),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 70.w,
                                            child: DefaultText(
                                              text: context.userLocation,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 70.w,
                                            child: DefaultText(
                                              text: userLocation,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (widget.key == const ValueKey(1))
                            Container(
                              width: 100.w,
                              height: 1.h,
                              color: AppColors.lightGrey,
                            ),
                        ],
                      ),
                Expanded(
                  child: RideCubit.get(context).isSearchingLocation
                      ? LocationPickerSearchPlacesBottomView(
                          mapsPlaces: _mapsPlaces,
                          predictions: _predictions,
                          updateLocation:
                              (double lat, double lon, String address) {
                            setState(
                              () {
                                switch (_focusedLocation) {
                                  case 0:
                                    fromLocationLat = lat;
                                    fromLocationLon = lon;
                                    fromLocationAddressController.text =
                                        address;
                                    break;
                                  case 1:
                                    toLocationLat = lat;
                                    toLocationLon = lon;
                                    toLocationAddressController.text = address;
                                    break;
                                  case 2:
                                    toLocationLat1 = lat;
                                    toLocationLon1 = lon;
                                    toLocationAddressController1.text = address;
                                    break;
                                  case 3:
                                    toLocationLat2 = lat;
                                    toLocationLon2 = lon;
                                    toLocationAddressController2.text = address;
                                    break;
                                }
                                setState(() {
                                  _focusedLocation = null;
                                });
                                RideCubit.get(context).toggleIsSearching(false);
                              },
                            );
                          },
                        )
                      : RidesHomeRecentLocationView(
                          onRecentLocationSelect: (location) {
                            if (_focusedLocation != null) {
                              switch (_focusedLocation) {
                                case 0:
                                  fromLocationLat = location.latitude!;
                                  fromLocationLon = location.longitude!;
                                  fromLocationAddressController.text =
                                      location.address!;
                                  break;
                                case 1:
                                  toLocationLat = location.latitude!;
                                  toLocationLon = location.longitude!;
                                  toLocationAddressController.text =
                                      location.address!;
                                  break;
                                case 2:
                                  toLocationLat1 = location.latitude!;
                                  toLocationLon1 = location.longitude!;
                                  toLocationAddressController1.text =
                                      location.address!;
                                  break;
                                case 3:
                                  toLocationLat2 = location.latitude!;
                                  toLocationLon2 = location.longitude!;
                                  toLocationAddressController2.text =
                                      location.address!;
                                  break;
                              }
                              setState(() {
                                _focusedLocation = null;
                              });
                            } else {
                              setState(() {
                                toLocationLat = location.latitude!;
                                toLocationLon = location.longitude!;
                                toLocationAddressController.text =
                                    location.address!;
                                toLocations
                                  ..clear()
                                  ..add(1);
                                count = toLocations.length;
                              });
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
                                      .toList(),
                                ),
                                afterSuccess: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  if (OrderCubit.get(context)
                                          .carTypes
                                          .data
                                          ?.serial
                                          ?.isNotEmpty ==
                                      true) {
                                    // showModalBottomSheet<dynamic>(
                                    //   isScrollControlled: true,
                                    //   transitionAnimationController: controller,
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
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: fromLocationAddressController.text.trim().isNotEmpty &&
                          toLocations.every((element) => element == 1
                              ? toLocationAddressController.text
                                  .trim()
                                  .isNotEmpty
                              : element == 2
                                  ? toLocationAddressController1.text
                                      .trim()
                                      .isNotEmpty
                                  : toLocationAddressController2.text
                                      .trim()
                                      .isNotEmpty)
                      ? DefaultAppButton(
                          height: 7.h,
                          title: context.confirm,
                          onTap: widget.key == const ValueKey(1)
                              ? () {
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
                                      Navigator.pop(context);
                                      if (OrderCubit.get(context)
                                              .carTypes
                                              .data
                                              ?.serial
                                              ?.isNotEmpty ==
                                          true) {
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
                              : () {
                                  //ToDo function to add drop off points or change them
                                },
                        )
                      : DefaultAppButton(
                          height: 7.h,
                          isGradient: false,
                          buttonColor: AppColors.lightGrey,
                          title: context.confirm,
                          textColor: AppColors.grey2,
                          onTap: () {
                            // print(_items[0].text.isNotEmpty);
                          },
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
