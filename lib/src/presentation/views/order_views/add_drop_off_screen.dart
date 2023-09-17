import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/business_logic/ride_cubit/ride_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/models/request_models/make_order_request.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/views/ride_views/location_picker_search_places_bottom_view.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_fav_locations_view.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_recent_locations_view.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/views/ride_views/select_location_view.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class AddDropOffScreen extends StatefulWidget {
  const AddDropOffScreen({Key? key}) : super(key: key);

  @override
  State<AddDropOffScreen> createState() => _AddDropOffScreenState();
}

class _AddDropOffScreenState extends State<AddDropOffScreen> {
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    controller = toLocations.contains(1)
        ? toLocations.contains(2)
            ? 3
            : 2
        : 1;
    _mapsPlaces = GoogleMapsPlaces(apiKey: EndPoints.googleMapKey);
    RideCubit.get(context).toggleIsSearching(false);
    getMyLocation((location, address) {
      if (mounted) {
        setState(() {
          userLocation = address;
        });
      }
    });
  }

  late TextEditingController searchController;

  bool show = false;
  bool removeLocation = false;

  int controller = 0;

  late GoogleMapsPlaces _mapsPlaces;

  final List<Prediction> _predictions = [];

  autoCompleteSearch(String input) async {
    var result = await _mapsPlaces.autocomplete(input);
    if (result.errorMessage == null && mounted) {
      printResponse('${result.predictions[0].description}');
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 100.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkGrey : AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 20),
                child: Container(
                  width: 15.w,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                child: DefaultText(
                  text: context.addNewDropOff,
                  fontSize: 15.sp,
                  align: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: DefaultTextField(
                  height: 5.5.h,
                  onChanged: (val) {
                    RideCubit.get(context).toggleIsSearching(true);
                    if (val.isNotEmpty) {
                      autoCompleteSearch(val);
                      RideCubit.get(context).toggleIsSearching(true);
                      setState(() {
                        removeLocation = true;
                      });
                    } else {
                      RideCubit.get(context).toggleIsSearching(false);
                      setState(() {
                        removeLocation = false;
                      });
                    }
                    setState(() {});
                  },
                  onTap: () {
                    setState(() {
                      if (searchController.text.trim().isNotEmpty) {
                        setState(() {
                          removeLocation = true;
                        });
                      } else {
                        setState(() {
                          removeLocation = false;
                        });
                      }
                    });
                  },
                  bottom: 2,
                  padding: const EdgeInsets.only(left: 10),
                  suffix: SizedBox(
                    width: removeLocation
                        ? 20.w
                        : toLocations.length != 1
                            ? 18.w
                            : 10.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (removeLocation)
                          InkWell(
                            onTap: () {
                              for (int i = 0; i < toLocations.length; i++) {
                                if (toLocations[i] == controller) {
                                  toLocationAddressController.clear();
                                  toLocationLat = 0;
                                  toLocationLon = 0;
                                } else if (toLocations[i] == controller) {
                                  toLocationAddressController1.clear();
                                  toLocationLat1 = 0;
                                  toLocationLon1 = 0;
                                } else {
                                  toLocationAddressController2.clear();
                                  toLocationLat2 = 0;
                                  toLocationLon2 = 0;
                                }
                              }
                              searchController.clear();
                              removeLocation = false;
                              RideCubit.get(context).toggleIsSearching(false);
                              setState(() {});
                            },
                            child: Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                    color: AppColors.darkGrey.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: AppColors.white,
                                  size: 14,
                                )),
                          ),
                        const SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const SelectLocationView();
                              },
                            ).then((value) {
                              if (value != null) {
                                final result = value as Map<String, dynamic>;
                                setState(() {
                                  if (controller == 1) {
                                    toLocationLat = result['lat'];
                                    toLocationLon = result['lon'];
                                    toLocationAddressController.text =
                                        result['address'];
                                  } else if (controller == 2) {
                                    toLocationLat1 = result['lat'];
                                    toLocationLon1 = result['lon'];
                                    toLocationAddressController1.text =
                                        result['address'];
                                  } else {
                                    toLocationLat2 = result['lat'];
                                    toLocationLon2 = result['lon'];
                                    toLocationAddressController2.text =
                                        result['address'];
                                  }
                                  searchController.text = result['address'];
                                });
                              }
                            });
                          },
                          child: const Icon(
                            Icons.my_location,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 12.5,
                        ),
                      ],
                    ),
                  ),
                  controller: searchController,
                  hintText: context.whereTo,
                  borderColor: AppColors.lightGrey,
                  radius: 50,
                  shadow: const BoxShadow(),
                  textColor: AppColors.darkGrey,
                  focused: true,
                  color: AppColors.transparent,
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
                              page: 1,
                              controller: controller,
                              onFavLocationSelected: (location) {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const LoadingIndicator(),
                                );
                                setState(() {
                                  if (controller == 1) {
                                    toLocationLat =
                                        location.latitude!.toDouble();
                                    toLocationLon =
                                        location.longitude!.toDouble();
                                    toLocationAddressController.text =
                                        location.address!;
                                  } else if (controller == 2) {
                                    toLocationLat1 =
                                        location.latitude!.toDouble();
                                    toLocationLon1 =
                                        location.longitude!.toDouble();
                                    toLocationAddressController1.text =
                                        location.address!;
                                  } else {
                                    toLocationLat2 =
                                        location.latitude!.toDouble();
                                    toLocationLon2 =
                                        location.longitude!.toDouble();
                                    toLocationAddressController2.text =
                                        location.address!;
                                  }
                                  searchController.text = location.address!;
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 100.w,
                          height: 1.h,
                          color: AppColors.midGrey.withOpacity(0.5),
                        ),
                      ],
                    ),
              Expanded(
                child: RideCubit.get(context).isSearchingLocation
                    ? LocationPickerSearchPlacesBottomView(
                        mapsPlaces: _mapsPlaces,
                        predictions: _predictions,
                        updateLocation: (lat, lon, address) {
                          if (controller == 1) {
                            toLocationLat = lat;
                            toLocationLon = lon;
                            toLocationAddressController.text = address;
                          } else if (controller == 2) {
                            toLocationLat1 = lat;
                            toLocationLon1 = lon;
                            toLocationAddressController1.text = address;
                          } else {
                            toLocationLat2 = lat;
                            toLocationLon2 = lon;
                            toLocationAddressController2.text = address;
                          }
                          searchController.text = address;
                        },
                      )
                    : RidesHomeRecentLocationView(
                        onRecentLocationSelect: (location) {
                          showDialog(
                            context: context,
                            builder: (context) => const LoadingIndicator(),
                          );
                          setState(() {
                            if (controller == 1) {
                              toLocationLat = location.latitude!.toDouble();
                              toLocationLon = location.latitude!.toDouble();
                              toLocationAddressController.text =
                                  location.address!;
                            } else if (controller == 2) {
                              toLocationLat1 = location.latitude!.toDouble();
                              toLocationLon1 = location.latitude!.toDouble();
                              toLocationAddressController1.text =
                                  location.address!;
                            } else {
                              toLocationLat2 = location.latitude!.toDouble();
                              toLocationLon2 = location.latitude!.toDouble();
                              toLocationAddressController2.text =
                                  location.address!;
                            }
                            searchController.text = location.address!;
                            Navigator.pop(context);
                          });
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: searchController.text.trim().isNotEmpty
                    ? DefaultAppButton(
                        height: 7.h,
                        title: context.confirm,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const LoadingIndicator(),
                          );
                          toLocations.add(toLocations.contains(1)
                              ? toLocations.contains(2)
                                  ? 3
                                  : 2
                              : 1);
                          OrderCubit.get(context).addNewDropOff(
                            addNewDropOff: AddNewDropOff(
                              orderId: int.parse(CacheHelper.sharedPreferences
                                  .get(SharedPreferenceKeys.orderId)
                                  .toString()),
                              toLocationLat: controller == 1
                                  ? toLocationLat
                                  : controller == 2
                                      ? toLocationLat1
                                      : toLocationLat2,
                              toLocationLon: controller == 1
                                  ? toLocationLon
                                  : controller == 2
                                      ? toLocationLon1
                                      : toLocationLon2,
                              toLocationAddress: searchController.text,
                            ),
                            afterError: () {
                              final val = toLocations.removeLast();
                              if (val == 1) {
                                toLocationLat = 0;
                                toLocationLon = 0;
                                toLocationAddressController.clear();
                              } else if (val == 2) {
                                toLocationLat1 = 0;
                                toLocationLon1 = 0;
                                toLocationAddressController1.clear();
                              } else {
                                toLocationLat2 = 0;
                                toLocationLon2 = 0;
                                toLocationAddressController2.clear();
                              }
                              printError("add new location error!");
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            afterSuccess: () {
                              resetToLocations();
                              final orderToLocations = OrderCubit.get(context)
                                  .orderModel!
                                  .toLocation!;
                              for (int i = 0;
                                  i < orderToLocations.length;
                                  i++) {
                                if (i == 0) {
                                  toLocationLat = orderToLocations[i].latitude!;
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
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            },
                          );
                          setState(() {});
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
      ),
    );
  }
}
